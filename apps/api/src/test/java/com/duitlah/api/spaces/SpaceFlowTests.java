package com.duitlah.api.spaces;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.UUID;
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
 * Duitlah V2 Phase 1. Note: the existing-user backfill in V16's own migration SQL (every
 * pre-existing {@code users} row gets a PERSONAL space) can't be exercised here -- a fresh
 * Testcontainers Postgres runs every migration before any test ever creates a user, so there are
 * never any "pre-existing" users for the backfill to act on in this environment. What *is* verified
 * here is the forward-going path every new registration takes from now on ({@code
 * AuthService.register} calling {@code SpaceService.createPersonalSpaceForNewUser} directly), which
 * is the equivalent real behavior post-migration.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class SpaceFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest("spaces@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
            .readTree(result.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  @Test
  void registeringCreatesExactlyOnePersonalSpaceOwnedByTheNewUser() throws Exception {
    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/spaces")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].type").value("PERSONAL"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].yourRole").value("OWNER"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].status").value("ACTIVE"));
  }

  @Test
  void creatingABusinessSpaceAddsItAlongsidePersonalAndPersistsTheProfile() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "TechKita")
            .put("legalName", "TechKita Sdn Bhd")
            .put("registrationNumber", "202601012345")
            .put("industry", "Software");

    var createResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.type").value("BUSINESS"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("TechKita"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.yourRole").value("OWNER"))
            .andReturn();
    String spaceId =
        objectMapper.readTree(createResult.getResponse().getContentAsString()).get("id").asText();

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/spaces")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2));

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/business-profile")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.legalName").value("TechKita Sdn Bhd"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.registrationNumber").value("202601012345"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.industry").value("Software"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.currency").value("MYR"));
  }

  @Test
  void aUserCannotSeeOrGetASpaceTheyAreNotAMemberOf() throws Exception {
    var otherResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "other-spaces@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken =
        objectMapper
            .readTree(otherResult.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
    var mySpaceId =
        objectMapper
            .readTree(
                mockMvc
                    .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/spaces")))
                    .andReturn()
                    .getResponse()
                    .getContentAsString())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + mySpaceId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  @Test
  void gettingTheBusinessProfileOfARandomUuidIsNotFound() throws Exception {
    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + UUID.randomUUID() + "/business-profile")))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
