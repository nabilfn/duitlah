package com.duitlah.api.catalog;

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
class ProductFlowTests {

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

    ownerToken = register("cat-owner@example.com", "Owner");
    register("cat-staff@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "CatCo").put("legalName", "CatCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper.createObjectNode().put("email", "cat-staff@example.com").put("role", "STAFF");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    staffToken = login("cat-staff@example.com");
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

  private String createProduct(String token, String name, String type, String unitPrice)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", type)
            .put("unitPrice", unitPrice);
    var result =
        mockMvc
            .perform(
                as(token, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/products"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void creatingAProductDefaultsUnitAndActive() throws Exception {
    createProduct(ownerToken, "Consulting Hour", "SERVICE", "150.00");

    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/products")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("Consulting Hour"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].unit").value("unit"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].active").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].unitPrice").value(150.00));
  }

  @Test
  void aStaffMemberWithoutManageProductsCannotCreateOne() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Blocked")
            .put("type", "GOODS")
            .put("unitPrice", "10.00");
    mockMvc
        .perform(
            as(staffToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/products"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void creatingATrackedProductPersistsInventoryFields() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Flour (25kg)")
            .put("type", "GOODS")
            .put("unitPrice", "80.00")
            .put("cost", "45.00")
            .put("taxClassification", "ZERO_RATED")
            .put("trackInventory", true)
            .put("reorderPoint", "10.000");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/products"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String productId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/products/" + productId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.cost").value(45.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.taxClassification").value("ZERO_RATED"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.trackInventory").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$.reorderPoint").value(10.000));
  }

  @Test
  void omittingTrackInventoryDefaultsToFalse() throws Exception {
    String productId = createProduct(ownerToken, "Untracked Widget", "GOODS", "5.00");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/products/" + productId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.trackInventory").value(false))
        .andExpect(MockMvcResultMatchers.jsonPath("$.taxClassification").value("NOT_APPLICABLE"));
  }

  @Test
  void archivingAProductSetsActiveFalse() throws Exception {
    String productId = createProduct(ownerToken, "Widget", "GOODS", "25.00");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId)))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/products/" + productId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.active").value(false));
  }
}
