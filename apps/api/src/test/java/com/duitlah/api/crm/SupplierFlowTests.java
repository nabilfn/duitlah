package com.duitlah.api.crm;

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
 * Duitlah V2 Phase 5. Mirrors {@link CustomerFlowTests} — see package-info for why the two entities
 * stay separate despite the identical shape.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class SupplierFlowTests {

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

    ownerToken = register("sup-owner@example.com", "Owner");
    register("sup-staff@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "SupCo").put("legalName", "SupCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper.createObjectNode().put("email", "sup-staff@example.com").put("role", "STAFF");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    staffToken = login("sup-staff@example.com");
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
  void creatingAndListingASupplierRoundTrips() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Widget Supply Sdn Bhd");
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/suppliers"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/suppliers")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("Widget Supply Sdn Bhd"));
  }

  @Test
  void aStaffMemberWithoutManageSuppliersCannotCreateOne() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Blocked Supplier");
    mockMvc
        .perform(
            as(staffToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/suppliers"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void gettingASupplierThatDoesNotExistIsNotFound() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/suppliers/" + java.util.UUID.randomUUID())))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
