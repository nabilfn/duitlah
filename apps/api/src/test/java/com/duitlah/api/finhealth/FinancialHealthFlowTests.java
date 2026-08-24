package com.duitlah.api.finhealth;

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
 * The score is deterministic (spec section 20: "never a black box") — these tests check the shape
 * of the response and that components missing from a fresh account (no bills, no budgets, no credit
 * cards) are simply excluded rather than penalizing a user for not using those features.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class FinancialHealthFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;

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
                            new RegisterRequest("health@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void returnsAScoreWithComponentsWeightsAndExplanationsForAFreshAccount() throws Exception {
    var result =
        mockMvc
            .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/financial-health")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.jsonPath("$.score").exists())
            .andExpect(MockMvcResultMatchers.jsonPath("$.components").isArray())
            .andReturn();

    JsonNode response = json(result);
    // A fresh account has no bills, budgets, or credit cards -- those components are excluded,
    // not scored as if they failed.
    for (JsonNode component : response.get("components")) {
      assertKeyNotPresent(component, "BILL_PAYMENT_STATUS");
      assertKeyNotPresent(component, "BUDGET_ADHERENCE");
      assertKeyNotPresent(component, "CREDIT_UTILIZATION");
      org.assertj.core.api.Assertions.assertThat(component.get("weight").decimalValue().signum())
          .isPositive();
      org.assertj.core.api.Assertions.assertThat(component.has("explanation")).isTrue();
    }
  }

  private static void assertKeyNotPresent(JsonNode component, String excludedKey) {
    org.assertj.core.api.Assertions.assertThat(component.get("key").asText())
        .isNotEqualTo(excludedKey);
  }

  @Test
  void scoreNeverExceedsOneHundredOrGoesBelowZero() throws Exception {
    var result =
        mockMvc
            .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/financial-health")))
            .andReturn();
    double score = json(result).get("score").asDouble();
    org.assertj.core.api.Assertions.assertThat(score).isBetween(0.0, 100.0);
  }
}
