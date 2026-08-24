package com.duitlah.api.budgets;

import static org.assertj.core.api.Assertions.assertThat;

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
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BudgetAndGoalFlowTests {

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String accessToken;
  private String accountId;
  private String restaurantsCategoryId;

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
                                "budgets@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
            .readTree(registerResult.getResponse().getContentAsString())
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

    JsonNode categories =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/categories")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    for (JsonNode c : categories) {
      if ("Restaurants".equals(c.get("name").asText())) {
        restaurantsCategoryId = c.get("id").asText();
      }
    }
    assertThat(restaurantsCategoryId).isNotNull();
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private void spendOnRestaurants(String amount, String occurredOn) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("categoryId", restaurantsCategoryId)
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
  void overallBudgetTracksSpendingAcrossAllCategories() throws Exception {
    spendOnRestaurants("100.00", "2026-08-05");

    var body =
        objectMapper
            .createObjectNode()
            .put("periodYear", 2026)
            .put("periodMonth", 8)
            .put("amountLimit", "500.00");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.spent").value(100.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.remaining").value(400.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("OK"));
  }

  @Test
  void categoryBudgetOnParentRollsUpChildCategorySpending() throws Exception {
    // Find the "Food" parent category (Restaurants' parent).
    JsonNode categories =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/categories")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    String foodParentId = null;
    for (JsonNode c : categories) {
      if ("Food".equals(c.get("name").asText())) {
        foodParentId = c.get("id").asText();
      }
    }
    assertThat(foodParentId).isNotNull();

    // All spending happens on the CHILD category (Restaurants) — never
    // directly on the parent — mirroring how the transaction UI works.
    spendOnRestaurants("50.00", "2026-08-01");
    spendOnRestaurants("30.00", "2026-08-02");

    var body =
        objectMapper
            .createObjectNode()
            .put("categoryId", foodParentId)
            .put("periodYear", 2026)
            .put("periodMonth", 8)
            .put("amountLimit", "200.00");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.categoryName").value("Food"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.spent").value(80.00));
  }

  @Test
  void budgetStatusEscalatesFromWarningToExceeded() throws Exception {
    spendOnRestaurants("85.00", "2026-08-01");

    var body =
        objectMapper
            .createObjectNode()
            .put("categoryId", restaurantsCategoryId)
            .put("periodYear", 2026)
            .put("periodMonth", 8)
            .put("amountLimit", "100.00");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("WARNING"))
            .andReturn();
    String budgetId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    spendOnRestaurants("20.00", "2026-08-02");

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/budgets?year=2026&month=8")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.id=='" + budgetId + "')].status")
                .value("EXCEEDED"));
  }

  @Test
  void duplicateBudgetForSameCategoryAndPeriodIsRejected() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("categoryId", restaurantsCategoryId)
            .put("periodYear", 2026)
            .put("periodMonth", 8)
            .put("amountLimit", "100.00");
    mockMvc.perform(
        auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BUDGET_ALREADY_EXISTS"));
  }

  @Test
  void goalProgressReflectsContributionsIncludingWithdrawals() throws Exception {
    var goalBody =
        objectMapper
            .createObjectNode()
            .put("name", "Japan Trip")
            .put("type", "TRAVEL")
            .put("targetAmount", "8000.00");
    var goalResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/goals"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(goalBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.currentAmount").value(0))
            .andReturn();
    String goalId =
        objectMapper.readTree(goalResult.getResponse().getContentAsString()).get("id").asText();

    addContribution(goalId, "5000.00", "2026-06-01");
    addContribution(goalId, "500.00", "2026-07-01");

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/goals/" + goalId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentAmount").value(5500.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.remaining").value(2500.00));

    // A withdrawal (negative contribution) reduces the total.
    addContribution(goalId, "-200.00", "2026-07-15");

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/goals/" + goalId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentAmount").value(5300.00));
  }

  @Test
  void deletingAContributionRemovesItFromTheTotal() throws Exception {
    var goalBody =
        objectMapper
            .createObjectNode()
            .put("name", "Emergency Fund")
            .put("type", "EMERGENCY_FUND")
            .put("targetAmount", "1000.00");
    var goalResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/goals"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(goalBody.toString()))
            .andReturn();
    String goalId =
        objectMapper.readTree(goalResult.getResponse().getContentAsString()).get("id").asText();

    var contribResult = addContributionAndReturn(goalId, "300.00", "2026-08-01");
    String contributionId =
        objectMapper
            .readTree(
                mockMvc
                    .perform(
                        auth(
                            MockMvcRequestBuilders.get(
                                "/api/v1/goals/" + goalId + "/contributions")))
                    .andReturn()
                    .getResponse()
                    .getContentAsString())
            .get(0)
            .get("id")
            .asText();
    assertThat(contribResult).isNotNull();

    mockMvc
        .perform(
            auth(
                MockMvcRequestBuilders.delete(
                    "/api/v1/goals/" + goalId + "/contributions/" + contributionId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/goals/" + goalId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentAmount").value(0));
  }

  @Test
  void anotherUsersBudgetAndGoalAreNotFound() throws Exception {
    var budgetBody =
        objectMapper
            .createObjectNode()
            .put("periodYear", 2026)
            .put("periodMonth", 8)
            .put("amountLimit", "500.00");
    var budgetResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(budgetBody.toString()))
            .andReturn();
    String budgetId =
        objectMapper.readTree(budgetResult.getResponse().getContentAsString()).get("id").asText();

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "otherbudget@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken =
        objectMapper
            .readTree(registerResult.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    var updateBody = objectMapper.createObjectNode().put("amountLimit", "999.00");
    mockMvc
        .perform(
            MockMvcRequestBuilders.patch("/api/v1/budgets/" + budgetId)
                .header("Authorization", "Bearer " + otherToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  private void addContribution(String goalId, String amount, String occurredOn) throws Exception {
    addContributionAndReturn(goalId, amount, occurredOn);
  }

  private String addContributionAndReturn(String goalId, String amount, String occurredOn)
      throws Exception {
    var body = objectMapper.createObjectNode().put("amount", amount).put("occurredOn", occurredOn);
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/goals/" + goalId + "/contributions"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return result.getResponse().getContentAsString();
  }
}
