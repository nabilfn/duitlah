package com.duitlah.api.groups;

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

/**
 * Phase 11: Trip mode, Housemate mode, and Shared goals (Couple mode has no new backend surface).
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class SpecialGroupModesFlowTests {

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String ownerToken;
  private String ownerUserId;
  private String memberToken;
  private String memberUserId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var owner = registerAndReturn("owner@example.com", "Nabil");
    ownerToken = owner.get("accessToken").asText();
    ownerUserId = owner.get("user").get("id").asText();

    var member = registerAndReturn("member@example.com", "Ameer");
    memberToken = member.get("accessToken").asText();
    memberUserId = member.get("user").get("id").asText();
  }

  private JsonNode registerAndReturn(String email, String name) throws Exception {
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(email, "correct-horse-1", name))))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private String createGroupAndReturnId(String type) throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Tokyo 2027").put("type", type);
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private void joinGroup(String groupId, String token) throws Exception {
    String inviteToken =
        objectMapper
            .readTree(
                mockMvc
                    .perform(
                        as(
                            ownerToken,
                            MockMvcRequestBuilders.post(
                                "/api/v1/groups/" + groupId + "/invite-token")))
                    .andReturn()
                    .getResponse()
                    .getContentAsString())
            .get("token")
            .asText();
    var joinBody = objectMapper.createObjectNode().put("token", inviteToken);
    mockMvc
        .perform(
            as(token, MockMvcRequestBuilders.post("/api/v1/groups/join"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(joinBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());
  }

  @Test
  void sharedGoalTracksContributionsFromMultipleMembersWithABreakdown() throws Exception {
    String groupId = createGroupAndReturnId("TRIP");
    joinGroup(groupId, memberToken);

    var goalBody =
        objectMapper
            .createObjectNode()
            .put("name", "Japan Trip")
            .put("targetAmount", "8000.00")
            .put("targetDate", "2027-03-01");
    var goalResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/goals"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(goalBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.currentAmount").value(0))
            .andReturn();
    String goalId =
        objectMapper.readTree(goalResult.getResponse().getContentAsString()).get("id").asText();

    contribute(groupId, goalId, ownerToken, "2500.00");
    contribute(groupId, goalId, memberToken, "1320.00");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/groups/" + groupId + "/goals/" + goalId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.currentAmount").value(3820.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.remaining").value(4180.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.byMember[?(@.userId=='" + ownerUserId + "')].totalContributed")
                .value(2500.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.byMember[?(@.userId=='" + memberUserId + "')].totalContributed")
                .value(1320.00));
  }

  private void contribute(String groupId, String goalId, String token, String amount)
      throws Exception {
    var body =
        objectMapper.createObjectNode().put("amount", amount).put("occurredOn", "2026-08-01");
    mockMvc
        .perform(
            as(
                    token,
                    MockMvcRequestBuilders.post(
                        "/api/v1/groups/" + groupId + "/goals/" + goalId + "/contributions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  @Test
  void onlyOwnerOrContributorCanDeleteAGoalContribution() throws Exception {
    String groupId = createGroupAndReturnId("TRIP");
    joinGroup(groupId, memberToken);

    var goalBody =
        objectMapper.createObjectNode().put("name", "Deposit").put("targetAmount", "1000.00");
    String goalId =
        objectMapper
            .readTree(
                mockMvc
                    .perform(
                        as(
                                ownerToken,
                                MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/goals"))
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(goalBody.toString()))
                    .andReturn()
                    .getResponse()
                    .getContentAsString())
            .get("id")
            .asText();

    var contribBody =
        objectMapper.createObjectNode().put("amount", "200.00").put("occurredOn", "2026-08-01");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/groups/" + groupId + "/goals/" + goalId + "/contributions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(contribBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    // The create endpoint returns the parent goal (same shape as personal goals), so the
    // contribution's own id comes from the list endpoint instead.
    var listResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/groups/" + groupId + "/goals/" + goalId + "/contributions")))
            .andReturn();
    String realContributionId =
        objectMapper
            .readTree(listResult.getResponse().getContentAsString())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                memberToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/groups/"
                        + groupId
                        + "/goals/"
                        + goalId
                        + "/contributions/"
                        + realContributionId)))
        .andExpect(MockMvcResultMatchers.status().isForbidden());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/groups/"
                        + groupId
                        + "/goals/"
                        + goalId
                        + "/contributions/"
                        + realContributionId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());
  }

  @Test
  void tripBudgetTracksSpentAndRemainingAcrossCategories() throws Exception {
    String groupId = createGroupAndReturnId("TRIP");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.put("/api/v1/groups/" + groupId + "/budget"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("amount", "12000.00").toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.amount").value(12000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.spent").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.remaining").value(12000.00));

    var flightExpense =
        objectMapper
            .createObjectNode()
            .put("description", "Flights")
            .put("amount", "3200.00")
            .put("occurredOn", "2027-03-01")
            .put("category", "FLIGHTS");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(flightExpense.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/groups/" + groupId + "/trip-summary")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.spent").value(3200.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.remaining").value(8800.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.spendingByCategory[0].category").value("FLIGHTS"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.spendingByCategory[0].amount").value(3200.00));
  }

  @Test
  void expenseWithACurrencySnapshotStoresOriginalAmountSeparatelyFromMyrAmount() throws Exception {
    String groupId = createGroupAndReturnId("TRIP");

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("description", "Ramen dinner")
            .put("amount", "54.90")
            .put("occurredOn", "2027-03-02")
            .put("category", "FOOD")
            .put("originalCurrency", "JPY")
            .put("originalAmount", "1800.00")
            .put("exchangeRate", "0.0305");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(expenseBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.amount").value(54.90))
        .andExpect(MockMvcResultMatchers.jsonPath("$.originalCurrency").value("JPY"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.originalAmount").value(1800.00));
  }

  @Test
  void incompleteCurrencySnapshotIsRejected() throws Exception {
    String groupId = createGroupAndReturnId("TRIP");

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("description", "Ramen dinner")
            .put("amount", "54.90")
            .put("occurredOn", "2027-03-02")
            .put("originalCurrency", "JPY");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(expenseBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INCOMPLETE_CURRENCY_SNAPSHOT"));
  }

  @Test
  void invalidCurrencyCodeIsRejectedAndAValidOneIsNormalizedToUppercase() throws Exception {
    String groupId = createGroupAndReturnId("TRIP");

    // Only the *shape* (3 letters) is validated, not a real ISO 4217 lookup -- "12x" is malformed
    // by shape (a digit), which is genuinely rejected; a fictional-but-3-letter code like "YEN"
    // would incorrectly pass, but that's outside what this constraint is designed to catch.
    var badBody =
        objectMapper
            .createObjectNode()
            .put("description", "Ramen dinner")
            .put("amount", "54.90")
            .put("occurredOn", "2027-03-02")
            .put("originalCurrency", "12x")
            .put("originalAmount", "1800.00")
            .put("exchangeRate", "0.0305");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(badBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_CURRENCY_CODE"));

    var lowercaseBody =
        objectMapper
            .createObjectNode()
            .put("description", "Ramen dinner")
            .put("amount", "54.90")
            .put("occurredOn", "2027-03-02")
            .put("originalCurrency", "jpy")
            .put("originalAmount", "1800.00")
            .put("exchangeRate", "0.0305");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(lowercaseBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.originalCurrency").value("JPY"));
  }

  @Test
  void housemateDashboardShowsPaidOnlyForCategoriesLoggedThisMonth() throws Exception {
    String groupId = createGroupAndReturnId("HOUSEMATES");

    var rentExpense =
        objectMapper
            .createObjectNode()
            .put("description", "August rent")
            .put("amount", "1500.00")
            .put("occurredOn", "2026-08-05")
            .put("category", "RENT");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(rentExpense.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/groups/" + groupId + "/housemate-dashboard")
                    .param("year", "2026")
                    .param("month", "8")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.categories[?(@.category=='RENT')].paid").value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.categories[?(@.category=='ELECTRICITY')].paid")
                .value(false));
  }
}
