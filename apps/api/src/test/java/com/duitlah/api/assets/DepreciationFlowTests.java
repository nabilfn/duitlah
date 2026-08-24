package com.duitlah.api.assets;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
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

/**
 * Duitlah V2 Phase 9 — depreciation: both methods' math, idempotency per period, the
 * fully-depreciated floor, and the scheduler's direct-callable batch method.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class DepreciationFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private DepreciationService depreciationService;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("depr-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "DeprCo").put("legalName", "DeprCo Sdn Bhd");
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

  private String createAsset(String cost, String salvage, int usefulLifeMonths, String method)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Test Machine")
            .put("acquisitionDate", "2026-01-01")
            .put("cost", cost)
            .put("salvageValue", salvage)
            .put("usefulLifeMonths", usefulLifeMonths)
            .put("depreciationMethod", method);
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/assets"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private void runDepreciation(String assetId, String period) throws Exception {
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/depreciation/run"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("period", period).toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
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
  void straightLineDepreciatesTheSameAmountEveryPeriodAndPostsTheJournal() throws Exception {
    String assetId = createAsset("24000.00", "2400.00", 60, "STRAIGHT_LINE");

    runDepreciation(assetId, "2026-01-15");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/assets/" + assetId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.accumulatedDepreciation").value(360.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.netBookValue").value(23640.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-01-15")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='6100')].debit").value(360.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1510')].credit")
                .value(360.00));
  }

  @Test
  void doubleDecliningBalanceShrinksEachPeriod() throws Exception {
    String assetId = createAsset("1000.00", "100.00", 10, "DOUBLE_DECLINING_BALANCE");

    runDepreciation(assetId, "2026-01-15");
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/assets/" + assetId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.accumulatedDepreciation").value(200.00));

    runDepreciation(assetId, "2026-02-15");
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/assets/" + assetId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.accumulatedDepreciation").value(360.00));
  }

  @Test
  void runningTheSamePeriodTwiceIsRejected() throws Exception {
    String assetId = createAsset("24000.00", "2400.00", 60, "STRAIGHT_LINE");
    runDepreciation(assetId, "2026-01-15");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/depreciation/run"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("period", "2026-01-28").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("PERIOD_ALREADY_DEPRECIATED"));
  }

  @Test
  void aFullyDepreciatedAssetRejectsFurtherRuns() throws Exception {
    String assetId = createAsset("1200.00", "0.00", 2, "STRAIGHT_LINE");
    runDepreciation(assetId, "2026-01-15");
    runDepreciation(assetId, "2026-02-15");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/assets/" + assetId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.accumulatedDepreciation").value(1200.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.netBookValue").value(0));

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/depreciation/run"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("period", "2026-03-15").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ASSET_FULLY_DEPRECIATED"));
  }

  @Test
  void theSchedulerBatchMethodPostsForEveryDueActiveAsset() throws Exception {
    createAsset("1200.00", "0.00", 12, "STRAIGHT_LINE");
    createAsset("2400.00", "0.00", 24, "STRAIGHT_LINE");

    int posted = depreciationService.runAllDueForPeriod(LocalDate.of(2026, 3, 1));
    assertThat(posted).isEqualTo(2);

    int postedAgain = depreciationService.runAllDueForPeriod(LocalDate.of(2026, 3, 15));
    assertThat(postedAgain).isEqualTo(0);
  }
}
