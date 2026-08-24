package com.duitlah.api.analytics;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.recurring.RecurringTransactionService;
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

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AnalyticsFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private RecurringTransactionService recurringTransactionService;

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
                            new RegisterRequest(
                                "analytics@example.com", "correct-horse-1", "Nabil"))))
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

  private void postTransaction(String type, String amount, String merchant, String occurredOn)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", type)
            .put("amount", amount)
            .put("merchant", merchant)
            .put("occurredOn", occurredOn);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  @Test
  void monthlyTrendCoversTheRequestedNumberOfMonths() throws Exception {
    postTransaction("INCOME", "1000.00", null, "2026-08-05");
    postTransaction("EXPENSE", "300.00", null, "2026-08-06");

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.get("/api/v1/analytics/monthly-trend"))
                .param("months", "3"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(3));
  }

  @Test
  void topMerchantsRanksByExpenseTotalDescending() throws Exception {
    postTransaction("EXPENSE", "10.00", "Kopitiam", "2026-08-05");
    postTransaction("EXPENSE", "40.00", "Kopitiam", "2026-08-06");
    postTransaction("EXPENSE", "25.00", "Grab", "2026-08-07");

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.get("/api/v1/analytics/merchants"))
                .param("year", "2026")
                .param("month", "8"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].merchant").value("Kopitiam"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].amount").value(50.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].transactionCount").value(2))
        .andExpect(MockMvcResultMatchers.jsonPath("$[1].merchant").value("Grab"));
  }

  @Test
  void spendingByCategoryRollsUpChildCategoriesIntoTheirParent() throws Exception {
    JsonNode categories =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/categories")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    String restaurantsId = null;
    for (JsonNode c : categories) {
      if ("Restaurants".equals(c.get("name").asText())) {
        restaurantsId = c.get("id").asText();
      }
    }
    assertThat(restaurantsId).isNotNull();

    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("categoryId", restaurantsId)
            .put("amount", "35.00")
            .put("occurredOn", "2026-08-05");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.get("/api/v1/analytics/spending-by-category"))
                .param("year", "2026")
                .param("month", "8"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.categoryName == 'Food')].amount").value(35.00));
  }

  @Test
  void calendarShowsBothPostedTransactionsAndProjectedRecurringOccurrences() throws Exception {
    postTransaction("EXPENSE", "12.00", "Cafe", "2026-08-05");

    var ruleBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "15.90")
            .put("frequency", "MONTHLY")
            .put("startDate", "2026-08-20")
            .put("isSubscription", true);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/recurring-transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(ruleBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.get("/api/v1/analytics/calendar"))
                .param("year", "2026")
                .param("month", "8"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.date == '2026-08-05')].confirmed").value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.date == '2026-08-20')].confirmed").value(false));
  }

  @Test
  void forecastDistinguishesScheduledFromCurrentBalance() throws Exception {
    postTransaction("INCOME", "500.00", null, LocalDate.now().withDayOfMonth(1).toString());

    var ruleBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "20.00")
            .put("frequency", "DAILY")
            .put("startDate", LocalDate.now().plusDays(1).toString())
            .put("isSubscription", false);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/recurring-transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(ruleBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/analytics/forecast")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentBalance").value(500.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.scheduledExpense").isNumber())
        .andExpect(MockMvcResultMatchers.jsonPath("$.disclaimer").isNotEmpty());
  }
}
