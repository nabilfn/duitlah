package com.duitlah.api.ai;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
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
 * No ANTHROPIC_API_KEY is set in the test environment, so {@code aiChatService} resolves to {@link
 * UnavailableAiChatService} here (see AiConfig) -- these tests exercise the real, deterministic
 * {@link AffordabilityService} plus the graceful "not configured" chat path, not a live call to
 * Anthropic.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AiFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String accountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest("ai@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
            .readTree(result.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    var accountResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId =
        objectMapper.readTree(accountResult.getResponse().getContentAsString()).get("id").asText();
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private void postTransaction(String type, String amount, String occurredOn) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", type)
            .put("amount", amount)
            .put("occurredOn", occurredOn);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  @Test
  void affordabilityReflectsRealBalanceNotAnInventedNumber() throws Exception {
    postTransaction("INCOME", "1000.00", "2026-08-01");

    var body = objectMapper.createObjectNode().put("amount", "300.00").put("description", "Shoes");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/ai/affordability"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

    JsonNode response = objectMapper.readTree(result.getResponse().getContentAsString());
    assertThat(response.get("currentBalance").decimalValue()).isEqualByComparingTo("1000.00");
    BigDecimal projectedIfWaited = response.get("projectedBalanceIfWaited").decimalValue();
    BigDecimal projectedIfPurchased = response.get("projectedBalanceIfPurchased").decimalValue();
    assertThat(projectedIfPurchased)
        .isEqualByComparingTo(projectedIfWaited.subtract(new BigDecimal("300.00")));
    assertThat(response.get("canAfford").asBoolean()).isTrue();
    assertThat(response.get("narrative").asText()).isNotBlank();
    assertThat(response.get("disclaimer").asText()).isNotBlank();
  }

  @Test
  void affordabilitySaysNoWhenThePurchaseWouldOverdraw() throws Exception {
    // No income at all -- balance is 0, so any real purchase should read as unaffordable.
    var body = objectMapper.createObjectNode().put("amount", "50.00");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/ai/affordability"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.canAfford").value(false));
  }

  @Test
  void chatWithoutAConfiguredProviderReturnsAnHonestFixedReplyRatherThanAFakeAnswer()
      throws Exception {
    var body = objectMapper.createObjectNode().put("message", "Where did my money go this month?");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/ai/chat"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.available").value(false))
        .andExpect(MockMvcResultMatchers.jsonPath("$.reply").isNotEmpty());
  }

  @Test
  void affordabilityRejectsAZeroAmount() throws Exception {
    var body = objectMapper.createObjectNode().put("amount", "0");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/ai/affordability"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest());
  }

  /**
   * V2 Phase 12 (spec section 68): an upcoming bill due within the forecast window is a real
   * obligation and must be folded into {@code totalObligations} -- and therefore {@code canAfford}
   * -- not just informational context.
   */
  @Test
  void affordabilityFoldsAnUpcomingBillIntoObligationsAndCanAfford() throws Exception {
    postTransaction("INCOME", "1000.00", "2026-08-01");

    var billBody =
        objectMapper
            .createObjectNode()
            .put("name", "Electricity")
            .put("dueDate", java.time.LocalDate.now().toString())
            .put("expectedAmount", "900.00");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/personal-bills"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(billBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    var body = objectMapper.createObjectNode().put("amount", "50.00").put("description", "Snacks");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/ai/affordability"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

    JsonNode response = objectMapper.readTree(result.getResponse().getContentAsString());
    assertThat(response.get("upcomingBillsTotal").decimalValue()).isEqualByComparingTo("900.00");
    assertThat(response.get("debtRepaymentsTotal").decimalValue()).isEqualByComparingTo("0.00");
    assertThat(response.get("totalObligations").decimalValue())
        .isEqualByComparingTo(
            response.get("totalOwedToOthers").decimalValue().add(new BigDecimal("900.00")));
    // RM1000 balance - RM50 purchase - RM900 bill = RM50 left: still affordable but tight.
    assertThat(response.get("canAfford").asBoolean()).isTrue();
    assertThat(response.get("totalSavingsGoalsRemaining").decimalValue())
        .isEqualByComparingTo("0.00");
    assertThat(response.get("budgetRemainingThisPeriod").decimalValue())
        .isEqualByComparingTo("0.00");
    assertThat(response.get("averageCreditUtilization").isNull()).isTrue();
  }
}
