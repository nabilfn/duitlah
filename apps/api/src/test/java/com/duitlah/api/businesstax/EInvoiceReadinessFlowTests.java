package com.duitlah.api.businesstax;

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
 * Duitlah V2 Phase 10 — business tax infrastructure: e-Invoice readiness and the versioned mandate
 * threshold, SST rates/reporting.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class EInvoiceReadinessFlowTests {

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

    ownerToken = register("tax-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "TaxCo").put("legalName", "TaxCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
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
  void aFreshBusinessProfileIsMissingEveryReadinessField() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-tax/einvoice-readiness")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.ready").value(false))
        .andExpect(MockMvcResultMatchers.jsonPath("$.mandated").value(false))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.missingFields", org.hamcrest.Matchers.hasItem("tin")))
        .andExpect(
            MockMvcResultMatchers.jsonPath(
                "$.missingFields", org.hamcrest.Matchers.hasItem("annualRevenue")));
  }

  @Test
  void completingEveryFieldMakesTheProfileReady() throws Exception {
    var updateBody =
        objectMapper
            .createObjectNode()
            .put("legalName", "TaxCo Sdn Bhd")
            .put("registrationNumber", "202301000123")
            .put("tin", "C1234567890")
            .put("businessType", "Sdn Bhd")
            .put("industry", "Retail")
            .put("financialYearStart", "2026-01-01")
            .put("financialYearEnd", "2026-12-31")
            .put("annualRevenue", "2000000.00");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.put("/api/v1/spaces/" + spaceId + "/business-profile"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.annualRevenue").value(2000000.00));

    // RM2,000,000 exceeds the RM1,000,000 threshold in effect since 2026-01-01.
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-tax/einvoice-readiness")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.ready").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$.mandated").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$.missingFields").isEmpty());
  }

  @Test
  void belowThresholdRevenueIsNotMandated() throws Exception {
    var updateBody =
        objectMapper
            .createObjectNode()
            .put("legalName", "TaxCo Sdn Bhd")
            .put("registrationNumber", "202301000123")
            .put("tin", "C1234567890")
            .put("businessType", "Sdn Bhd")
            .put("industry", "Retail")
            .put("financialYearStart", "2026-01-01")
            .put("financialYearEnd", "2026-12-31")
            .put("annualRevenue", "300000.00");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.put("/api/v1/spaces/" + spaceId + "/business-profile"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(updateBody.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-tax/einvoice-readiness")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.ready").value(true))
        .andExpect(MockMvcResultMatchers.jsonPath("$.mandated").value(false));
  }

  @Test
  void sstRatesListsTheSeededStandardRates() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-tax/sst-rates")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.taxType=='SALES')].ratePercent").value(10.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.taxType=='SERVICE')].ratePercent").value(8.00));
  }

  @Test
  void sstReportIsZeroWithNoChartOfAccountsSeeded() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/business-tax/sst-report?from=2026-01-01&to=2026-12-31")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.collectedTax").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.payableTax").value(0));
  }

  @Test
  void sstReportReflectsTaxCollectedOnARealIssuedInvoice() throws Exception {
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));

    var customer = objectMapper.createObjectNode().put("name", "Report Customer Sdn Bhd");
    var customerResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
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
                    .put("description", "Consulting")
                    .put("quantity", "1")
                    .put("unitPrice", "1000.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-03-15")
            .put("dueDate", "2026-04-15")
            .put("taxPercent", "8.00")
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

    // 8% of 1000.00 = 80.00.
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/business-tax/sst-report?from=2026-03-01&to=2026-03-31")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.collectedTax").value(80.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.payableTax").value(80.00));
  }
}
