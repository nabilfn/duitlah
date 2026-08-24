package com.duitlah.api.inventory;

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

/** Duitlah V2 Phase 8 — stock movements, purchases, sales, and Weighted Average Cost. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class InventoryMovementFlowTests {

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

    ownerToken = register("inv-owner@example.com", "Owner");
    register("inv-staff@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "StockCo").put("legalName", "StockCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper.createObjectNode().put("email", "inv-staff@example.com").put("role", "STAFF");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    staffToken = login("inv-staff@example.com");

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
            .put("openingBalance", "10000.00");
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

  private String createTrackedProduct(String name, String reorderPoint) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", "GOODS")
            .put("unitPrice", "20.00")
            .put("trackInventory", true);
    if (reorderPoint != null) {
      body.put("reorderPoint", reorderPoint);
    }
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/products"))
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
  void aMappedPurchaseDebitsInventoryAndCreditsTheBankAccount() throws Exception {
    String productId = createTrackedProduct("Rice (10kg)", null);
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "PURCHASE")
            .put("quantity", "50")
            .put("unitCost", "8.00")
            .put("occurredOn", "2026-08-20")
            .put("businessAccountId", bankAccountId);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.value").value(400.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1030')].debit").value(400.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1010')].credit")
                .value(400.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/valuation")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.quantityOnHand").value(50))
        .andExpect(MockMvcResultMatchers.jsonPath("$.weightedAverageCost").value(8.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalValue").value(400.00));
  }

  @Test
  void aPurchaseOnCreditCreditsAccountsPayable() throws Exception {
    String productId = createTrackedProduct("Sugar (10kg)", null);
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "PURCHASE")
            .put("quantity", "20")
            .put("unitCost", "5.00")
            .put("occurredOn", "2026-08-20");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='2000')].credit")
                .value(100.00));
  }

  @Test
  void aSecondPurchaseAtADifferentPriceRecomputesTheWeightedAverage() throws Exception {
    String productId = createTrackedProduct("Oil (5L)", null);
    var firstPurchase =
        objectMapper
            .createObjectNode()
            .put("type", "PURCHASE")
            .put("quantity", "10")
            .put("unitCost", "10.00")
            .put("occurredOn", "2026-08-18")
            .put("businessAccountId", bankAccountId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(firstPurchase.toString()));

    var secondPurchase =
        objectMapper
            .createObjectNode()
            .put("type", "PURCHASE")
            .put("quantity", "10")
            .put("unitCost", "20.00")
            .put("occurredOn", "2026-08-19")
            .put("businessAccountId", bankAccountId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(secondPurchase.toString()));

    // (10*10 + 10*20) / 20 = 15.00
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/valuation")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.quantityOnHand").value(20))
        .andExpect(MockMvcResultMatchers.jsonPath("$.weightedAverageCost").value(15.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalValue").value(300.00));
  }

  @Test
  void aSaleLocksInTheCurrentWeightedAverageCostAndPostsCogs() throws Exception {
    String productId = createTrackedProduct("Flour (25kg)", null);
    var purchase =
        objectMapper
            .createObjectNode()
            .put("type", "PURCHASE")
            .put("quantity", "10")
            .put("unitCost", "40.00")
            .put("occurredOn", "2026-08-18")
            .put("businessAccountId", bankAccountId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(purchase.toString()));

    var sale =
        objectMapper
            .createObjectNode()
            .put("type", "SALE")
            .put("quantity", "-4")
            .put("occurredOn", "2026-08-20");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(sale.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.unitCost").value(40.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='5000')].debit").value(160.00))
        // Inventory nets purchase debit (400) against COGS credit (160): 240 debit remaining,
        // matching the 6 units left on hand at the locked-in 40.00 WAC.
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1030')].debit")
                .value(240.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/valuation")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.quantityOnHand").value(6));
  }

  @Test
  void zeroQuantityIsRejected() throws Exception {
    String productId = createTrackedProduct("Salt", null);
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "ADJUSTMENT")
            .put("quantity", "0")
            .put("occurredOn", "2026-08-20");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ZERO_QUANTITY"));
  }

  @Test
  void anInboundMovementWithoutAUnitCostIsRejected() throws Exception {
    String productId = createTrackedProduct("Pepper", null);
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "OPENING_BALANCE")
            .put("quantity", "5")
            .put("occurredOn", "2026-08-20");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("UNIT_COST_REQUIRED"));
  }

  @Test
  void aStaffMemberWithoutManageProductsCannotRecordAMovement() throws Exception {
    String productId = createTrackedProduct("Butter", null);
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "OPENING_BALANCE")
            .put("quantity", "5")
            .put("unitCost", "3.00")
            .put("occurredOn", "2026-08-20");
    mockMvc
        .perform(
            as(
                    staffToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }
}
