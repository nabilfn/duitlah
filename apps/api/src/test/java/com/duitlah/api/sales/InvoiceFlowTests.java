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

/**
 * Duitlah V2 Phase 5. Invoice.status only ever holds DRAFT/SENT/VOID — PARTIALLY_PAID/PAID/OVERDUE
 * are computed fresh in every response. See {@code InvoiceService}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class InvoiceFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String customerId;
  private String businessAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("inv-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "InvCo").put("legalName", "InvCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

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

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Main Account")
            .put("type", "BANK")
            .put("openingBalance", "0.00");
    var accountResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/business-accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    businessAccountId =
        objectMapper.readTree(accountResult.getResponse().getContentAsString()).get("id").asText();
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

  private String createInvoice(String dueDate) throws Exception {
    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Consulting")
                    .put("quantity", "10")
                    .put("unitPrice", "100.00"));
    var body =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-08-01")
            .put("dueDate", dueDate)
            .set("lineItems", lineItems);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void creatingAnInvoiceComputesTotalsAndStartsAsDraft() throws Exception {
    String invoiceId = createInvoice("2026-09-01");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.invoiceNumber").value("INV-00001"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DRAFT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.effectiveStatus").value("DRAFT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.total").value(1000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountOutstanding").value(1000.00));
  }

  @Test
  void anOverdueSentInvoiceWithNoPaymentIsComputedAsOverdue() throws Exception {
    String invoiceId = createInvoice("2020-01-01");

    var statusBody = objectMapper.createObjectNode().put("status", "SENT");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(statusBody.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.effectiveStatus").value("OVERDUE"));
  }

  @Test
  void aPartialPaymentIsReflectedAsPartiallyPaidAndCreditsTheAccount() throws Exception {
    String invoiceId = createInvoice("2026-09-01");

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", businessAccountId)
            .put("amount", "400.00")
            .put("paidOn", "2026-08-10");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(paymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.effectiveStatus").value("PARTIALLY_PAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountPaid").value(400.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountOutstanding").value(600.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + businessAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(400.00));
  }

  @Test
  void payingTheFullAmountMarksTheInvoicePaid() throws Exception {
    String invoiceId = createInvoice("2026-09-01");

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", businessAccountId)
            .put("amount", "1000.00")
            .put("paidOn", "2026-08-10");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(paymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.effectiveStatus").value("PAID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amountOutstanding").value(0.00));
  }

  @Test
  void aVoidInvoiceCannotReceivePayments() throws Exception {
    String invoiceId = createInvoice("2026-09-01");

    var statusBody = objectMapper.createObjectNode().put("status", "VOID");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(statusBody.toString()));

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", businessAccountId)
            .put("amount", "100.00")
            .put("paidOn", "2026-08-10");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(paymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVOICE_VOID"));
  }

  @Test
  void gettingAnInvoiceFromAnotherSpaceIsNotFound() throws Exception {
    String otherOwnerToken = register("inv-other-owner@example.com", "Other Owner");
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "OtherInvCo")
            .put("legalName", "OtherInvCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(otherOwnerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String otherSpaceId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
    String invoiceId = createInvoice("2026-09-01");

    mockMvc
        .perform(
            as(
                otherOwnerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + otherSpaceId + "/invoices/" + invoiceId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
