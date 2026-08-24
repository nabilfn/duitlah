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

/**
 * Duitlah V2 Phase 8 — issuing an invoice for a tracked-inventory product auto-posts a SALE
 * movement and Cost of Goods Sold.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class InvoiceInventoryIntegrationFlowTests {

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

    ownerToken = register("saleinv-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "ShopCo").put("legalName", "ShopCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));
  }

  private String createTrackedProduct(String name, String unitPrice) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", "GOODS")
            .put("unitPrice", unitPrice)
            .put("trackInventory", true);
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

  private void recordOpeningBalance(String productId, String quantity, String unitCost)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "OPENING_BALANCE")
            .put("quantity", quantity)
            .put("unitCost", unitCost)
            .put("occurredOn", "2026-08-18");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));
  }

  private String createCustomer() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Retail Customer Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
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
  void issuingAnInvoiceForATrackedProductPostsASaleMovementAndCogs() throws Exception {
    String productId = createTrackedProduct("T-Shirt", "35.00");
    recordOpeningBalance(productId, "20", "15.00");
    String customerId = createCustomer();

    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("productId", productId)
                    .put("description", "T-Shirt")
                    .put("quantity", "3")
                    .put("unitPrice", "35.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-20")
            .put("dueDate", "2026-09-20")
            .set("lineItems", lineItems);
    var invoiceResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(invoiceBody.toString()))
            .andReturn();
    String invoiceId =
        objectMapper.readTree(invoiceResult.getResponse().getContentAsString()).get("id").asText();

    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("status", "SENT").toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/valuation")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.quantityOnHand").value(17));

    // 3 units at a locked-in unit cost of 15.00 = 45.00 COGS.
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='5000')].debit").value(45.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements")))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].type").value("SALE"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].unitCost").value(15.00));
  }

  @Test
  void reissuingTheSameInvoiceDoesNotDoubleCountTheSale() throws Exception {
    String productId = createTrackedProduct("Cap", "20.00");
    recordOpeningBalance(productId, "10", "8.00");
    String customerId = createCustomer();

    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("productId", productId)
                    .put("description", "Cap")
                    .put("quantity", "2")
                    .put("unitPrice", "20.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-20")
            .put("dueDate", "2026-09-20")
            .set("lineItems", lineItems);
    var invoiceResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(invoiceBody.toString()))
            .andReturn();
    String invoiceId =
        objectMapper.readTree(invoiceResult.getResponse().getContentAsString()).get("id").asText();

    var sentBody = objectMapper.createObjectNode().put("status", "SENT").toString();
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(sentBody));
    // Re-issuing (e.g. PATCH status=SENT again) must be a no-op, not a second SALE movement.
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(sentBody));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/valuation")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.quantityOnHand").value(8));
  }
}
