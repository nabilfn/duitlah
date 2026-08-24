package com.duitlah.api.accounting;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
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

/** Duitlah V2 Phase 6. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AccountingPeriodFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("period-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "PeriodCo")
            .put("legalName", "PeriodCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));
  }

  private String register(String email, String name) throws Exception {
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(email, "correct-horse-1", name))))
            .andReturn();
    return objectMapper
        .readTree(result.getResponse().getContentAsString())
        .get("accessToken")
        .asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private String accountIdByCode(String code) throws Exception {
    var result =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
            .andReturn();
    for (var node : objectMapper.readTree(result.getResponse().getContentAsString())) {
      if (node.get("code").asText().equals(code)) {
        return node.get("id").asText();
      }
    }
    throw new IllegalStateException("No account with code " + code);
  }

  @Test
  void creatingAndClosingAPeriodWorks() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("periodStart", "2026-08-01")
            .put("periodEnd", "2026-08-31");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/accounting/periods"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("OPEN"))
            .andReturn();
    String periodId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/periods/" + periodId + "/close")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("CLOSED"));
  }

  @Test
  void anOverlappingPeriodIsRejected() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("periodStart", "2026-08-01")
            .put("periodEnd", "2026-08-31");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/accounting/periods"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    var overlapping =
        objectMapper
            .createObjectNode()
            .put("periodStart", "2026-08-15")
            .put("periodEnd", "2026-09-15");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/accounting/periods"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(overlapping.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ACCOUNTING_PERIOD_OVERLAPS"));
  }

  @Test
  void postingAManualEntryIntoAClosedPeriodIsRejected() throws Exception {
    var periodBody =
        objectMapper
            .createObjectNode()
            .put("periodStart", "2026-08-01")
            .put("periodEnd", "2026-08-31");
    var periodResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/accounting/periods"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(periodBody.toString()))
            .andReturn();
    String periodId =
        objectMapper.readTree(periodResult.getResponse().getContentAsString()).get("id").asText();
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/periods/" + periodId + "/close")));

    String cashAccountId = accountIdByCode("1000");
    String capitalAccountId = accountIdByCode("3000");
    var lines =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", cashAccountId)
                    .put("direction", "DEBIT")
                    .put("amount", "100.00"))
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", capitalAccountId)
                    .put("direction", "CREDIT")
                    .put("amount", "100.00"));
    var entryBody =
        objectMapper
            .createObjectNode()
            .put("entryDate", "2026-08-15")
            .put("description", "Owner injection")
            .set("lines", lines);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/accounting/journal-entries"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(entryBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ACCOUNTING_PERIOD_CLOSED"));
  }
}
