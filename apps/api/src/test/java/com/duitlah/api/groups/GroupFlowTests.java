package com.duitlah.api.groups;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
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
class GroupFlowTests {

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String ownerToken;
  private String ownerUserId;
  private String memberToken;
  private String memberUserId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var owner = registerAndReturn("owner@example.com", "Nabil");
    ownerToken = owner.get("accessToken").asText();
    ownerUserId = owner.get("user").get("id").asText();

    var member = registerAndReturn("member@example.com", "Ameer");
    memberToken = member.get("accessToken").asText();
    memberUserId = member.get("user").get("id").asText();
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

  private String createGroupAndReturnId() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Housemates").put("type", "HOUSEMATES");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.yourRole").value("OWNER"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.memberCount").value(1))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private void joinGroup(String groupId, String token) throws Exception {
    String inviteToken =
        objectMapper
            .readTree(
                mockMvc
                    .perform(
                        as(
                            ownerToken,
                            MockMvcRequestBuilders.post(
                                "/api/v1/groups/" + groupId + "/invite-token")))
                    .andReturn()
                    .getResponse()
                    .getContentAsString())
            .get("token")
            .asText();
    var joinBody = objectMapper.createObjectNode().put("token", inviteToken);
    mockMvc
        .perform(
            as(token, MockMvcRequestBuilders.post("/api/v1/groups/join"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(joinBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());
  }

  @Test
  void creatingAGroupMakesTheCreatorTheOwner() throws Exception {
    createGroupAndReturnId();
  }

  @Test
  void invalidInviteTokenIsRejected() throws Exception {
    var joinBody = objectMapper.createObjectNode().put("token", "not-a-real-token");
    mockMvc
        .perform(
            as(memberToken, MockMvcRequestBuilders.post("/api/v1/groups/join"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(joinBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_INVITE"));
  }

  @Test
  void joiningViaInviteAddsMemberAndListsBothMembers() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, memberToken);

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/groups/" + groupId + "/members")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + memberUserId + "')].role")
                .value("MEMBER"));
  }

  @Test
  void nonMemberCannotAccessGroup() throws Exception {
    String groupId = createGroupAndReturnId();

    mockMvc
        .perform(as(memberToken, MockMvcRequestBuilders.get("/api/v1/groups/" + groupId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  @Test
  void groupExpenseSplitsEquallyAndSharesSumExactlyToTheAmount() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, memberToken);

    // RM100.00 split 3 ways doesn't divide evenly (33.33 repeating) —
    // exercise a third member too so the rounding remainder is real.
    var thirdUser = registerAndReturn("third@example.com", "Syaz");
    String thirdToken = thirdUser.get("accessToken").asText();
    joinGroup(groupId, thirdToken);

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("description", "Groceries")
            .put("amount", "100.00")
            .put("occurredOn", "2026-08-01");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(expenseBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();

    JsonNode expense = objectMapper.readTree(result.getResponse().getContentAsString());
    JsonNode shareList = expense.get("shares");
    assertThat(shareList).hasSize(3);
    BigDecimal total = BigDecimal.ZERO;
    for (JsonNode share : shareList) {
      total = total.add(new BigDecimal(share.get("amount").asText()));
    }
    assertThat(total).isEqualByComparingTo("100.00");
  }

  @Test
  void groupBalanceMatchesPaidMinusShare() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, memberToken);

    // Owner pays RM1120 for a shared expense split equally between the two of them.
    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("description", "August groceries")
            .put("amount", "1120.00")
            .put("occurredOn", "2026-08-01");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(expenseBody.toString()));

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/groups/" + groupId + "/balances")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + ownerUserId + "')].totalPaid")
                .value(1120.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + ownerUserId + "')].totalShare")
                .value(560.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + ownerUserId + "')].net")
                .value(560.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.userId=='" + memberUserId + "')].net")
                .value(-560.00));
  }

  @Test
  void ownerCannotBeRemovedButNonOwnerCanLeave() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, memberToken);

    mockMvc
        .perform(
            as(
                memberToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/groups/" + groupId + "/members/" + ownerUserId)))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("CANNOT_REMOVE_OWNER"));

    mockMvc
        .perform(
            as(
                memberToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/groups/" + groupId + "/members/" + memberUserId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());
  }

  @Test
  void onlyOwnerOrCreatorCanDeleteAnExpense() throws Exception {
    String groupId = createGroupAndReturnId();
    joinGroup(groupId, memberToken);

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("description", "Snacks")
            .put("amount", "20.00")
            .put("occurredOn", "2026-08-01");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(expenseBody.toString()))
            .andReturn();
    String expenseId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    // The non-owner, non-creator member cannot delete the owner's expense.
    mockMvc
        .perform(
            as(
                memberToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/groups/" + groupId + "/expenses/" + expenseId)))
        .andExpect(MockMvcResultMatchers.status().isForbidden());

    // The owner (who also created it) can.
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/groups/" + groupId + "/expenses/" + expenseId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());
  }

  @Test
  void payerMustBeAGroupMember() throws Exception {
    String groupId = createGroupAndReturnId();
    var outsider = registerAndReturn("outsider@example.com", "Outsider");
    String outsiderId = outsider.get("user").get("id").asText();

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("description", "Dinner")
            .put("amount", "50.00")
            .put("occurredOn", "2026-08-01")
            .put("paidByUserId", outsiderId);
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/groups/" + groupId + "/expenses"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(expenseBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("PAYER_NOT_A_MEMBER"));
  }
}
