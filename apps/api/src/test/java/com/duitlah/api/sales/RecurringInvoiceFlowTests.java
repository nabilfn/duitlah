package com.duitlah.api.sales;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.LocalDate;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

/**
 * V2 Phase 13 -- recurring invoices, the {@code sales} mirror of {@code
 * recurring.RecurringTransaction}'s own tests. Every materialized invoice is DRAFT (never
 * auto-sent) and points back at the rule that produced it via {@code sourceRecurringInvoiceId}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class RecurringInvoiceFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private RecurringInvoiceService recurringInvoiceService;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String customerId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "recinv-owner@example.com", "correct-horse-1", "Owner"))))
            .andReturn();
    ownerToken = json(registerResult).get("accessToken").asText();

    var spaceBody =
        objectMapper
            .createObjectNode()
            .put("name", "RecInvCo")
            .put("legalName", "RecInvCo Sdn Bhd");
    var spaceResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(spaceBody.toString()))
            .andReturn();
    spaceId = json(spaceResult).get("id").asText();

    var customerBody = objectMapper.createObjectNode().put("name", "Retainer Client Sdn Bhd");
    var customerResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customerBody.toString()))
            .andReturn();
    customerId = json(customerResult).get("id").asText();
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + ownerToken);
  }

  private JsonNode json(org.springframework.test.web.servlet.MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private String createRecurringInvoice(LocalDate startDate) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("taxPercent", "0")
            .put("paymentTermDays", 14)
            .put("frequency", "MONTHLY")
            .put("intervalCount", 1)
            .put("startDate", startDate.toString());
    var lineItems = body.putArray("lineItems");
    lineItems
        .addObject()
        .put("description", "Monthly retainer")
        .put("quantity", "1")
        .put("unitPrice", "1500.00");

    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/recurring-invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return json(result).get("id").asText();
  }

  @Test
  void createsListsAndPausesARecurringInvoice() throws Exception {
    String ruleId = createRecurringInvoice(LocalDate.of(2026, 9, 1));

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/recurring-invoices")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].active").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].lineItems.length()").value(1));

    var pauseBody = objectMapper.createObjectNode().put("active", false);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/recurring-invoices/" + ruleId + "/active"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(pauseBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.active").value(false));
  }

  @Test
  void materializingADueScheduleCreatesADraftInvoicePointingBackAtTheRuleAndAdvancesTheSchedule()
      throws Exception {
    createRecurringInvoice(LocalDate.of(2026, 9, 1));

    int created = recurringInvoiceService.materializeAllDue(LocalDate.of(2026, 9, 1));
    assertThat(created).isEqualTo(1);

    var invoicesResult =
        mockMvc
            .perform(auth(MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices")))
            .andReturn();
    JsonNode invoices = json(invoicesResult);
    assertThat(invoices).hasSize(1);
    assertThat(invoices.get(0).get("status").asText()).isEqualTo("DRAFT");
    assertThat(invoices.get(0).get("sourceRecurringInvoiceId").isNull()).isFalse();
    assertThat(invoices.get(0).get("total").decimalValue()).isEqualByComparingTo("1500.00");
    assertThat(invoices.get(0).get("dueDate").asText()).isEqualTo("2026-09-15");
  }

  @Test
  void materializingTwiceOnTheSameDueDateDoesNotDoubleCreateAnInvoice() throws Exception {
    createRecurringInvoice(LocalDate.of(2026, 9, 1));

    int firstRun = recurringInvoiceService.materializeAllDue(LocalDate.of(2026, 9, 1));
    int secondRun = recurringInvoiceService.materializeAllDue(LocalDate.of(2026, 9, 1));
    assertThat(firstRun).isEqualTo(1);
    assertThat(secondRun).isEqualTo(0);

    var invoicesResult =
        mockMvc
            .perform(auth(MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices")))
            .andReturn();
    assertThat(json(invoicesResult)).hasSize(1);
  }

  @Test
  void aMissedRunCatchesUpByCreatingOneInvoicePerElapsedMonth() throws Exception {
    createRecurringInvoice(LocalDate.of(2026, 6, 1));

    int created = recurringInvoiceService.materializeAllDue(LocalDate.of(2026, 9, 1));
    assertThat(created).isEqualTo(4);

    var invoicesResult =
        mockMvc
            .perform(auth(MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices")))
            .andReturn();
    assertThat(json(invoicesResult)).hasSize(4);
  }

  @Test
  void deletingARecurringInvoiceRemovesItFromTheList() throws Exception {
    String ruleId = createRecurringInvoice(LocalDate.of(2026, 9, 1));

    mockMvc
        .perform(
            auth(
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/recurring-invoices/" + ruleId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/recurring-invoices")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }
}
