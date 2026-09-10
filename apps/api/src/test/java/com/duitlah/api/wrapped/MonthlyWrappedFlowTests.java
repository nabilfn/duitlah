package com.duitlah.api.wrapped;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.LocalDate;
import java.time.YearMonth;
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
 * End-to-end Monthly Wrapped: real transactions, real HTTP, real persistence — confirms {@link
 * MonthlyAggregationService}/{@link WrappedGenerationService}/{@link WrappedController} are wired
 * together correctly, on top of the pure-logic coverage in {@link MoneyPersonaEngineTest}/{@link
 * MonthlyInsightEngineTest}/{@link GoalRecommendationEngineTest}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class MonthlyWrappedFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String accountId;
  private String cafeCategoryId;
  private LocalDate completedMonthStart;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();
    completedMonthStart = YearMonth.now().minusMonths(1).atDay(1);

    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "wrapped@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(result).get("accessToken").asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    accountId =
        json(mockMvc
                .perform(
                    auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(accountBody.toString()))
                .andReturn())
            .get("id")
            .asText();

    JsonNode categories =
        json(mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/categories"))).andReturn());
    cafeCategoryId = null;
    for (JsonNode category : categories) {
      if (category.get("name").asText().equals("Cafe")) {
        cafeCategoryId = category.get("id").asText();
      }
    }
    assertThat(cafeCategoryId).isNotNull();
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private void postExpense(String amount, String merchant, LocalDate date, String categoryId)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("categoryId", categoryId)
            .put("amount", amount)
            .put("merchant", merchant)
            .put("occurredOn", date.toString());
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  private void seedACompletedMonthOfCafeSpending() throws Exception {
    // 15 expense transactions across 15 distinct days -- clears both the >=10 transactions and
    // >=14 distinct-days minimum-data thresholds (spec section 15).
    String[] merchants = {"ZUS Coffee", "Starbucks", "Coffee Bean"};
    for (int i = 0; i < 15; i++) {
      postExpense(
          "30.00",
          merchants[i % merchants.length],
          completedMonthStart.plusDays(i),
          cafeCategoryId);
    }
  }

  @Test
  void requestingTheCurrentMonthIsRejected() throws Exception {
    LocalDate today = LocalDate.now();
    mockMvc
        .perform(
            auth(
                MockMvcRequestBuilders.get(
                    "/api/v1/wrapped/" + today.getYear() + "/" + today.getMonthValue())))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("MONTH_NOT_COMPLETED"));
  }

  @Test
  void aCompletedMonthOfRealCafeSpendingProducesARealWrappedResult() throws Exception {
    seedACompletedMonthOfCafeSpending();

    var result =
        mockMvc
            .perform(
                auth(
                    MockMvcRequestBuilders.get(
                        "/api/v1/wrapped/"
                            + completedMonthStart.getYear()
                            + "/"
                            + completedMonthStart.getMonthValue())))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();
    JsonNode wrapped = json(result);

    assertThat(wrapped.get("sufficientData").asBoolean()).isTrue();
    assertThat(wrapped.get("overview").get("totalExpense").decimalValue())
        .isEqualByComparingTo("450.00");
    assertThat(wrapped.get("persona").get("id").asText()).isEqualTo("CAFE_HUNTER");
    assertThat(wrapped.get("insights").isArray()).isTrue();
    assertThat(wrapped.get("version").asInt()).isEqualTo(2);
    assertThat(wrapped.at("/story/categories/0/transactionCount").asInt()).isEqualTo(15);
    assertThat(wrapped.at("/story/categories/0/amount").decimalValue()).isEqualByComparingTo("450.00");
    assertThat(wrapped.at("/story/personaMetrics/0/value").asText()).isEqualTo("15");
    assertThat(wrapped.at("/story/suggestedSavingsAmount").isNull()).isTrue();
    assertThat(wrapped.get("recommendedGoal").get("message").asText()).isNotBlank();
  }

  @Test
  void aGeneratedWrappedNeverSilentlyRegeneratesAfterALaterTransactionEdit() throws Exception {
    seedACompletedMonthOfCafeSpending();
    String path =
        "/api/v1/wrapped/"
            + completedMonthStart.getYear()
            + "/"
            + completedMonthStart.getMonthValue();

    JsonNode first = json(mockMvc.perform(auth(MockMvcRequestBuilders.get(path))).andReturn());
    String firstGeneratedAt = first.get("generatedAt").asText();

    // A brand-new transaction posted into the same completed month, after Wrapped already exists.
    postExpense("999.00", "Late Entry", completedMonthStart.plusDays(20), cafeCategoryId);

    JsonNode second = json(mockMvc.perform(auth(MockMvcRequestBuilders.get(path))).andReturn());

    assertThat(second.get("generatedAt").asText()).isEqualTo(firstGeneratedAt);
    assertThat(second.get("story")).isEqualTo(first.get("story"));
    // The persisted total must still reflect the original 15 transactions only.
    assertThat(second.get("overview").get("totalExpense").decimalValue())
        .isEqualByComparingTo("450.00");
  }

  @Test
  void appearsInHistoryAndCanBeMarkedViewed() throws Exception {
    seedACompletedMonthOfCafeSpending();
    mockMvc.perform(
        auth(
            MockMvcRequestBuilders.get(
                "/api/v1/wrapped/"
                    + completedMonthStart.getYear()
                    + "/"
                    + completedMonthStart.getMonthValue())));

    JsonNode history =
        json(mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/wrapped"))).andReturn());
    boolean found = false;
    for (JsonNode row : history) {
      if (row.get("year").asInt() == completedMonthStart.getYear()
          && row.get("month").asInt() == completedMonthStart.getMonthValue()) {
        found = true;
        assertThat(row.get("viewed").asBoolean()).isFalse();
      }
    }
    assertThat(found).isTrue();

    mockMvc
        .perform(
            auth(
                MockMvcRequestBuilders.post(
                    "/api/v1/wrapped/"
                        + completedMonthStart.getYear()
                        + "/"
                        + completedMonthStart.getMonthValue()
                        + "/viewed")))
        .andExpect(MockMvcResultMatchers.status().isOk());

    JsonNode historyAfter =
        json(mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/wrapped"))).andReturn());
    for (JsonNode row : historyAfter) {
      if (row.get("year").asInt() == completedMonthStart.getYear()
          && row.get("month").asInt() == completedMonthStart.getMonthValue()) {
        assertThat(row.get("viewed").asBoolean()).isTrue();
      }
    }
  }

  @Test
  void promoCardOffersLastMonthsWrappedUntilItIsViewed() throws Exception {
    seedACompletedMonthOfCafeSpending();

    JsonNode beforeGenerated =
        json(
            mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/wrapped/promo"))).andReturn());
    // The scheduled job hasn't run in this test, and nothing has requested this month's Wrapped
    // yet either, so there's genuinely nothing to promote.
    assertThat(beforeGenerated.get("available").asBoolean()).isFalse();

    mockMvc.perform(
        auth(
            MockMvcRequestBuilders.get(
                "/api/v1/wrapped/"
                    + completedMonthStart.getYear()
                    + "/"
                    + completedMonthStart.getMonthValue())));

    JsonNode afterGenerated =
        json(
            mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/wrapped/promo"))).andReturn());
    assertThat(afterGenerated.get("available").asBoolean()).isTrue();
    assertThat(afterGenerated.get("personaName").asText()).isEqualTo("Cafe Hunter");

    mockMvc.perform(
        auth(
            MockMvcRequestBuilders.post(
                "/api/v1/wrapped/"
                    + completedMonthStart.getYear()
                    + "/"
                    + completedMonthStart.getMonthValue()
                    + "/viewed")));

    JsonNode afterViewed =
        json(
            mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/wrapped/promo"))).andReturn());
    assertThat(afterViewed.get("available").asBoolean()).isFalse();
  }

  @Test
  void nonOwnerCannotSeeAnotherUsersWrapped() throws Exception {
    seedACompletedMonthOfCafeSpending();
    mockMvc.perform(
        auth(
            MockMvcRequestBuilders.get(
                "/api/v1/wrapped/"
                    + completedMonthStart.getYear()
                    + "/"
                    + completedMonthStart.getMonthValue())));

    var other =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "wrapped-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();

    JsonNode otherHistory =
        objectMapper.readTree(
            mockMvc
                .perform(
                    MockMvcRequestBuilders.get("/api/v1/wrapped")
                        .header("Authorization", "Bearer " + otherToken))
                .andReturn()
                .getResponse()
                .getContentAsString());
    assertThat(otherHistory).isEmpty();
  }
}
