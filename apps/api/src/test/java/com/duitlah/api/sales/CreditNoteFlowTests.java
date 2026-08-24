package com.duitlah.api.sales;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
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
 * Duitlah V2 Phase 5. A credit note against an invoice reduces that invoice's computed outstanding
 * amount — see {@code InvoiceService.toResponse}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class CreditNoteFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String customerId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("cn-owner@example.com", "Owner");

    var body = objectMapper.createObjectNode().put("name", "CnCo").put("legalName", "CnCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var customerBody = objectMapper.createObjectNode().put("name", "Client Sdn Bhd");
    var customerResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customerBody.toString()))
            .andReturn();
    customerId =
        objectMapper.readTree(customerResult.getResponse().getContentAsString()).get("id").asText();
  }

  private String register(String email, String name) throws Exception {
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(email, "correct-horse-1", name))))
            .andReturn();
    return objectMapper
        .readTree(result.getResponse().getContentAsString())
        .get("accessToken")
        .asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private String createInvoice() throws Exception {
    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Design work")
                    .put("quantity", "1")
                    .put("unitPrice", "1000.00"));
    var body =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-01")
            .put("dueDate", "2026-09-01")
            .set("lineItems", lineItems);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void issuingACreditNoteAgainstAnInvoiceReducesItsOutstandingAmount() throws Exception {
    String invoiceId = createInvoice();

    var creditNoteBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("invoiceId", invoiceId)
            .put("issueDate", "2026-08-15")
            .put("amount", "200.00")
            .put("reason", "Discount adjustment");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/credit-notes"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(creditNoteBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.creditNoteNumber").value("CN-00001"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("ISSUED"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountCredited").value(200.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountOutstanding").value(800.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.effectiveStatus").value("PARTIALLY_PAID"));
  }

  @Test
  void voidingACreditNoteStopsItCountingAgainstTheInvoice() throws Exception {
    String invoiceId = createInvoice();

    var creditNoteBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("invoiceId", invoiceId)
            .put("issueDate", "2026-08-15")
            .put("amount", "200.00");
    var creditNoteResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/credit-notes"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(creditNoteBody.toString()))
            .andReturn();
    String creditNoteId =
        objectMapper
            .readTree(creditNoteResult.getResponse().getContentAsString())
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/credit-notes/" + creditNoteId + "/void")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("VOID"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountCredited").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountOutstanding").value(1000.00));
  }

  @Test
  void creatingACreditNoteAgainstAnInvoiceFromAnotherSpaceIsNotFound() throws Exception {
    String otherOwnerToken = register("cn-other-owner@example.com", "Other Owner");
    var otherBody =
        objectMapper
            .createObjectNode()
            .put("name", "OtherCnCo")
            .put("legalName", "OtherCnCo Sdn Bhd");
    var otherResult =
        mockMvc
            .perform(
                as(otherOwnerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(otherBody.toString()))
            .andReturn();
    String otherSpaceId =
        objectMapper.readTree(otherResult.getResponse().getContentAsString()).get("id").asText();
    var otherCustomerBody = objectMapper.createObjectNode().put("name", "Other Client");
    var otherCustomerResult =
        mockMvc
            .perform(
                as(
                        otherOwnerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + otherSpaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(otherCustomerBody.toString()))
            .andReturn();
    String otherCustomerId =
        objectMapper
            .readTree(otherCustomerResult.getResponse().getContentAsString())
            .get("id")
            .asText();

    String invoiceId = createInvoice();

    var creditNoteBody =
        objectMapper
            .createObjectNode()
            .put("customerId", otherCustomerId)
            .put("invoiceId", invoiceId)
            .put("issueDate", "2026-08-15")
            .put("amount", "50.00");
    mockMvc
        .perform(
            as(
                    otherOwnerToken,
                    MockMvcRequestBuilders.post("/api/v1/spaces/" + otherSpaceId + "/credit-notes"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(creditNoteBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
