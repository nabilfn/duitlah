package com.duitlah.api.assets;

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
 * Duitlah V2 Phase 9 — disposal: the balanced gain/loss journal entry, the required-proceeds
 * account rule, and the post-disposal guards.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AssetDisposalFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String bankAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("dispose-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "DisposeCo")
            .put("legalName", "DisposeCo Sdn Bhd");
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

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Main Bank")
            .put("type", "BANK")
            .put("openingBalance", "0.00");
    var accountResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/business-accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    bankAccountId =
        objectMapper.readTree(accountResult.getResponse().getContentAsString()).get("id").asText();

    String bankLedgerAccountId = ledgerAccountIdByCode("1010");
    var mapBody = objectMapper.createObjectNode().put("chartOfAccountsId", bankLedgerAccountId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/business-accounts/"
                        + bankAccountId
                        + "/chart-of-accounts-mapping"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(mapBody.toString()));
  }

  private String ledgerAccountIdByCode(String code) throws Exception {
    var listResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
            .andReturn();
    for (var node : objectMapper.readTree(listResult.getResponse().getContentAsString())) {
      if (node.get("code").asText().equals(code)) {
        return node.get("id").asText();
      }
    }
    throw new IllegalStateException("Ledger account not found for code " + code);
  }

  private String createAsset() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Old Printer")
            .put("acquisitionDate", "2026-01-01")
            .put("cost", "5000.00")
            .put("salvageValue", "0.00")
            .put("usefulLifeMonths", 36)
            .put("depreciationMethod", "STRAIGHT_LINE");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/assets"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
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
  void disposingForMoreThanNetBookValuePostsAGain() throws Exception {
    String assetId = createAsset();
    var body =
        objectMapper
            .createObjectNode()
            .put("disposedOn", "2026-06-01")
            .put("proceeds", "6000.00")
            .put("businessAccountId", bankAccountId);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DISPOSED"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-06-01")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='4910')].credit")
                .value(1000.00));
  }

  @Test
  void disposingForLessThanNetBookValuePostsALoss() throws Exception {
    String assetId = createAsset();
    var body =
        objectMapper
            .createObjectNode()
            .put("disposedOn", "2026-06-01")
            .put("proceeds", "3000.00")
            .put("businessAccountId", bankAccountId);

    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-06-01")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='4910')].debit")
                .value(2000.00));
  }

  @Test
  void scrappingWithNoProceedsPostsAFullWriteOffLoss() throws Exception {
    String assetId = createAsset();
    var body =
        objectMapper.createObjectNode().put("disposedOn", "2026-06-01").put("proceeds", "0.00");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-06-01")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='4910')].debit")
                .value(5000.00));
  }

  @Test
  void proceedsWithoutABusinessAccountIsRejected() throws Exception {
    String assetId = createAsset();
    var body =
        objectMapper.createObjectNode().put("disposedOn", "2026-06-01").put("proceeds", "100.00");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("PROCEEDS_ACCOUNT_REQUIRED"));
  }

  @Test
  void disposingAnAlreadyDisposedAssetIsRejected() throws Exception {
    String assetId = createAsset();
    var body =
        objectMapper.createObjectNode().put("disposedOn", "2026-06-01").put("proceeds", "0.00");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ASSET_ALREADY_DISPOSED"));
  }

  @Test
  void depreciatingADisposedAssetIsRejected() throws Exception {
    String assetId = createAsset();
    var disposeBody =
        objectMapper.createObjectNode().put("disposedOn", "2026-06-01").put("proceeds", "0.00");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/dispose"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(disposeBody.toString()));

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/depreciation/run"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("period", "2026-07-01").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ASSET_ALREADY_DISPOSED"));
  }
}
