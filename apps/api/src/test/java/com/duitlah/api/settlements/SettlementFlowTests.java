package com.duitlah.api.settlements;

import static org.assertj.core.api.Assertions.assertThat;

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
 * Covers settlement generation from both sources (Bagilah bill finalize, Group settle-up), payment
 * history / mark-paid, cancel/dispute, and the "who owes me" summary (product spec section 34). See
 * BillService.generateSettlements and GroupService.settleGroup for the generation hooks these tests
 * exercise indirectly through the ordinary finalize/settle actions.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class SettlementFlowTests {

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

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  // ---- Bagilah bill finalize -> settlement generation ----

  private String finalizedBillSettlementId() throws Exception {
    var billBody =
        objectMapper
            .createObjectNode()
            .put("merchant", "Mamak Corner")
            .put("receiptDate", "2026-08-21");
    var billResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(billBody.toString()))
            .andReturn();
    String billId = json(billResult).get("id").asText();

    var itemResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/items"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper
                            .createObjectNode()
                            .put("name", "Nasi Lemak")
                            .put("quantity", "1")
                            .put("unitPrice", "20.00")
                            .toString()))
            .andReturn();
    String itemId = json(itemResult).get("id").asText();

    var participantResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/participants"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(objectMapper.createObjectNode().put("userId", otherUserId).toString()))
            .andReturn();
    String otherParticipantId = json(participantResult).get("id").asText();

    var ownerParticipantsResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/participants")))
            .andReturn();
    String ownerParticipantId = null;
    for (JsonNode p : json(ownerParticipantsResult)) {
      if (ownerUserId.equals(p.get("userId").asText(null))) {
        ownerParticipantId = p.get("id").asText();
      }
    }

    // Nabil claims the whole item; Nabil also pays the whole bill. So Ameer (a mere
    // participant with no claim, subtotal 0) ends up owing nothing here -- give Ameer a
    // share via equal split so there's a real debt to settle.
    var equalSplitBody = objectMapper.createObjectNode();
    equalSplitBody.putArray("participantIds").add(ownerParticipantId).add(otherParticipantId);
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + itemId + "/claims/equal-split"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(equalSplitBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.put(
                    "/api/v1/bills/" + billId + "/payments/" + ownerParticipantId))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("amountPaid", "20.00").toString()));

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")))
        .andExpect(MockMvcResultMatchers.status().isOk());

    var settlementsResult =
        mockMvc
            .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/settlements")))
            .andReturn();
    JsonNode settlementsList = json(settlementsResult);
    assertThat(settlementsList).hasSize(1);
    return settlementsList.get(0).get("id").asText();
  }

  @Test
  void finalizingABillGeneratesASettlementForWhatsOwed() throws Exception {
    String settlementId = finalizedBillSettlementId();

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/settlements/" + settlementId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.fromUserId").value(otherUserId))
        .andExpect(MockMvcResultMatchers.jsonPath("$.toUserId").value(ownerUserId))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amount").value(10.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("UNPAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.handoff.instructions").isNotEmpty());
  }

  @Test
  void partialPaymentUpdatesStatusAndRemaining() throws Exception {
    String settlementId = finalizedBillSettlementId();

    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/settlements/" + settlementId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("amount", "4.00").toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PARTIALLY_PAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountPaid").value(4.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountRemaining").value(6.00));

    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/settlements/" + settlementId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("amount", "6.00").toString()))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountRemaining").value(0.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/settlements/" + settlementId + "/payments")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2));
  }

  @Test
  void paymentCannotExceedTheRemainingSettlementAmount() throws Exception {
    String settlementId = finalizedBillSettlementId();

    mockMvc.perform(
        as(
                otherToken,
                MockMvcRequestBuilders.post("/api/v1/settlements/" + settlementId + "/payments"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("amount", "4.00").toString()));

    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/settlements/" + settlementId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("amount", "6.01").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("PAYMENT_EXCEEDS_REMAINING"));

    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/settlements/" + settlementId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountPaid").value(4.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountRemaining").value(6.00));
  }

  @Test
  void eitherPartyCanRecordAPayment() throws Exception {
    String settlementId = finalizedBillSettlementId();

    // The creditor (owner) can also confirm a payment was received.
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/settlements/" + settlementId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper
                        .createObjectNode()
                        .put("amount", "10.00")
                        .put("note", "cash")
                        .toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PAID"));
  }

  @Test
  void cancellingASettlementBlocksFurtherPayments() throws Exception {
    String settlementId = finalizedBillSettlementId();

    mockMvc
        .perform(
            as(
                otherToken,
                MockMvcRequestBuilders.post("/api/v1/settlements/" + settlementId + "/cancel")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("CANCELLED"));

    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/settlements/" + settlementId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("amount", "10.00").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("SETTLEMENT_CANCELLED"));
  }

  @Test
  void disputingASettlementFlagsItButStillAllowsPayment() throws Exception {
    String settlementId = finalizedBillSettlementId();

    mockMvc
        .perform(
            as(
                otherToken,
                MockMvcRequestBuilders.post("/api/v1/settlements/" + settlementId + "/dispute")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DISPUTED"));

    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/settlements/" + settlementId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("amount", "10.00").toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());
  }

  @Test
  void nonInvolvedUserCannotSeeOrActOnASettlement() throws Exception {
    String settlementId = finalizedBillSettlementId();
    var stranger = registerAndReturn("stranger@example.com", "Syazmir");
    String strangerToken = stranger.get("accessToken").asText();

    mockMvc
        .perform(
            as(strangerToken, MockMvcRequestBuilders.get("/api/v1/settlements/" + settlementId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  // ---- Group settle-up ----

  private String createGroupAndReturnId() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Housemates").put("type", "HOUSEMATES");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return json(result).get("id").asText();
  }

  private void joinGroup(String groupId, String token) throws Exception {
    var inviteResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/invite-token")))
            .andReturn();
    String inviteToken = json(inviteResult).get("token").asText();
    mockMvc.perform(
        as(token, MockMvcRequestBuilders.post("/api/v1/groups/join"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("token", inviteToken).toString()));
  }

  @Test
  void settlingAGroupGeneratesMatchingSettlementsAndZeroesTheBalance() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, otherToken);

    // Owner pays RM100 split equally -> Ameer owes Nabil RM50.
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(
                objectMapper
                    .createObjectNode()
                    .put("description", "Groceries")
                    .put("amount", "100.00")
                    .put("occurredOn", "2026-08-21")
                    .toString()));

    var settleResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/settle")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();
    JsonNode created = json(settleResult);
    assertThat(created).hasSize(1);
    assertThat(created.get(0).get("fromUserId").asText()).isEqualTo(otherUserId);
    assertThat(created.get(0).get("toUserId").asText()).isEqualTo(ownerUserId);
    assertThat(created.get(0).get("amount").asDouble()).isEqualTo(50.00);

    // The group's own balance view now shows everyone settled up (net 0) -- the RM50
    // moved from "ongoing balance" into a fixed settlement instead.
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/groups/" + groupId + "/balances")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + otherUserId + "')].net").value(0.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + ownerUserId + "')].net")
                .value(0.00));

    // Settling again with no new activity produces nothing new.
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/settle")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }

  @Test
  void onlyGroupOwnerCanSettleUp() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, otherToken);

    mockMvc
        .perform(
            as(otherToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/settle")))
        .andExpect(MockMvcResultMatchers.status().isForbidden());
  }

  // ---- Summary ("who owes me") ----

  @Test
  void summaryAggregatesOutstandingAmountsPerCounterparty() throws Exception {
    finalizedBillSettlementId(); // Ameer owes Nabil RM10 via a bill

    String groupId = createGroupAndReturnId();
    joinGroup(groupId, otherToken);
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(
                objectMapper
                    .createObjectNode()
                    .put("description", "Snacks")
                    .put("amount", "40.00")
                    .put("occurredOn", "2026-08-21")
                    .toString()));
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/settle")));

    // Ameer now owes Nabil RM10 (bill) + RM20 (group) = RM30 total, netted into one entry.
    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/settlements/summary")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalOwedToMe").value(30.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalIOwe").value(0.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.owedToMe[0].userId").value(otherUserId))
        .andExpect(MockMvcResultMatchers.jsonPath("$.owedToMe[0].netAmount").value(30.00));

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/settlements/summary")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalIOwe").value(30.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalOwedToMe").value(0.00));
  }
}
