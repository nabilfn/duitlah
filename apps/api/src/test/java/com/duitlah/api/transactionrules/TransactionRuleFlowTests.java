package com.duitlah.api.transactionrules;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.autotrack.CandidateSourceType;
import com.duitlah.api.autotrack.TransactionCandidate;
import com.duitlah.api.autotrack.TransactionCandidateService;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.transactions.CreateTransactionRequest;
import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionType;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
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
 * V2 Phase 13 -- transaction rules, the mechanism behind "automatic categorization" and
 * "statement-learning" too (see package-info). {@link TransactionCandidateService} is called
 * directly for the learning tests (bypassing {@code receipts}/{@code statements}, which need real
 * object storage) since a candidate's shape is the same regardless of which producer made it.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class TransactionRuleFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private TransactionCandidateService candidateService;
  @Autowired private TransactionRuleService transactionRuleService;
  @Autowired private SpaceService spaceService;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private UUID userId;
  private UUID categoryId;
  private UUID otherCategoryId;
  private UUID accountId;
  private UUID personalSpaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest("rules@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    JsonNode registerResponse = objectMapper.readTree(result.getResponse().getContentAsString());
    accessToken = registerResponse.get("accessToken").asText();
    userId = UUID.fromString(registerResponse.get("user").get("id").asText());

    categoryId = createCategory("Food");
    otherCategoryId = createCategory("Transport");

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    var accountResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId =
        UUID.fromString(
            objectMapper
                .readTree(accountResult.getResponse().getContentAsString())
                .get("id")
                .asText());
    personalSpaceId = spaceService.personalSpaceIdFor(userId);
  }

  private UUID createCategory(String name) throws Exception {
    var body = objectMapper.createObjectNode().put("name", name).put("type", "EXPENSE");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/categories"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return UUID.fromString(
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText());
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  @Test
  void createsListsUpdatesAndDeletesARule() throws Exception {
    var createBody =
        objectMapper
            .createObjectNode()
            .put("matchType", "MERCHANT_CONTAINS")
            .put("matchValue", "Starbucks")
            .put("categoryId", categoryId.toString());
    var createResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/transaction-rules"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(createBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.learned").value(false))
            .andReturn();
    String ruleId =
        objectMapper.readTree(createResult.getResponse().getContentAsString()).get("id").asText();

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/transaction-rules")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));

    var updateBody =
        objectMapper
            .createObjectNode()
            .put("matchType", "MERCHANT_EQUALS")
            .put("matchValue", "Starbucks KLCC")
            .put("categoryId", otherCategoryId.toString())
            .put("priority", 5)
            .put("active", true);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.put("/api/v1/transaction-rules/" + ruleId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.matchValue").value("Starbucks KLCC"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.priority").value(5));

    mockMvc
        .perform(auth(MockMvcRequestBuilders.delete("/api/v1/transaction-rules/" + ruleId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/transaction-rules")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }

  @Test
  void higherPriorityRuleWinsAndExactBeatsContainsAtTheSamePriority() throws Exception {
    createRule(TransactionRuleMatchType.MERCHANT_CONTAINS, "Grab", otherCategoryId, 10);
    createRule(TransactionRuleMatchType.MERCHANT_EQUALS, "GrabFood", categoryId, 10);

    assertThat(transactionRuleService.suggestCategory(userId, "GrabFood")).contains(categoryId);
    assertThat(transactionRuleService.suggestCategory(userId, "Grab Car"))
        .contains(otherCategoryId);
    assertThat(transactionRuleService.suggestCategory(userId, "Unrelated Merchant")).isEmpty();
  }

  private void createRule(
      TransactionRuleMatchType matchType, String value, UUID category, int priority)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("matchType", matchType.name())
            .put("matchValue", value)
            .put("categoryId", category.toString())
            .put("priority", priority);
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transaction-rules"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  @Test
  void confirmingACandidateLearnsAReusableRuleForThatExactMerchant() {
    TransactionCandidate candidate =
        candidateService.create(
            userId,
            personalSpaceId,
            CandidateSourceType.RECEIPT_OCR,
            null,
            null,
            new BigDecimal("25.00"),
            "MYR",
            "Uncle Tan's Nasi Lemak",
            LocalDate.of(2026, 8, 20),
            TransactionDirection.OUT,
            null,
            new BigDecimal("0.9"));

    candidateService.confirm(
        userId,
        candidate.getId(),
        new CreateTransactionRequest(
            accountId,
            TransactionType.EXPENSE,
            categoryId,
            new BigDecimal("25.00"),
            "Uncle Tan's Nasi Lemak",
            null,
            null,
            LocalDate.of(2026, 8, 20),
            null,
            null,
            null));

    // A brand-new candidate at the same merchant, with no transaction history at all involved,
    // now gets suggested straight from the learned rule.
    assertThat(transactionRuleService.suggestCategory(userId, "Uncle Tan's Nasi Lemak"))
        .contains(categoryId);

    var rulesResponse = transactionRuleService.list(userId);
    assertThat(rulesResponse).hasSize(1);
    assertThat(rulesResponse.get(0).learned()).isTrue();
    assertThat(rulesResponse.get(0).matchType())
        .isEqualTo(TransactionRuleMatchType.MERCHANT_EQUALS);
  }

  @Test
  void
      confirmingTheSameMerchantAgainWithADifferentCategoryReinforcesTheSameRuleRatherThanDuplicating() {
    TransactionCandidate first =
        candidateService.create(
            userId,
            personalSpaceId,
            CandidateSourceType.RECEIPT_OCR,
            null,
            null,
            new BigDecimal("10.00"),
            "MYR",
            "Test Merchant",
            LocalDate.of(2026, 8, 1),
            TransactionDirection.OUT,
            null,
            new BigDecimal("0.9"));
    candidateService.confirm(
        userId,
        first.getId(),
        new CreateTransactionRequest(
            accountId,
            TransactionType.EXPENSE,
            categoryId,
            new BigDecimal("10.00"),
            "Test Merchant",
            null,
            null,
            LocalDate.of(2026, 8, 1),
            null,
            null,
            null));

    TransactionCandidate second =
        candidateService.create(
            userId,
            personalSpaceId,
            CandidateSourceType.RECEIPT_OCR,
            null,
            null,
            new BigDecimal("12.00"),
            "MYR",
            "Test Merchant",
            LocalDate.of(2026, 8, 5),
            TransactionDirection.OUT,
            null,
            new BigDecimal("0.9"));
    candidateService.confirm(
        userId,
        second.getId(),
        new CreateTransactionRequest(
            accountId,
            TransactionType.EXPENSE,
            otherCategoryId,
            new BigDecimal("12.00"),
            "Test Merchant",
            null,
            null,
            LocalDate.of(2026, 8, 5),
            null,
            null,
            null));

    assertThat(transactionRuleService.list(userId)).hasSize(1);
    assertThat(transactionRuleService.suggestCategory(userId, "Test Merchant"))
        .contains(otherCategoryId);
  }
}
