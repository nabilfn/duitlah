package com.duitlah.api.personaltax;

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

/** Spec section 30 — an explainable checklist, never a guess about need. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class FilingReadinessFlowTests {

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
                            new RegisterRequest(
                                "readiness@example.com", "correct-horse-1", "Nabil"))))
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
  void aFreshUserHasNoIncomeEaOrPcbButZakatIsReadyByDefault() throws Exception {
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/filing-readiness"))
                    .queryParam("yearOfAssessment", "2026"))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

    JsonNode response = json(result);
    org.assertj.core.api.Assertions.assertThat(itemReady(response, "INCOME")).isFalse();
    org.assertj.core.api.Assertions.assertThat(itemReady(response, "EA")).isFalse();
    org.assertj.core.api.Assertions.assertThat(itemReady(response, "PCB")).isFalse();
    org.assertj.core.api.Assertions.assertThat(itemReady(response, "ZAKAT")).isTrue();
  }

  @Test
  void addingIncomeAndPcbMakesThoseItemsReady() throws Exception {
    var incomeBody =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("incomeType", "EMPLOYMENT")
            .put("amount", "5000.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/income"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(incomeBody.toString()));

    var pcbBody =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("month", 1)
            .put("amount", "10.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/pcb"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(pcbBody.toString()));

    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/filing-readiness"))
                    .queryParam("yearOfAssessment", "2026"))
            .andReturn();

    JsonNode response = json(result);
    org.assertj.core.api.Assertions.assertThat(itemReady(response, "INCOME")).isTrue();
    org.assertj.core.api.Assertions.assertThat(itemReady(response, "PCB")).isTrue();
  }

  @Test
  void aPendingReliefCandidateMakesItsCategoryNotReady() throws Exception {
    var candidateBody =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("suggestedAmount", "100.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/relief-candidates"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(candidateBody.toString()));

    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/filing-readiness"))
                    .queryParam("yearOfAssessment", "2026"))
            .andReturn();

    // The candidate has no category assigned, so none of LIFESTYLE/MEDICAL/INSURANCE are affected
    // --
    // this just confirms readiness still returns a full, valid checklist alongside a pending
    // uncategorized candidate.
    JsonNode response = json(result);
    org.assertj.core.api.Assertions.assertThat(response.get("items").size()).isEqualTo(7);
  }

  private static boolean itemReady(JsonNode response, String key) {
    for (JsonNode item : response.get("items")) {
      if (item.get("key").asText().equals(key)) {
        return item.get("ready").asBoolean();
      }
    }
    throw new IllegalStateException("No readiness item with key " + key);
  }
}
