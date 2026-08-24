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
 * Duitlah V2 Phase 9 — the asset register: create/list/get/update, acquisition posting, and the
 * once-depreciated financials lock.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class FixedAssetFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String staffToken;
  private String spaceId;
  private String bankAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("asset-owner@example.com", "Owner");
    register("asset-staff@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "AssetCo").put("legalName", "AssetCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper
            .createObjectNode()
            .put("email", "asset-staff@example.com")
            .put("role", "STAFF");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    staffToken = login("asset-staff@example.com");

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

  private String createAsset(String businessAccountId) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Delivery Van")
            .put("category", "Vehicles")
            .put("acquisitionDate", "2026-01-01")
            .put("cost", "24000.00")
            .put("salvageValue", "2400.00")
            .put("usefulLifeMonths", 60)
            .put("depreciationMethod", "STRAIGHT_LINE");
    if (businessAccountId != null) {
      body.put("businessAccountId", businessAccountId);
    }
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

  private String login(String email) throws Exception {
    var body =
        objectMapper.createObjectNode().put("email", email).put("password", "correct-horse-1");
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
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
  void creatingAnAssetWithAMappedAccountPostsAcquisitionJournal() throws Exception {
    createAsset(bankAccountId);

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-01-01")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1500')].debit")
                .value(24000.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1010')].credit")
                .value(24000.00));
  }

  @Test
  void creatingAnAssetOnCreditCreditsAccountsPayable() throws Exception {
    createAsset(null);

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-01-01")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='2000')].credit")
                .value(24000.00));
  }

  @Test
  void getReturnsZeroAccumulatedDepreciationAndFullNetBookValueBeforeAnyDepreciation()
      throws Exception {
    String assetId = createAsset(bankAccountId);

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/assets/" + assetId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.accumulatedDepreciation").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.netBookValue").value(24000.00));
  }

  @Test
  void nameAndCategoryStayEditableAfterDepreciationButFinancialsLock() throws Exception {
    String assetId = createAsset(bankAccountId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/assets/" + assetId + "/depreciation/run"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("period", "2026-01-15").toString()));

    var renameBody =
        objectMapper
            .createObjectNode()
            .put("name", "Delivery Van (renamed)")
            .put("category", "Vehicles")
            .put("acquisitionDate", "2026-01-01")
            .put("cost", "24000.00")
            .put("salvageValue", "2400.00")
            .put("usefulLifeMonths", 60)
            .put("depreciationMethod", "STRAIGHT_LINE");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.put("/api/v1/spaces/" + spaceId + "/assets/" + assetId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(renameBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Delivery Van (renamed)"));

    var changeCostBody =
        objectMapper
            .createObjectNode()
            .put("name", "Delivery Van (renamed)")
            .put("category", "Vehicles")
            .put("acquisitionDate", "2026-01-01")
            .put("cost", "30000.00")
            .put("salvageValue", "2400.00")
            .put("usefulLifeMonths", 60)
            .put("depreciationMethod", "STRAIGHT_LINE");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.put("/api/v1/spaces/" + spaceId + "/assets/" + assetId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(changeCostBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ASSET_FINANCIALS_LOCKED"));
  }

  @Test
  void aStaffMemberWithoutManageBooksCannotCreateAnAsset() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Blocked")
            .put("acquisitionDate", "2026-01-01")
            .put("cost", "1000.00")
            .put("usefulLifeMonths", 12)
            .put("depreciationMethod", "STRAIGHT_LINE");
    mockMvc
        .perform(
            as(staffToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/assets"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }
}
