package com.duitlah.api.recurring;

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

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class RecurringTransactionFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private RecurringTransactionService recurringTransactionService;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;

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
                                "recurring@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
            .readTree(result.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private JsonNode createAccount(String name) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private JsonNode createRule(
      String accountId,
      String type,
      String amount,
      String frequency,
      String startDate,
      boolean isSubscription)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", type)
            .put("amount", amount)
            .put("frequency", frequency)
            .put("startDate", startDate)
            .put("isSubscription", isSubscription);
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/recurring-transactions"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void creatingARuleSetsNextOccurrenceToStartDate() throws Exception {
    JsonNode account = createAccount("Wallet");
    JsonNode rule =
        createRule(account.get("id").asText(), "EXPENSE", "15.90", "MONTHLY", "2026-08-01", true);

    assertThat(rule.get("nextOccurrenceDate").asText()).isEqualTo("2026-08-01");
    assertThat(rule.get("active").asBoolean()).isTrue();
    assertThat(rule.get("isSubscription").asBoolean()).isTrue();
  }

  @Test
  void materializingADueRuleCreatesARealTransactionAndAdvancesNextOccurrence() throws Exception {
    JsonNode account = createAccount("Wallet");
    JsonNode rule =
        createRule(account.get("id").asText(), "EXPENSE", "15.90", "MONTHLY", "2026-08-01", false);

    int created = recurringTransactionService.materializeAllDue(LocalDate.of(2026, 8, 1));
    assertThat(created).isEqualTo(1);

    mockMvc
        .perform(
            auth(
                MockMvcRequestBuilders.get(
                    "/api/v1/recurring-transactions/" + rule.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.nextOccurrenceDate").value("2026-09-01"));

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + account.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(-15.90));

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/transactions/recent")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[0].recurringTransactionId")
                .value(rule.get("id").asText()));
  }

  @Test
  void materializingCatchesUpMultipleElapsedOccurrences() throws Exception {
    JsonNode account = createAccount("Wallet");
    createRule(account.get("id").asText(), "INCOME", "50.00", "WEEKLY", "2026-08-01", false);

    // Three weekly occurrences have elapsed by Aug 15 (Aug 1, 8, 15).
    int created = recurringTransactionService.materializeAllDue(LocalDate.of(2026, 8, 15));
    assertThat(created).isEqualTo(3);

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + account.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(150.00));
  }

  @Test
  void ruleBecomesInactiveOncePastItsEndDate() throws Exception {
    JsonNode account = createAccount("Wallet");
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", account.get("id").asText())
            .put("type", "EXPENSE")
            .put("amount", "10.00")
            .put("frequency", "DAILY")
            .put("startDate", "2026-08-01")
            .put("endDate", "2026-08-02")
            .put("isSubscription", false);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/recurring-transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    recurringTransactionService.materializeAllDue(LocalDate.of(2026, 8, 5));

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/recurring-transactions")))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].active").value(false));
  }

  @Test
  void subscriptionsSummaryOnlyIncludesFlaggedActiveRules() throws Exception {
    JsonNode account = createAccount("Wallet");
    createRule(account.get("id").asText(), "EXPENSE", "54.90", "MONTHLY", "2026-08-01", true);
    createRule(account.get("id").asText(), "EXPENSE", "800.00", "MONTHLY", "2026-08-01", false);

    mockMvc
        .perform(
            auth(
                MockMvcRequestBuilders.get("/api/v1/recurring-transactions/subscriptions/summary")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.subscriptions.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$.estimatedMonthlyTotal").value(54.90));
  }

  @Test
  void anotherUsersRecurringTransactionIsNotFoundNotForbidden() throws Exception {
    JsonNode account = createAccount("Wallet");
    JsonNode rule =
        createRule(account.get("id").asText(), "EXPENSE", "10.00", "MONTHLY", "2026-08-01", false);

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "other-recurring@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken =
        objectMapper
            .readTree(registerResult.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    mockMvc
        .perform(
            MockMvcRequestBuilders.get("/api/v1/recurring-transactions/" + rule.get("id").asText())
                .header("Authorization", "Bearer " + otherToken))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
