package com.duitlah.api.bagilah;

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
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BagilahFlowTests {

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String ownerToken;
  private String ownerUserId;
  private String otherToken;
  private String otherUserId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var owner = registerAndReturn("nabil@example.com", "Nabil");
    ownerToken = owner.get("accessToken").asText();
    ownerUserId = owner.get("user").get("id").asText();

    var other = registerAndReturn("ameer@example.com", "Ameer");
    otherToken = other.get("accessToken").asText();
    otherUserId = other.get("user").get("id").asText();
  }

  private JsonNode registerAndReturn(String email, String name) throws Exception {
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(email, "correct-horse-1", name))))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(org.springframework.test.web.servlet.MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private String createBillAndReturnId() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("merchant", "Mamak Corner")
            .put("receiptDate", "2026-08-15");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DRAFT"))
            .andReturn();
    return json(result).get("id").asText();
  }

  private String addItem(String billId, String name, String quantity, String unitPrice)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("quantity", quantity)
            .put("unitPrice", unitPrice);
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/items"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return json(result).get("id").asText();
  }

  private String addParticipant(String billId, String userId) throws Exception {
    var body = objectMapper.createObjectNode().put("userId", userId);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/participants"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return json(result).get("id").asText();
  }

  private String ownerParticipantId(String billId) throws Exception {
    var result =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/participants")))
            .andReturn();
    for (JsonNode p : json(result)) {
      if (ownerUserId.equals(p.get("userId").asText(null))) {
        return p.get("id").asText();
      }
    }
    throw new IllegalStateException("owner participant not found");
  }

  private void claimWholeItem(String billId, String itemId, String participantId) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("participantId", participantId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + itemId + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  private void recordPayment(String billId, String participantId, String amount) throws Exception {
    var body = objectMapper.createObjectNode().put("amountPaid", amount);
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.put(
                        "/api/v1/bills/" + billId + "/payments/" + participantId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());
  }

  @Test
  void creatingABillMakesTheCreatorAParticipant() throws Exception {
    String billId = createBillAndReturnId();
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/participants")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].userId").value(ownerUserId));
  }

  @Test
  void endToEndSplitReconcilesToTheCentAndAllocatesRoundingByLargestRemainder() throws Exception {
    String billId = createBillAndReturnId();
    String nasiGoreng = addItem(billId, "Nasi Goreng", "1", "16.00");
    String chickenChop = addItem(billId, "Chicken Chop", "1", "24.00");
    String fries = addItem(billId, "Fries", "1", "8.00");

    String nabilId = ownerParticipantId(billId);
    String ameerId = addParticipant(billId, otherUserId);

    claimWholeItem(billId, nasiGoreng, nabilId);
    claimWholeItem(billId, chickenChop, ameerId);

    var equalSplitBody = objectMapper.createObjectNode();
    equalSplitBody.putArray("participantIds").add(nabilId).add(ameerId);
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + fries + "/claims/equal-split"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(equalSplitBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    var updateBody =
        objectMapper
            .createObjectNode()
            .put("merchant", "Mamak Corner")
            .put("receiptDate", "2026-08-15")
            .put("tax", "2.88")
            .put("taxStrategy", "PROPORTIONAL")
            .put("serviceCharge", "4.80")
            .put("serviceStrategy", "PROPORTIONAL")
            .put("discount", "0.00")
            .put("declaredTotal", "55.69");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.patch("/api/v1/bills/" + billId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    // Subtotal 48.00 (Nabil 20.00, Ameer 28.00); computed total 55.68 vs declared 55.69 ->
    // one cent of rounding goes to whichever share lost more to rounding on the way there.
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/breakdown")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.valid").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$.computedTotal").value(55.68))
        .andExpect(MockMvcResultMatchers.jsonPath("$.roundingAdjustment").value(0.01))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + nabilId + "')].finalAmount")
                .value(23.20))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + ameerId + "')].finalAmount")
                .value(32.49));

    recordPayment(billId, nabilId, "55.69");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("FINALIZED"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.total").value(55.69));

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/balances")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.participantId=='" + nabilId + "')].net")
                .value(32.49))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.participantId=='" + ameerId + "')].net")
                .value(-32.49));
  }

  @Test
  void unclaimedItemBlocksFinalization() throws Exception {
    String billId = createBillAndReturnId();
    addItem(billId, "Teh Tarik", "1", "3.50");
    String nabilId = ownerParticipantId(billId);
    recordPayment(billId, nabilId, "3.50");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/breakdown")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.valid").value(false))
        .andExpect(MockMvcResultMatchers.jsonPath("$.issues[0].type").value("UNCLAIMED"));

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BILL_NOT_READY"));
  }

  @Test
  void overallocatedQuantityIsFlaggedAndBlocksFinalization() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Roti Canai", "1", "2.00");
    String nabilId = ownerParticipantId(billId);
    String ameerId = addParticipant(billId, otherUserId);

    claimWholeItem(billId, item, nabilId);
    var overclaim =
        objectMapper
            .createObjectNode()
            .put("participantId", ameerId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(overclaim.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/breakdown")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.valid").value(false))
        .andExpect(MockMvcResultMatchers.jsonPath("$.issues[0].type").value("OVERALLOCATED"));
  }

  @Test
  void mixedClaimTypesOnTheSameItemAreRejected() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Pizza", "1", "60.00");
    String nabilId = ownerParticipantId(billId);
    String ameerId = addParticipant(billId, otherUserId);

    claimWholeItem(billId, item, nabilId);
    var percentageClaim =
        objectMapper
            .createObjectNode()
            .put("participantId", ameerId)
            .put("claimType", "PERCENTAGE")
            .put("value", "50.00");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(percentageClaim.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("MIXED_CLAIM_TYPES"));
  }

  @Test
  void reClaimingTheSameItemUpdatesTheExistingClaimInsteadOfDuplicating() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Fried Rice", "2", "8.00");
    String nabilId = ownerParticipantId(billId);

    var firstClaim =
        objectMapper
            .createObjectNode()
            .put("participantId", nabilId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(firstClaim.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    var revisedClaim =
        objectMapper
            .createObjectNode()
            .put("participantId", nabilId)
            .put("claimType", "QUANTITY")
            .put("value", "2");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(revisedClaim.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/bills/" + billId + "/items/" + item + "/claims")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].value").value(2));
  }

  @Test
  void guestParticipantCanBeAddedAndClaim() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Nasi Lemak", "1", "6.00");

    var guestBody = objectMapper.createObjectNode().put("guestName", "Syazmir (guest)");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/participants"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(guestBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.guest").value(true))
            .andReturn();
    String guestId = json(result).get("id").asText();

    claimWholeItem(billId, item, guestId);

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/breakdown")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.valid").value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + guestId + "')].displayName")
                .value("Syazmir (guest)"));
  }

  @Test
  void zeroPriceItemContributesNothingButStillCountsAsClaimed() throws Exception {
    String billId = createBillAndReturnId();
    String freeItem = addItem(billId, "Complimentary Water", "1", "0.00");
    String nabilId = ownerParticipantId(billId);
    claimWholeItem(billId, freeItem, nabilId);

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/breakdown")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.valid").value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + nabilId + "')].finalAmount")
                .value(0.00));
  }

  @Test
  void multiplePayersAreSupportedAndMustSumToTheTotal() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Steamboat", "1", "100.00");
    String nabilId = ownerParticipantId(billId);
    String ameerId = addParticipant(billId, otherUserId);

    var equalSplitBody = objectMapper.createObjectNode();
    equalSplitBody.putArray("participantIds").add(nabilId).add(ameerId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/bills/" + billId + "/items/" + item + "/claims/equal-split"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(equalSplitBody.toString()));

    recordPayment(billId, nabilId, "60.00");
    recordPayment(billId, ameerId, "40.00");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/balances")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.participantId=='" + nabilId + "')].net")
                .value(10.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.participantId=='" + ameerId + "')].net")
                .value(-10.00));
  }

  @Test
  void paymentsNotMatchingTotalBlockFinalization() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Laksa", "1", "12.00");
    String nabilId = ownerParticipantId(billId);
    claimWholeItem(billId, item, nabilId);
    recordPayment(billId, nabilId, "10.00");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("PAYMENTS_DONT_MATCH_TOTAL"));
  }

  @Test
  void nonParticipantCannotSeeTheBill() throws Exception {
    String billId = createBillAndReturnId();
    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  @Test
  void participantCanViewButNotEditTheBill() throws Exception {
    String billId = createBillAndReturnId();
    addParticipant(billId, otherUserId);

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId)))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(otherToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/items"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper
                        .createObjectNode()
                        .put("name", "Snacks")
                        .put("quantity", "1")
                        .put("unitPrice", "5")
                        .toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("NOT_BILL_OWNER"));
  }

  @Test
  void ownerCannotBeRemovedAsAParticipant() throws Exception {
    String billId = createBillAndReturnId();
    String nabilId = ownerParticipantId(billId);
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/bills/" + billId + "/participants/" + nabilId)))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("CANNOT_REMOVE_OWNER"));
  }

  @Test
  void cancelledBillCannotBeEditedOrFinalized() throws Exception {
    String billId = createBillAndReturnId();
    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.delete("/api/v1/bills/" + billId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/items"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper
                        .createObjectNode()
                        .put("name", "Snacks")
                        .put("quantity", "1")
                        .put("unitPrice", "5")
                        .toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BILL_NOT_DRAFT"));
  }

  @Test
  void finalizedBillCannotBeCancelledOrReopened() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Kopi O", "1", "2.50");
    String nabilId = ownerParticipantId(billId);
    claimWholeItem(billId, item, nabilId);
    recordPayment(billId, nabilId, "2.50");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.delete("/api/v1/bills/" + billId)))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BILL_ALREADY_FINALIZED"));
  }

  @Test
  void itemSpecificDiscountCannotExceedTheItemsPrice() throws Exception {
    String billId = createBillAndReturnId();
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Overpriced Voucher Item")
            .put("quantity", "1")
            .put("unitPrice", "10.00")
            .put("itemDiscount", "15.00");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/items"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ITEM_DISCOUNT_EXCEEDS_TOTAL"));
  }

  @Test
  void receiptWideDiscountIsAllocatedProportionallyAndReconcilesExactly() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Family Set", "1", "100.00");
    String nabilId = ownerParticipantId(billId);
    String ameerId = addParticipant(billId, otherUserId);

    var claim1 =
        objectMapper
            .createObjectNode()
            .put("participantId", nabilId)
            .put("claimType", "PERCENTAGE")
            .put("value", "30.00");
    var claim2 =
        objectMapper
            .createObjectNode()
            .put("participantId", ameerId)
            .put("claimType", "PERCENTAGE")
            .put("value", "70.00");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(claim1.toString()));
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(claim2.toString()));

    var updateBody =
        objectMapper
            .createObjectNode()
            .put("merchant", "Mamak Corner")
            .put("receiptDate", "2026-08-15")
            .put("tax", "0.00")
            .put("taxStrategy", "PROPORTIONAL")
            .put("serviceCharge", "0.00")
            .put("serviceStrategy", "PROPORTIONAL")
            .put("discount", "20.00")
            .put("discountLabel", "Birthday voucher");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.patch("/api/v1/bills/" + billId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/breakdown")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.computedTotal").value(80.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + nabilId + "')].finalAmount")
                .value(24.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + ameerId + "')].finalAmount")
                .value(56.00));
  }

  @Test
  void billScopedToAGroupRequiresMembership() throws Exception {
    var groupBody = objectMapper.createObjectNode().put("name", "Trip Squad").put("type", "TRIP");
    var groupResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(groupBody.toString()))
            .andReturn();
    String groupId = json(groupResult).get("id").asText();

    var billBody =
        objectMapper
            .createObjectNode()
            .put("merchant", "Somewhere")
            .put("receiptDate", "2026-08-15")
            .put("groupId", groupId);
    mockMvc
        .perform(
            as(otherToken, MockMvcRequestBuilders.post("/api/v1/bills"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(billBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("NOT_A_GROUP_MEMBER"));

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(billBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }
}
