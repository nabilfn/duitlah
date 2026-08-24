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

/** Duitlah V2 Phase 8 — ingredient/recipe costing. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class RecipeCostingFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("recipe-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "CafeCo").put("legalName", "CafeCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private String createProduct(String name, String unitPrice, boolean trackInventory, String cost)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", "GOODS")
            .put("unitPrice", unitPrice)
            .put("trackInventory", trackInventory);
    if (cost != null) {
      body.put("cost", cost);
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

  private void addIngredient(String productId, String ingredientId, String quantityPerUnit)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("ingredientProductId", ingredientId)
            .put("quantityPerUnit", quantityPerUnit);
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + productId + "/recipe"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
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

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  @Test
  void recipeCostIsTheSumOfIngredientLinesAndDrivesGrossMargin() throws Exception {
    String coffee = createProduct("Cappuccino", "12.00", false, null);
    String beans = createProduct("Coffee Beans (kg)", "0", false, "40.00");
    String milk = createProduct("Milk (L)", "0", false, "6.00");

    addIngredient(coffee, beans, "0.02");
    addIngredient(coffee, milk, "0.15");

    // (0.02 * 40.00) + (0.15 * 6.00) = 0.80 + 0.90 = 1.70
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + coffee + "/recipe/cost")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.unitCost").value(1.70))
        .andExpect(MockMvcResultMatchers.jsonPath("$.sellingPrice").value(12.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.grossMargin").value(10.30));
  }

  @Test
  void aProductCannotBeItsOwnIngredient() throws Exception {
    String coffee = createProduct("Latte", "10.00", false, null);
    var body =
        objectMapper
            .createObjectNode()
            .put("ingredientProductId", coffee)
            .put("quantityPerUnit", "1");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/products/" + coffee + "/recipe"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.code").value("PRODUCT_CANNOT_BE_ITS_OWN_INGREDIENT"));
  }

  @Test
  void removingAnIngredientDropsItFromTheCost() throws Exception {
    String coffee = createProduct("Mocha", "15.00", false, null);
    String beans = createProduct("Cocoa (kg)", "0", false, "20.00");
    var addResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/products/" + coffee + "/recipe"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper
                            .createObjectNode()
                            .put("ingredientProductId", beans)
                            .put("quantityPerUnit", "0.05")
                            .toString()))
            .andReturn();
    String itemId =
        objectMapper.readTree(addResult.getResponse().getContentAsString()).get("id").asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/products/" + coffee + "/recipe/" + itemId)))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + coffee + "/recipe/cost")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.unitCost").value(0));
  }
}
