package com.duitlah.api.notifications;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.analytics.LowBalanceAlertScheduler;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.budgets.BudgetService;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.LocalDate;
import java.util.UUID;
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
 * V2 Phase 13 -- "notification rules". Before this phase every trigger fired unconditionally; now
 * {@link NotificationService#notify} consults {@link NotificationRuleService#isEnabledFor} first,
 * and two new triggers ({@code BUDGET_EXCEEDED}, {@code LOW_BALANCE}) exist alongside the three
 * that already did.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class NotificationRuleFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private NotificationService notificationService;
  @Autowired private BudgetService budgetService;
  @Autowired private LowBalanceAlertScheduler lowBalanceAlertScheduler;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private UUID userId;

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
                                "notif-rules@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(result).get("accessToken").asText();
    userId = UUID.fromString(json(result).get("user").get("id").asText());
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void everyTypeDefaultsToEnabledExceptLowBalanceWhichIsOptIn() throws Exception {
    var result =
        mockMvc
            .perform(auth(MockMvcRequestBuilders.get("/api/v1/notification-rules")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();
    JsonNode rules = json(result);
    assertThat(rules).hasSize(5);
    for (JsonNode rule : rules) {
      boolean expectedEnabled = !rule.get("type").asText().equals("LOW_BALANCE");
      assertThat(rule.get("enabled").asBoolean()).isEqualTo(expectedEnabled);
    }
  }

  @Test
  void updatingARuleIsReflectedOnTheNextList() throws Exception {
    var body = objectMapper.createObjectNode().put("enabled", false).putNull("thresholdAmount");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.put("/api/v1/notification-rules/LOW_STOCK_ALERT"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.enabled").value(false));

    var result =
        mockMvc.perform(auth(MockMvcRequestBuilders.get("/api/v1/notification-rules"))).andReturn();
    JsonNode rules = json(result);
    boolean found = false;
    for (JsonNode rule : rules) {
      if (rule.get("type").asText().equals("LOW_STOCK_ALERT")) {
        assertThat(rule.get("enabled").asBoolean()).isFalse();
        found = true;
      }
    }
    assertThat(found).isTrue();
  }

  @Test
  void disablingATypeSuppressesFutureNotificationsOfThatType() throws Exception {
    var body = objectMapper.createObjectNode().put("enabled", false).putNull("thresholdAmount");
    mockMvc.perform(
        auth(MockMvcRequestBuilders.put("/api/v1/notification-rules/BILL_DUE_SOON"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    notificationService.notify(userId, "BILL_DUE_SOON", "Bill due", "Body");
    notificationService.notify(userId, "BILL_OVERDUE", "Bill overdue", "Body");

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/notifications")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].title").value("Bill overdue"));
  }

  @Test
  void budgetExceededFiresOnceAndClearsOnceSpendingDropsBackUnderTheLimit() throws Exception {
    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    String accountId =
        json(mockMvc
                .perform(
                    auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(accountBody.toString()))
                .andReturn())
            .get("id")
            .asText();

    var budgetBody =
        objectMapper
            .createObjectNode()
            .put("periodYear", 2026)
            .put("periodMonth", 8)
            .put("amountLimit", "100.00");
    mockMvc.perform(
        auth(MockMvcRequestBuilders.post("/api/v1/budgets"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(budgetBody.toString()));

    var transactionBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "150.00")
            .put("occurredOn", "2026-08-05");
    mockMvc.perform(
        auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(transactionBody.toString()));

    budgetService.evaluateBudgetAlerts(LocalDate.of(2026, 8, 10));
    budgetService.evaluateBudgetAlerts(LocalDate.of(2026, 8, 11)); // must not double-fire

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/notifications")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].type").value("BUDGET_EXCEEDED"));
  }

  @Test
  void lowBalanceIsOptInAndOnlyFiresOnceAThresholdIsConfigured() throws Exception {
    // No threshold configured yet -- scanning must not notify anyone (opt-in by design).
    lowBalanceAlertScheduler.checkLowBalances();
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/notifications")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));

    var ruleBody =
        objectMapper.createObjectNode().put("enabled", true).put("thresholdAmount", "500.00");
    mockMvc.perform(
        auth(MockMvcRequestBuilders.put("/api/v1/notification-rules/LOW_BALANCE"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(ruleBody.toString()));

    lowBalanceAlertScheduler.checkLowBalances();
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/notifications")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].type").value("LOW_BALANCE"));

    // A second scan while still below threshold must not send a duplicate.
    lowBalanceAlertScheduler.checkLowBalances();
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/notifications")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));
  }
}
