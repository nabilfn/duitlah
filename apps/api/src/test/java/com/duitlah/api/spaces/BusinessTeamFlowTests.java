package com.duitlah.api.spaces;

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

/** Duitlah V2 Phase 5 — real server-enforced RBAC (spec section 33), not hidden-button security. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BusinessTeamFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String staffToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("owner@example.com", "Owner");
    register("staff@example.com", "Staff Member");

    var body =
        objectMapper.createObjectNode().put("name", "TeamCo").put("legalName", "TeamCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper.createObjectNode().put("email", "staff@example.com").put("role", "STAFF");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(addBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    staffToken = login("staff@example.com");
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

  private String memberIdByEmail(String email) throws Exception {
    var members =
        objectMapper.readTree(
            mockMvc
                .perform(
                    as(
                        ownerToken,
                        MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/members")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    for (var member : members) {
      if (member.get("email").asText().equals(email)) {
        return member.get("id").asText();
      }
    }
    throw new IllegalStateException("No member with email " + email);
  }

  @Test
  void addingAMemberByEmailMakesThemAnActiveTeamMember() throws Exception {
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/members")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.email=='staff@example.com')].role")
                .value("STAFF"));
  }

  @Test
  void aStaffMemberCannotManageTheTeamButCanReadTheSpace() throws Exception {
    var addBody =
        objectMapper.createObjectNode().put("email", "owner@example.com").put("role", "ADMIN");
    mockMvc
        .perform(
            as(staffToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(addBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));

    mockMvc
        .perform(
            as(staffToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/members")))
        .andExpect(MockMvcResultMatchers.status().isOk());
  }

  @Test
  void changingARoleTakesEffectImmediately() throws Exception {
    String staffMemberId = memberIdByEmail("staff@example.com");

    var changeBody = objectMapper.createObjectNode().put("role", "ADMIN");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.patch(
                        "/api/v1/spaces/" + spaceId + "/members/" + staffMemberId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(changeBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.role").value("ADMIN"));
  }

  @Test
  void theSoleOwnerCannotBeRemovedOrDemoted() throws Exception {
    String ownerMemberId = memberIdByEmail("owner@example.com");

    var demoteBody = objectMapper.createObjectNode().put("role", "ADMIN");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.patch(
                        "/api/v1/spaces/" + spaceId + "/members/" + ownerMemberId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(demoteBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("LAST_OWNER"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/members/" + ownerMemberId)))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("LAST_OWNER"));
  }

  @Test
  void removingAMemberDropsThemFromTheActiveList() throws Exception {
    String staffMemberId = memberIdByEmail("staff@example.com");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/members/" + staffMemberId)))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/members")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));
  }
}
