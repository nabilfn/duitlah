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

/**
 * Duitlah V2 Phase 6 — Balance Sheet and Cash Flow, built on top of a manual capital-injection
 * journal entry (no cross-module posting needed to prove these reports work).
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AccountingReportsFlowTests {

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

    ownerToken = register("reports-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "ReportsCo")
            .put("legalName", "ReportsCo Sdn Bhd");
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

  private void postCapitalInjection(String amount, String date) throws Exception {
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
                    .put("amount", amount))
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", capitalAccountId)
                    .put("direction", "CREDIT")
                    .put("amount", amount));
    var body =
        objectMapper
            .createObjectNode()
            .put("entryDate", date)
            .put("description", "Owner capital injection")
            .set("lines", lines);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/journal-entries"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));
  }

  @Test
  void theBalanceSheetBalancesAfterACapitalInjection() throws Exception {
    postCapitalInjection("2000.00", "2026-08-01");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/reports/balance-sheet")
                    .param("asOf", "2026-08-31")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalAssets").value(2000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalLiabilitiesAndEquity").value(2000.00));
  }

  @Test
  void cashFlowReflectsMovementThroughCashEquivalentAccounts() throws Exception {
    postCapitalInjection("3000.00", "2026-08-05");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/reports/cash-flow")
                    .param("from", "2026-08-01")
                    .param("to", "2026-08-31")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.openingCash").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalCashIn").value(3000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.netChange").value(3000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.closingCash").value(3000.00));
  }

  @Test
  void trialBalanceExportDownloadsARealCsvFile() throws Exception {
    postCapitalInjection("750.00", "2026-08-01");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/exports/trial-balance")
                    .param("asOf", "2026-08-31")
                    .param("format", "CSV")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.content().contentTypeCompatibleWith("text/csv"));
  }
}
