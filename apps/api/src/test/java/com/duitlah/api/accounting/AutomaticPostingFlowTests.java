package com.duitlah.api.accounting;

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
 * Duitlah V2 Phase 6 — section 36: business actions ("Record Expense", "Receive Payment") post real
 * double-entry journals automatically once the space's books are mapped, and silently do nothing
 * when they aren't (see accounting's own package-info).
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AutomaticPostingFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String bankAccountId;
  private String bankLedgerAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("autopost-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "AutoPostCo")
            .put("legalName", "AutoPostCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Main Bank")
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
    bankAccountId =
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

  private void seedAndMapChartOfAccounts() throws Exception {
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));
    var listResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
            .andReturn();
    for (var node : objectMapper.readTree(listResult.getResponse().getContentAsString())) {
      if (node.get("code").asText().equals("1010")) {
        bankLedgerAccountId = node.get("id").asText();
      }
    }
    var mapBody = objectMapper.createObjectNode().put("chartOfAccountsId", bankLedgerAccountId);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/business-accounts/"
                        + bankAccountId
                        + "/chart-of-accounts-mapping"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(mapBody.toString()));
  }

  @Test
  void anExpensePaymentWithoutAChartOfAccountsPostsNoJournalEntry() throws Exception {
    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("category", "Rent")
            .put("amount", "500.00")
            .put("occurredOn", "2026-08-01");
    var expenseResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/expenses"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(expenseBody.toString()))
            .andReturn();
    String expenseId =
        objectMapper.readTree(expenseResult.getResponse().getContentAsString()).get("id").asText();

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", bankAccountId)
            .put("amount", "500.00")
            .put("paidOn", "2026-08-05");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/expenses/" + expenseId + "/payments"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(paymentBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/journal-entries")
                    .param("from", "2026-01-01")
                    .param("to", "2026-12-31")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }

  @Test
  void aMappedExpensePaymentPostsARealDebitCreditJournalEntry() throws Exception {
    seedAndMapChartOfAccounts();

    var expenseBody =
        objectMapper
            .createObjectNode()
            .put("category", "Rent")
            .put("amount", "500.00")
            .put("occurredOn", "2026-08-01");
    var expenseResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/expenses"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(expenseBody.toString()))
            .andReturn();
    String expenseId =
        objectMapper.readTree(expenseResult.getResponse().getContentAsString()).get("id").asText();

    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("businessAccountId", bankAccountId)
            .put("amount", "500.00")
            .put("paidOn", "2026-08-05");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/expenses/" + expenseId + "/payments"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(paymentBody.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/reports/trial-balance")
                    .param("asOf", "2026-08-31")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalDebit").value(500.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalCredit").value(500.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='6900')].debit")
                .value(500.00));
  }

  @Test
  void issuingAndPayingAnInvoicePostsRevenueAndReceivableJournalsThatBalance() throws Exception {
    seedAndMapChartOfAccounts();

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
            .put("issueDate", "2026-08-01")
            .put("dueDate", "2026-09-01")
            .put("taxPercent", "6.00")
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

    var statusBody = objectMapper.createObjectNode().put("status", "SENT");
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
            .put("businessAccountId", bankAccountId)
            .put("amount", "1060.00")
            .put("paidOn", "2026-08-10");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/payments"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(paymentBody.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/reports/trial-balance")
                    .param("asOf", "2026-08-31")))
        // Accounts Receivable is debited 1060 on issue and credited 1060 on payment, netting to
        // zero rather than double-counting to 2060. Bank ends up debited 1060, Sales Revenue
        // credited 1000, SST/GST Payable credited 60.
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalDebit").value(1060.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalCredit").value(1060.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1020')].debit").value(0))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1020')].credit").value(0))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='1010')].debit")
                .value(1060.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='4000')].credit")
                .value(1000.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='2020')].credit")
                .value(60.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/reports/income-statement")
                    .param("from", "2026-08-01")
                    .param("to", "2026-08-31")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalRevenue").value(1000.00));
  }
}
