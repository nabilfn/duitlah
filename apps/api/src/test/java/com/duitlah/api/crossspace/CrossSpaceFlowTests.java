package com.duitlah.api.crossspace;

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
 * Duitlah V2 Phase 11 — Cross-Space Accounting: business advance, reimbursement, owner
 * contribution, owner drawing, and the privacy/traceability guards around them.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class CrossSpaceFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String bankAccountId;
  private String personalAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("crossspace-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "CrossCo").put("legalName", "CrossCo Sdn Bhd");
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

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Main Bank")
            .put("type", "BANK")
            .put("openingBalance", "10000.00");
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

    String bankLedgerAccountId = ledgerAccountIdByCode("1010");
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

    var personalAccountBody =
        objectMapper.createObjectNode().put("name", "Personal Bank").put("type", "BANK");
    var personalAccountResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(personalAccountBody.toString()))
            .andReturn();
    personalAccountId =
        objectMapper
            .readTree(personalAccountResult.getResponse().getContentAsString())
            .get("id")
            .asText();
  }

  private String ledgerAccountIdByCode(String code) throws Exception {
    var listResult =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
            .andReturn();
    for (var node : objectMapper.readTree(listResult.getResponse().getContentAsString())) {
      if (node.get("code").asText().equals(code)) {
        return node.get("id").asText();
      }
    }
    throw new IllegalStateException("Ledger account not found for code " + code);
  }

  private String createPersonalTransaction(String token, String type, String amount)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", personalAccountId)
            .put("type", type)
            .put("amount", amount)
            .put("occurredOn", "2026-08-20");
    var result =
        mockMvc
            .perform(
                as(token, MockMvcRequestBuilders.post("/api/v1/transactions"))
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
  void businessAdvancePostsDebitExpenseCreditDueToOwner() throws Exception {
    String transactionId = createPersonalTransaction(ownerToken, "EXPENSE", "1299.00");
    String expenseAccountId = ledgerAccountIdByCode("6900");

    var body =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", transactionId)
            .put("expenseChartOfAccountsId", expenseAccountId)
            .put("amount", "1299.00")
            .put("occurredOn", "2026-08-20")
            .put("description", "TechKita software");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/crossspace/business-advance"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.linkType").value("BUSINESS_ADVANCE"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.businessJournalEntryId").isNotEmpty());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='6900')].debit")
                .value(1299.00))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='2030')].credit")
                .value(1299.00));
  }

  @Test
  void businessAdvanceWithoutDueToOwnerAccountIsRejected() throws Exception {
    // A space using a fully custom Chart of Accounts (not the seeded defaults) that never
    // included a "Due to Owner" account at all -- genuinely absent, not merely archived (archiving
    // an existing one instead surfaces JournalEntryService's own more specific
    // 409 LEDGER_ACCOUNT_ARCHIVED, a different and already-correct guard).
    var customSpaceBody =
        objectMapper
            .createObjectNode()
            .put("name", "NoOwnerCo")
            .put("legalName", "NoOwnerCo Sdn Bhd");
    var customSpaceResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customSpaceBody.toString()))
            .andReturn();
    String customSpaceId =
        objectMapper
            .readTree(customSpaceResult.getResponse().getContentAsString())
            .get("id")
            .asText();

    var customExpenseBody =
        objectMapper
            .createObjectNode()
            .put("code", "9999")
            .put("name", "Test Expense")
            .put("type", "EXPENSE");
    var customExpenseResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + customSpaceId + "/accounting/chart-of-accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customExpenseBody.toString()))
            .andReturn();
    String customExpenseAccountId =
        objectMapper
            .readTree(customExpenseResult.getResponse().getContentAsString())
            .get("id")
            .asText();

    String transactionId = createPersonalTransaction(ownerToken, "EXPENSE", "500.00");
    var body =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", transactionId)
            .put("expenseChartOfAccountsId", customExpenseAccountId)
            .put("amount", "500.00")
            .put("occurredOn", "2026-08-20");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + customSpaceId + "/crossspace/business-advance"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("DUE_TO_OWNER_ACCOUNT_MISSING"));
  }

  @Test
  void reimbursementClearsDueToOwnerAndReducesBusinessBalance() throws Exception {
    String advanceTransactionId = createPersonalTransaction(ownerToken, "EXPENSE", "1299.00");
    String expenseAccountId = ledgerAccountIdByCode("6900");
    var advanceBody =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", advanceTransactionId)
            .put("expenseChartOfAccountsId", expenseAccountId)
            .put("amount", "1299.00")
            .put("occurredOn", "2026-08-20");
    var advanceResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/crossspace/business-advance"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(advanceBody.toString()))
            .andReturn();
    String advanceLinkId =
        objectMapper.readTree(advanceResult.getResponse().getContentAsString()).get("id").asText();

    String reimbursementTransactionId = createPersonalTransaction(ownerToken, "INCOME", "1299.00");
    var reimbursementBody =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", reimbursementTransactionId)
            .put("businessAccountId", bankAccountId)
            .put("relatedLinkId", advanceLinkId)
            .put("amount", "1299.00")
            .put("occurredOn", "2026-08-21");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/crossspace/reimbursement"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(reimbursementBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.relatedLinkId").value(advanceLinkId));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + bankAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(8701.00));

    // Due to Owner nets to zero: 1299 credited by the advance, 1299 debited by the reimbursement.
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/general-ledger?accountId="
                        + ledgerAccountIdByCode("2030")
                        + "&from=2026-01-01&to=2026-12-31")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.closingBalance").value(0));
  }

  @Test
  void reimbursementWithAWronglyTypedRelatedLinkIsRejected() throws Exception {
    String contributionTransactionId = createPersonalTransaction(ownerToken, "EXPENSE", "1000.00");
    var contributionBody =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", contributionTransactionId)
            .put("businessAccountId", bankAccountId)
            .put("amount", "1000.00")
            .put("occurredOn", "2026-08-20");
    var contributionResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/crossspace/owner-contribution"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(contributionBody.toString()))
            .andReturn();
    String contributionLinkId =
        objectMapper
            .readTree(contributionResult.getResponse().getContentAsString())
            .get("id")
            .asText();

    String reimbursementTransactionId = createPersonalTransaction(ownerToken, "INCOME", "500.00");
    var reimbursementBody =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", reimbursementTransactionId)
            .put("businessAccountId", bankAccountId)
            .put("relatedLinkId", contributionLinkId)
            .put("amount", "500.00")
            .put("occurredOn", "2026-08-21");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/crossspace/reimbursement"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(reimbursementBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.code").value("CROSS_SPACE_LINK_TYPE_MISMATCH"));
  }

  @Test
  void ownerContributionCreditsCapitalNotRevenueAndIncreasesBalance() throws Exception {
    String transactionId = createPersonalTransaction(ownerToken, "EXPENSE", "5000.00");
    var body =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", transactionId)
            .put("businessAccountId", bankAccountId)
            .put("amount", "5000.00")
            .put("occurredOn", "2026-08-20");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/crossspace/owner-contribution"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.linkType").value("OWNER_CONTRIBUTION"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + bankAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(15000.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='3000')].credit")
                .value(5000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='4000')]").isEmpty())
        .andExpect(MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='4010')]").isEmpty());
  }

  @Test
  void ownerDrawingDebitsDrawingsNotExpenseAndDecreasesBalance() throws Exception {
    String transactionId = createPersonalTransaction(ownerToken, "INCOME", "2000.00");
    var body =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", transactionId)
            .put("businessAccountId", bankAccountId)
            .put("amount", "2000.00")
            .put("occurredOn", "2026-08-20");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/crossspace/owner-drawing"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.linkType").value("OWNER_DRAWING"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + bankAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(8000.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/accounting/reports/trial-balance?asOf=2026-08-20")))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.lines[?(@.accountCode=='3020')].debit")
                .value(2000.00));
  }

  @Test
  void aStaffMemberCannotLinkAnotherUsersPersonalTransaction() throws Exception {
    String otherUserToken = register("crossspace-other@example.com", "Other");
    var otherAccountBody =
        objectMapper.createObjectNode().put("name", "Other Bank").put("type", "BANK");
    var otherAccountResult =
        mockMvc
            .perform(
                as(otherUserToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(otherAccountBody.toString()))
            .andReturn();
    String otherAccountId =
        objectMapper
            .readTree(otherAccountResult.getResponse().getContentAsString())
            .get("id")
            .asText();
    var otherTxBody =
        objectMapper
            .createObjectNode()
            .put("accountId", otherAccountId)
            .put("type", "EXPENSE")
            .put("amount", "100.00")
            .put("occurredOn", "2026-08-20");
    var otherTxResult =
        mockMvc
            .perform(
                as(otherUserToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(otherTxBody.toString()))
            .andReturn();
    String otherTransactionId =
        objectMapper.readTree(otherTxResult.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper
            .createObjectNode()
            .put("email", "crossspace-other@example.com")
            .put("role", "ADMIN");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));

    String expenseAccountId = ledgerAccountIdByCode("6900");
    var body =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", otherTransactionId)
            .put("expenseChartOfAccountsId", expenseAccountId)
            .put("amount", "100.00")
            .put("occurredOn", "2026-08-20");

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/crossspace/business-advance"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("TRANSACTION_NOT_FOUND"));
  }

  @Test
  void listEndpointsReturnRecordedLinks() throws Exception {
    String transactionId = createPersonalTransaction(ownerToken, "EXPENSE", "300.00");
    String expenseAccountId = ledgerAccountIdByCode("6900");
    var body =
        objectMapper
            .createObjectNode()
            .put("personalTransactionId", transactionId)
            .put("expenseChartOfAccountsId", expenseAccountId)
            .put("amount", "300.00")
            .put("occurredOn", "2026-08-20");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/crossspace/business-advance"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/crossspace/links")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));

    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/crossspace/links")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));
  }
}
