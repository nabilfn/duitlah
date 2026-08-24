package com.duitlah.api.bagilah;

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
 * Phase 7: invite links, guest access, and collaborative claiming layered on top of Phase 6's
 * calculation engine. See BillService's doc comments on {@code addClaim} and {@code joinViaInvite}
 * for the authorization model these tests exercise.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BagilahCollaborationFlowTests {

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String ownerToken;
  private String otherToken;
  private String otherUserId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var owner = registerAndReturn("nabil@example.com", "Nabil");
    ownerToken = owner.get("accessToken").asText();

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
            .andReturn();
    return json(result).get("id").asText();
  }

  private String generateInviteToken(String billId) throws Exception {
    var result =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/invite-token")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();
    return json(result).get("token").asText();
  }

  private JsonNode joinAs(String inviteToken, String bearerToken, String guestName)
      throws Exception {
    var body = objectMapper.createObjectNode().put("token", inviteToken);
    if (guestName != null) {
      body.put("guestName", guestName);
    }
    var request =
        MockMvcRequestBuilders.post("/api/v1/bagilah/join")
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString());
    if (bearerToken != null) {
      request = request.header("Authorization", "Bearer " + bearerToken);
    }
    var result = mockMvc.perform(request).andReturn();
    return json(result);
  }

  @Test
  void ownerCanGenerateAndRegenerateInviteToken() throws Exception {
    String billId = createBillAndReturnId();
    String token1 = generateInviteToken(billId);
    String token2 = generateInviteToken(billId);
    assertThat(token1).isNotEqualTo(token2);

    // The old token is now invalid.
    var joinBody = objectMapper.createObjectNode().put("token", token1).put("guestName", "Guest");
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/bagilah/join")
                .contentType(MediaType.APPLICATION_JSON)
                .content(joinBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_INVITE"));
  }

  @Test
  void invalidInviteTokenIsRejected() throws Exception {
    var joinBody =
        objectMapper.createObjectNode().put("token", "not-a-real-token").put("guestName", "Guest");
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/bagilah/join")
                .contentType(MediaType.APPLICATION_JSON)
                .content(joinBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_INVITE"));
  }

  @Test
  void authenticatedUserJoiningViaLinkBecomesARealParticipantIdempotently() throws Exception {
    String billId = createBillAndReturnId();
    String inviteToken = generateInviteToken(billId);

    JsonNode firstJoin = joinAs(inviteToken, otherToken, null);
    assertThat(firstJoin.get("guest").asBoolean()).isFalse();
    assertThat(firstJoin.get("guestToken").isNull()).isTrue();
    String participantId = firstJoin.get("participantId").asText();

    // Joining again doesn't create a second participant row.
    JsonNode secondJoin = joinAs(inviteToken, otherToken, null);
    assertThat(secondJoin.get("participantId").asText()).isEqualTo(participantId);

    mockMvc
        .perform(
            as(otherToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/participants")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2));
  }

  @Test
  void guestCanJoinWithoutAnAccountAndClaimItems() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Nasi Lemak", "1", "6.50");
    String inviteToken = generateInviteToken(billId);

    JsonNode joinResponse = joinAs(inviteToken, null, "Syazmir");
    assertThat(joinResponse.get("guest").asBoolean()).isTrue();
    String guestToken = joinResponse.get("guestToken").asText();
    String guestParticipantId = joinResponse.get("participantId").asText();

    mockMvc
        .perform(MockMvcRequestBuilders.get("/api/v1/bagilah/guest/" + guestToken))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(billId));

    var claimBody =
        objectMapper
            .createObjectNode()
            .put("participantId", guestParticipantId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc
        .perform(
            MockMvcRequestBuilders.post(
                    "/api/v1/bagilah/guest/" + guestToken + "/items/" + item + "/claims")
                .contentType(MediaType.APPLICATION_JSON)
                .content(claimBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(MockMvcRequestBuilders.get("/api/v1/bagilah/guest/" + guestToken + "/breakdown"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.valid").value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                    "$.participants[?(@.participantId=='" + guestParticipantId + "')].finalAmount")
                .value(6.50));

    // The owner sees the guest listed as a participant too.
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/participants")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.id=='" + guestParticipantId + "')].guest")
                .value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.id=='" + guestParticipantId + "')].displayName")
                .value("Syazmir"));
  }

  @Test
  void invalidOrExpiredGuestTokenIsRejected() throws Exception {
    mockMvc
        .perform(MockMvcRequestBuilders.get("/api/v1/bagilah/guest/not-a-real-session-token"))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_GUEST_SESSION"));
  }

  @Test
  void joinedNonOwnerParticipantCanCollaborativelyClaimAnItem() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Roti Canai", "1", "2.50");
    String inviteToken = generateInviteToken(billId);
    JsonNode joinResponse = joinAs(inviteToken, otherToken, null);
    String otherParticipantId = joinResponse.get("participantId").asText();

    // Phase 6 would have rejected this (owner-only); Phase 7 allows any participant to claim.
    var claimBody =
        objectMapper
            .createObjectNode()
            .put("participantId", otherParticipantId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(claimBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  @Test
  void nonParticipantStillCannotClaimOnTheBill() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Roti Canai", "1", "2.50");
    var claimBody =
        objectMapper
            .createObjectNode()
            .put("participantId", otherUserId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc
        .perform(
            as(
                    otherToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(claimBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  @Test
  void cannotJoinAFinalizedBill() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Kopi O", "1", "2.50");
    String inviteToken = generateInviteToken(billId);

    var ownerParticipants =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/participants")))
            .andReturn();
    String ownerParticipantId = json(ownerParticipants).get(0).get("id").asText();

    var claimBody =
        objectMapper
            .createObjectNode()
            .put("participantId", ownerParticipantId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/bills/" + billId + "/items/" + item + "/claims"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(claimBody.toString()));

    var paymentBody = objectMapper.createObjectNode().put("amountPaid", "2.50");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.put(
                    "/api/v1/bills/" + billId + "/payments/" + ownerParticipantId))
            .contentType(MediaType.APPLICATION_JSON)
            .content(paymentBody.toString()));
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")));

    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/bagilah/join")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper
                        .createObjectNode()
                        .put("token", inviteToken)
                        .put("guestName", "Latecomer")
                        .toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BILL_NOT_JOINABLE"));
  }

  @Test
  void guestCannotClaimOnAFinalizedBill() throws Exception {
    String billId = createBillAndReturnId();
    String item = addItem(billId, "Teh O", "1", "2.00");
    String inviteToken = generateInviteToken(billId);
    JsonNode guestJoin = joinAs(inviteToken, null, "Guest");
    String guestToken = guestJoin.get("guestToken").asText();
    String guestParticipantId = guestJoin.get("participantId").asText();

    var claimBody =
        objectMapper
            .createObjectNode()
            .put("participantId", guestParticipantId)
            .put("claimType", "QUANTITY")
            .put("value", "1");
    mockMvc.perform(
        MockMvcRequestBuilders.post(
                "/api/v1/bagilah/guest/" + guestToken + "/items/" + item + "/claims")
            .contentType(MediaType.APPLICATION_JSON)
            .content(claimBody.toString()));

    var paymentBody = objectMapper.createObjectNode().put("amountPaid", "2.00");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.put(
                    "/api/v1/bills/" + billId + "/payments/" + guestParticipantId))
            .contentType(MediaType.APPLICATION_JSON)
            .content(paymentBody.toString()));
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/bills/" + billId + "/finalize")));

    mockMvc
        .perform(
            MockMvcRequestBuilders.post(
                    "/api/v1/bagilah/guest/" + guestToken + "/items/" + item + "/claims")
                .contentType(MediaType.APPLICATION_JSON)
                .content(claimBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BILL_NOT_DRAFT"));
  }

  @Test
  void ownerCanSubscribeToBillEvents() throws Exception {
    String billId = createBillAndReturnId();
    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/events")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.content().contentTypeCompatibleWith(MediaType.TEXT_EVENT_STREAM));
  }

  @Test
  void guestCanSubscribeToBillEvents() throws Exception {
    String billId = createBillAndReturnId();
    String inviteToken = generateInviteToken(billId);
    JsonNode guestJoin = joinAs(inviteToken, null, "Guest");
    String guestToken = guestJoin.get("guestToken").asText();

    mockMvc
        .perform(MockMvcRequestBuilders.get("/api/v1/bagilah/guest/" + guestToken + "/events"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.content().contentTypeCompatibleWith(MediaType.TEXT_EVENT_STREAM));
  }
}
