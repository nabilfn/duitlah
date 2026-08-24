package com.duitlah.api.sales;

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
class QuotationFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String viewerToken;
  private String spaceId;
  private String customerId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("quote-owner@example.com", "Owner");
    register("quote-viewer@example.com", "Viewer");

    var body =
        objectMapper.createObjectNode().put("name", "QuoteCo").put("legalName", "QuoteCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper
            .createObjectNode()
            .put("email", "quote-viewer@example.com")
            .put("role", "VIEWER");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    viewerToken = login("quote-viewer@example.com");

    var customerBody = objectMapper.createObjectNode().put("name", "Client Sdn Bhd");
    var customerResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customerBody.toString()))
            .andReturn();
    customerId =
        objectMapper.readTree(customerResult.getResponse().getContentAsString()).get("id").asText();
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

  private com.fasterxml.jackson.databind.JsonNode lineItem(
      String description, String qty, String unitPrice) {
    return objectMapper
        .createObjectNode()
        .put("description", description)
        .put("quantity", qty)
        .put("unitPrice", unitPrice);
  }

  private String createQuotation() throws Exception {
    var lineItems = objectMapper.createArrayNode().add(lineItem("Website design", "2", "1500.00"));
    var body =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-01")
            .put("taxPercent", "6.00")
            .set("lineItems", lineItems);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/quotations"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void creatingAQuotationComputesSubtotalTaxAndTotal() throws Exception {
    String quotationId = createQuotation();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/quotations/" + quotationId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.quoteNumber").value("Q-00001"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DRAFT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.subtotal").value(3000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.taxAmount").value(180.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.total").value(3180.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.lineItems.length()").value(1));
  }

  @Test
  void aViewerCannotCreateAQuotation() throws Exception {
    var lineItems = objectMapper.createArrayNode().add(lineItem("Blocked item", "1", "100.00"));
    var body =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-01")
            .set("lineItems", lineItems);
    mockMvc
        .perform(
            as(
                    viewerToken,
                    MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/quotations"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void convertingANonAcceptedQuotationToAnInvoiceIsRejected() throws Exception {
    String quotationId = createQuotation();

    var convertBody = objectMapper.createObjectNode().put("dueDate", "2026-09-01");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/quotations/"
                            + quotationId
                            + "/convert-to-invoice"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(convertBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("QUOTATION_NOT_ACCEPTED"));
  }

  @Test
  void acceptingAQuotationAndConvertingItCreatesAMatchingDraftInvoice() throws Exception {
    String quotationId = createQuotation();

    var statusBody = objectMapper.createObjectNode().put("status", "ACCEPTED");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.patch(
                        "/api/v1/spaces/" + spaceId + "/quotations/" + quotationId + "/status"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(statusBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("ACCEPTED"));

    var convertBody = objectMapper.createObjectNode().put("dueDate", "2026-09-01");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/quotations/"
                            + quotationId
                            + "/convert-to-invoice"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(convertBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.invoiceNumber").value("INV-00001"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DRAFT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.effectiveStatus").value("DRAFT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.total").value(3180.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.convertedFromQuotationId").value(quotationId))
        .andExpect(MockMvcResultMatchers.jsonPath("$.lineItems.length()").value(1));
  }
}
