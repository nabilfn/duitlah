package com.duitlah.api.liabilities;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
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
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

/**
 * A card's outstanding/utilization comes straight from {@code AccountService#balanceOf} — a
 * purchase (EXPENSE) pushes the account balance negative, and a repayment (TRANSFER) brings it back
 * toward zero, with zero new transaction-writing logic. See {@link CreditCardService}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class CreditCardFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String cardAccountId;
  private String cashAccountId;

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
                            new RegisterRequest("card@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();

    cardAccountId = createAccount("Visa Card", "CREDIT_CARD");
    cashAccountId = createAccount("Wallet", "CASH");

    var detailsBody =
        objectMapper
            .createObjectNode()
            .put("creditLimit", "5000.00")
            .put("statementDay", 1)
            .put("paymentDueDay", 20);
    mockMvc.perform(
        as(
                accessToken,
                MockMvcRequestBuilders.put(
                    "/api/v1/accounts/" + cardAccountId + "/credit-card-details"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(detailsBody.toString()));
  }

  private String createAccount(String name, String type) throws Exception {
    var body = objectMapper.createObjectNode().put("name", name).put("type", type);
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return json(result).get("id").asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void aFreshCardHasNoOutstandingBalance() throws Exception {
    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/accounts/" + cardAccountId + "/credit-card-details")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentOutstanding").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.availableCredit").value(5000.00));
  }

  @Test
  void aPurchaseIncreasesOutstandingAndUtilizationWithoutTouchingAvailableCredit()
      throws Exception {
    var purchaseBody =
        objectMapper
            .createObjectNode()
            .put("accountId", cardAccountId)
            .put("type", "EXPENSE")
            .put("amount", "1000.00")
            .put("occurredOn", "2026-08-05");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(purchaseBody.toString()));

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/accounts/" + cardAccountId + "/credit-card-details")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentOutstanding").value(1000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.availableCredit").value(4000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.utilization").value(0.2));
  }

  @Test
  void repayingTheCardIsATransferNotASecondExpense() throws Exception {
    var purchaseBody =
        objectMapper
            .createObjectNode()
            .put("accountId", cardAccountId)
            .put("type", "EXPENSE")
            .put("amount", "1000.00")
            .put("occurredOn", "2026-08-05");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(purchaseBody.toString()));

    var repaymentBody =
        objectMapper
            .createObjectNode()
            .put("fromAccountId", cashAccountId)
            .put("toAccountId", cardAccountId)
            .put("amount", "400.00")
            .put("occurredOn", "2026-08-10");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions/transfer"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(repaymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/accounts/" + cardAccountId + "/credit-card-details")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentOutstanding").value(600.00));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/dashboard")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.monthExpense").value(1000.00));
  }

  @Test
  void settingDetailsOnANonCreditCardAccountIsRejected() throws Exception {
    var detailsBody =
        objectMapper
            .createObjectNode()
            .put("creditLimit", "5000.00")
            .put("statementDay", 1)
            .put("paymentDueDay", 20);
    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.put(
                        "/api/v1/accounts/" + cashAccountId + "/credit-card-details"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(detailsBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("NOT_A_CREDIT_CARD_ACCOUNT"));
  }
}
