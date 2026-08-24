package com.duitlah.api.einvoice;

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
 * Duitlah V2 Phase 10 — spec section 55: "Production must never return fake success." No provider
 * is configured in this test class (the real default {@link UnavailableEInvoiceProvider} stays
 * active, unlike {@code EInvoiceWorkflowFlowTests}), proving submission fails honestly rather than
 * fabricating a result. Also covers the readiness/TIN/issued-invoice guards that run before any
 * provider call is even attempted.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class EInvoiceUnavailableFlowTests {

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

    ownerToken = register("noprov-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "NoProvCo")
            .put("legalName", "NoProvCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var profileBody =
        objectMapper
            .createObjectNode()
            .put("legalName", "NoProvCo Sdn Bhd")
            .put("tin", "C1111111111");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.put("/api/v1/spaces/" + spaceId + "/business-profile"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(profileBody.toString()));
  }

  private String createCustomer(String tin) throws Exception {
    var body = objectMapper.createObjectNode().put("name", "A Customer");
    if (tin != null) {
      body.put("tin", tin);
    }
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

  private String createInvoice(String customerId, boolean issue) throws Exception {
    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Service")
                    .put("quantity", "1")
                    .put("unitPrice", "500.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-03-01")
            .put("dueDate", "2026-03-31")
            .set("lineItems", lineItems);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(invoiceBody.toString()))
            .andReturn();
    String invoiceId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
    if (issue) {
      mockMvc.perform(
          as(
                  ownerToken,
                  MockMvcRequestBuilders.patch(
                      "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
              .contentType(MediaType.APPLICATION_JSON)
              .content(objectMapper.createObjectNode().put("status", "SENT").toString()));
    }
    return invoiceId;
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
  void submittingWithoutAConfiguredProviderFailsHonestlyRatherThanFakingSuccess() throws Exception {
    String customerId = createCustomer("C9999999999");
    String invoiceId = createInvoice(customerId, true);

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/prepare")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("READY"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/submit")))
        .andExpect(MockMvcResultMatchers.status().isServiceUnavailable())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("EINVOICE_PROVIDER_UNAVAILABLE"));

    // The failed attempt itself must still be logged (spec section 56: "all provider interactions
    // must be auditable") even though the surrounding request rolled back and returned an error —
    // this was a real bug: the log write was originally rolled back along with everything else.
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/logs")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].operation").value("SUBMIT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].success").value(false));
  }

  @Test
  void aDraftInvoiceCannotBePrepared() throws Exception {
    String customerId = createCustomer("C9999999999");
    String invoiceId = createInvoice(customerId, false);

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/prepare")))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVOICE_NOT_ISSUED"));
  }

  @Test
  void aCustomerWithoutATinBlocksPreparation() throws Exception {
    String customerId = createCustomer(null);
    String invoiceId = createInvoice(customerId, true);

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/prepare")))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("EINVOICE_BUYER_TIN_MISSING"));
  }

  @Test
  void aBusinessWithoutATinBlocksPreparation() throws Exception {
    String noTinToken = register("notin-owner@example.com", "No Tin Owner");
    var body =
        objectMapper.createObjectNode().put("name", "NoTinCo").put("legalName", "NoTinCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(noTinToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String noTinSpaceId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var customer =
        objectMapper.createObjectNode().put("name", "A Customer").put("tin", "C1231231230");
    var customerResult =
        mockMvc
            .perform(
                as(
                        noTinToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + noTinSpaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customer.toString()))
            .andReturn();
    String customerId =
        objectMapper.readTree(customerResult.getResponse().getContentAsString()).get("id").asText();

    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Service")
                    .put("quantity", "1")
                    .put("unitPrice", "500.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-03-01")
            .put("dueDate", "2026-03-31")
            .set("lineItems", lineItems);
    var invoiceResult =
        mockMvc
            .perform(
                as(
                        noTinToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + noTinSpaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(invoiceBody.toString()))
            .andReturn();
    String invoiceId =
        objectMapper.readTree(invoiceResult.getResponse().getContentAsString()).get("id").asText();
    mockMvc.perform(
        as(
                noTinToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + noTinSpaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("status", "SENT").toString()));

    mockMvc
        .perform(
            as(
                noTinToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + noTinSpaceId
                        + "/invoices/"
                        + invoiceId
                        + "/einvoice/prepare")))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("EINVOICE_SELLER_TIN_MISSING"));
  }
}
