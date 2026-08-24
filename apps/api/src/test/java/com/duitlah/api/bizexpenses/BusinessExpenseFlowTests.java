package com.duitlah.api.bizexpenses;

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
 * Duitlah V2 Phase 5. Also exercises payables: an expense with a supplier IS the bill — see
 * package-info.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BusinessExpenseFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String viewerToken;
  private String spaceId;
  private String supplierId;
  private String businessAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("exp-owner@example.com", "Owner");
    register("exp-viewer@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "ExpCo").put("legalName", "ExpCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper
            .createObjectNode()
            .put("email", "exp-viewer@example.com")
            .put("role", "VIEWER");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    viewerToken = login("exp-viewer@example.com");

    var supplierBody = objectMapper.createObjectNode().put("name", "Office Supplies Sdn Bhd");
    var supplierResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/suppliers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(supplierBody.toString()))
            .andReturn();
    supplierId =
        objectMapper.readTree(supplierResult.getResponse().getContentAsString()).get("id").asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Ops Account")
            .put("type", "BANK")
            .put("openingBalance", "5000.00");
    var accountResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/business-accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    businessAccountId =
        objectMapper.readTree(accountResult.getResponse().getContentAsString()).get("id").asText();
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

  private String login(String email) throws Exception {
    var body =
        objectMapper.createObjectNode().put("email", email).put("password", "correct-horse-1");
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper
        .readTree(result.getResponse().getContentAsString())
        .get("accessToken")
        .asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private String createExpense(String amount) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("supplierId", supplierId)
            .put("category", "Office Supplies")
            .put("amount", amount)
            .put("occurredOn", "2026-08-01");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/expenses"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void creatingAnExpenseStartsUnpaidWithNothingPaid() throws Exception {
    createExpense("300.00");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/expenses")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].status").value("UNPAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].amountPaid").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].amountRemaining").value(300.00));
  }

  @Test
  void aViewerWithoutRecordExpensesCannotCreateOne() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("category", "Blocked")
            .put("amount", "10.00")
            .put("occurredOn", "2026-08-01");
    mockMvc
        .perform(
            as(viewerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void aPartialPaymentMarksTheExpensePartiallyPaidAndDebitsTheAccount() throws Exception {
    String expenseId = createExpense("300.00");

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", businessAccountId)
            .put("amount", "100.00")
            .put("paidOn", "2026-08-03");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/expenses/" + expenseId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(paymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/expenses/" + expenseId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PARTIALLY_PAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountPaid").value(100.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountRemaining").value(200.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + businessAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(4900.00));
  }

  @Test
  void payingTheFullRemainingAmountMarksTheExpensePaid() throws Exception {
    String expenseId = createExpense("300.00");

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", businessAccountId)
            .put("amount", "300.00")
            .put("paidOn", "2026-08-03");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/expenses/" + expenseId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(paymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/expenses/" + expenseId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountRemaining").value(0.00));
  }

  @Test
  void creatingAnExpenseWithASupplierFromAnotherSpaceIsNotFound() throws Exception {
    String otherOwnerToken = register("exp-other-owner@example.com", "Other Owner");
    var otherSpaceBody =
        objectMapper
            .createObjectNode()
            .put("name", "OtherExpCo")
            .put("legalName", "OtherExpCo Sdn Bhd");
    var otherSpaceResult =
        mockMvc
            .perform(
                as(otherOwnerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(otherSpaceBody.toString()))
            .andReturn();
    String otherSpaceId =
        objectMapper
            .readTree(otherSpaceResult.getResponse().getContentAsString())
            .get("id")
            .asText();

    var body =
        objectMapper
            .createObjectNode()
            .put("supplierId", supplierId)
            .put("category", "Cross-space")
            .put("amount", "50.00")
            .put("occurredOn", "2026-08-01");
    mockMvc
        .perform(
            as(
                    otherOwnerToken,
                    MockMvcRequestBuilders.post("/api/v1/spaces/" + otherSpaceId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
