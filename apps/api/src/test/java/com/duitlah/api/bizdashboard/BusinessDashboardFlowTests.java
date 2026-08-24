package com.duitlah.api.bizdashboard;

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
 * Duitlah V2 Phase 5. Every number here is recomputed from the owning module's own service, not
 * stored — see package-info.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BusinessDashboardFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("dash-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "DashCo").put("legalName", "DashCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
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

  @Test
  void anEmptySpaceHasAZeroDashboard() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/business-dashboard")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.cashPosition").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalReceivables").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalPayables").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.customerCount").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.supplierCount").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.productCount").value(0));
  }

  @Test
  void cashPositionReflectsBusinessAccountBalancesAndPayablesReflectUnpaidExpenses()
      throws Exception {
    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Main Bank")
            .put("type", "BANK")
            .put("openingBalance", "10000.00");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/business-accounts"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(accountBody.toString()));

    var supplierBody = objectMapper.createObjectNode().put("name", "Vendor Sdn Bhd");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/suppliers"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(supplierBody.toString()));

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("category", "Rent")
            .put("amount", "1500.00")
            .put("occurredOn", "2026-08-01");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/expenses"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(expenseBody.toString()));

    var customerBody = objectMapper.createObjectNode().put("name", "Buyer Sdn Bhd");
    var customerResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customerBody.toString()))
            .andReturn();
    String customerId =
        objectMapper.readTree(customerResult.getResponse().getContentAsString()).get("id").asText();

    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Goods")
                    .put("quantity", "1")
                    .put("unitPrice", "2000.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-01")
            .put("dueDate", "2026-09-01")
            .set("lineItems", lineItems);
    var invoiceResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(invoiceBody.toString()))
            .andReturn();
    String invoiceId =
        objectMapper.readTree(invoiceResult.getResponse().getContentAsString()).get("id").asText();
    var sendStatus = objectMapper.createObjectNode().put("status", "SENT");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(sendStatus.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/business-dashboard")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.cashPosition").value(10000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalPayables").value(1500.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalReceivables").value(2000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.customerCount").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$.supplierCount").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$.unpaidExpenseCount").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$.openInvoiceCount").value(1));
  }
}
