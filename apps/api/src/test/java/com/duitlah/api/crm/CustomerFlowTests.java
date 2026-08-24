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

/** Duitlah V2 Phase 5. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class CustomerFlowTests {

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

    ownerToken = register("crm-owner@example.com", "Owner");
    register("crm-staff@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "CrmCo").put("legalName", "CrmCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper.createObjectNode().put("email", "crm-staff@example.com").put("role", "STAFF");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    staffToken = login("crm-staff@example.com");
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

  private String createCustomer(String token, String name) throws Exception {
    var body = objectMapper.createObjectNode().put("name", name);
    var result =
        mockMvc
            .perform(
                as(token, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void creatingAndListingACustomerRoundTrips() throws Exception {
    createCustomer(ownerToken, "Acme Sdn Bhd");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/customers")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("Acme Sdn Bhd"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].paymentTermsDays").value(30))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].status").value("ACTIVE"));
  }

  @Test
  void aStaffMemberWithoutManageCustomersCannotCreateOne() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Blocked Co");
    mockMvc
        .perform(
            as(staffToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void updatingACustomerChangesItsFields() throws Exception {
    String customerId = createCustomer(ownerToken, "Beta Sdn Bhd");

    var updateBody =
        objectMapper.createObjectNode().put("name", "Beta Holdings").put("paymentTermsDays", 45);
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.put(
                        "/api/v1/spaces/" + spaceId + "/customers/" + customerId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.name").value("Beta Holdings"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.paymentTermsDays").value(45));
  }

  @Test
  void archivingACustomerMarksItArchived() throws Exception {
    String customerId = createCustomer(ownerToken, "Gamma Sdn Bhd");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/customers/" + customerId)))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/customers/" + customerId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("ARCHIVED"));
  }

  @Test
  void gettingACustomerFromAnotherSpaceIsNotFound() throws Exception {
    String otherOwnerToken = register("crm-other-owner@example.com", "Other Owner");
    var body =
        objectMapper.createObjectNode().put("name", "OtherCo").put("legalName", "OtherCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(otherOwnerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String otherSpaceId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
    String customerId = createCustomer(ownerToken, "Delta Sdn Bhd");

    mockMvc
        .perform(
            as(
                otherOwnerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + otherSpaceId + "/customers/" + customerId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
