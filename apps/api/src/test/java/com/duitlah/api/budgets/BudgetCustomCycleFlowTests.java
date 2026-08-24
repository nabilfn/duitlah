package com.duitlah.api.budgets;

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
 * V2 Phase 3 (spec section 21). {@link BudgetAndGoalFlowTests} already covers the pre-existing
 * CALENDAR_MONTH behavior untouched — these tests are specifically about the new PAYDAY/CUSTOM
 * cycle path.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BudgetCustomCycleFlowTests {

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

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "cyclebudgets@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();

    var accountBody = objectMapper.createObjectNode().put("name", "Wallet").put("type", "CASH");
    var accountResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId = json(accountResult).get("id").asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void creatingAPaydayCycleBudgetSpendsOnlyWithinItsOwnExplicitDateRange() throws Exception {
    var budgetBody =
        objectMapper
            .createObjectNode()
            .put("amountLimit", "1000.00")
            .put("cycleType", "PAYDAY")
            .put("periodStartDate", "2026-08-25")
            .put("periodEndDate", "2026-09-24");
    var createResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/budgets"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(budgetBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.cycleType").value("PAYDAY"))
            .andReturn();

    // A transaction just before the cycle starts must not count toward it.
    var beforeCycle =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "200.00")
            .put("occurredOn", "2026-08-24");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(beforeCycle.toString()));

    // A transaction inside the cycle must count.
    var insideCycle =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "150.00")
            .put("occurredOn", "2026-09-01");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(insideCycle.toString()));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/budgets"))
                .queryParam("year", "2026")
                .queryParam("month", "8"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].spent").value(150.00));
  }

  @Test
  void customCycleWithoutExplicitDatesIsRejected() throws Exception {
    var budgetBody =
        objectMapper.createObjectNode().put("amountLimit", "1000.00").put("cycleType", "CUSTOM");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/budgets"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(budgetBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("CUSTOM_PERIOD_REQUIRED"));
  }

  @Test
  void anEndDateBeforeTheStartDateIsRejected() throws Exception {
    var budgetBody =
        objectMapper
            .createObjectNode()
            .put("amountLimit", "1000.00")
            .put("cycleType", "CUSTOM")
            .put("periodStartDate", "2026-09-24")
            .put("periodEndDate", "2026-08-25");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/budgets"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(budgetBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_PERIOD"));
  }
}
