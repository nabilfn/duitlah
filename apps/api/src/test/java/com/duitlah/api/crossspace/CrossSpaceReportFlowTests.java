package com.duitlah.api.crossspace;

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
 * Duitlah V2 Phase 11 — section 61's "Combined Personal View": purely informational, never merges
 * Personal and Business bookkeeping.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class CrossSpaceReportFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;

  @BeforeEach
  void setUp() {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();
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

  @Test
  void aUserWithNoBusinessSpacesSeesOnlyPersonalNetWorth() throws Exception {
    ownerToken = register("report-solo@example.com", "Solo");

    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/crossspace/net-worth")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.personalNetWorth").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.businessOwnership").isEmpty())
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalBusinessOwnershipValue").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.estimatedTotalNetWorth").value(0));
  }

  @Test
  void combinesPersonalNetWorthWithBusinessEquity() throws Exception {
    ownerToken = register("report-owner@example.com", "Owner");

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Personal Savings")
            .put("type", "SAVINGS")
            .put("openingBalance", "12000.00");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(accountBody.toString()));

    var spaceBody =
        objectMapper
            .createObjectNode()
            .put("name", "ReportCo")
            .put("legalName", "ReportCo Sdn Bhd");
    var spaceResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(spaceBody.toString()))
            .andReturn();
    String spaceId =
        objectMapper.readTree(spaceResult.getResponse().getContentAsString()).get("id").asText();

    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));

    // Manually capitalize the business with a real journal entry so its equity is non-zero.
    var coa =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
            .andReturn();
    String bankId = null;
    String capitalId = null;
    String expenseId = null;
    for (var node : objectMapper.readTree(coa.getResponse().getContentAsString())) {
      if (node.get("code").asText().equals("1010")) {
        bankId = node.get("id").asText();
      }
      if (node.get("code").asText().equals("3000")) {
        capitalId = node.get("id").asText();
      }
      if (node.get("code").asText().equals("6900")) {
        expenseId = node.get("id").asText();
      }
    }
    var journalBody =
        objectMapper
            .createObjectNode()
            .put("entryDate", "2026-08-20")
            .put("description", "Initial capital")
            .set(
                "lines",
                objectMapper
                    .createArrayNode()
                    .add(
                        objectMapper
                            .createObjectNode()
                            .put("accountId", bankId)
                            .put("direction", "DEBIT")
                            .put("amount", "20000.00"))
                    .add(
                        objectMapper
                            .createObjectNode()
                            .put("accountId", capitalId)
                            .put("direction", "CREDIT")
                            .put("amount", "20000.00")));
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/journal-entries"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(journalBody.toString()));

    // A real expense, so currentEarnings becomes non-zero -- regression test for a real bug
    // caught during live verification: totalEquity() alone excludes currentEarnings (Phase 6's
    // own substitute for Retained Earnings), so the combined view was understating business
    // ownership value by exactly this amount before the fix.
    var expenseJournalBody =
        objectMapper
            .createObjectNode()
            .put("entryDate", "2026-08-21")
            .put("description", "Office rent")
            .set(
                "lines",
                objectMapper
                    .createArrayNode()
                    .add(
                        objectMapper
                            .createObjectNode()
                            .put("accountId", expenseId)
                            .put("direction", "DEBIT")
                            .put("amount", "3000.00"))
                    .add(
                        objectMapper
                            .createObjectNode()
                            .put("accountId", bankId)
                            .put("direction", "CREDIT")
                            .put("amount", "3000.00")));
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/journal-entries"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(expenseJournalBody.toString()));

    // True equity = totalEquity (20000) + currentEarnings (-3000) = 17000.
    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/crossspace/net-worth")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.personalNetWorth").value(12000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.businessOwnership.length()").value(1))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.businessOwnership[0].equityValue").value(17000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalBusinessOwnershipValue").value(17000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.estimatedTotalNetWorth").value(29000.00));
  }
}
