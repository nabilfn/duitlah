package com.duitlah.api.receipts;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
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
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMultipartHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

/**
 * V2 Phase 13 -- "receipt automation" ({@link ReceiptVaultService#suggestTransactionMatches}) and
 * the "Smart Capture improvement" {@code needsReview} flag. No ANTHROPIC_API_KEY is configured in
 * tests, so OCR always fails (see {@code ReceiptVaultFlowTests}) -- the match-suggestion tests
 * write {@code totalAmount}/{@code receiptDate} directly via {@link ReceiptRepository} to simulate
 * a successful parse, the same "exercise the real logic, bypass only the unavailable external
 * provider" technique used elsewhere in this codebase's tests.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ReceiptAutomationFlowTests {

  private static final GenericContainer<?> MINIO =
      new GenericContainer<>(DockerImageName.parse("minio/minio:latest"))
          .withExposedPorts(9000)
          .withEnv("MINIO_ROOT_USER", "duitlah")
          .withEnv("MINIO_ROOT_PASSWORD", "duitlah-test-secret")
          .withCommand("server", "/data")
          .waitingFor(Wait.forHttp("/minio/health/live").forPort(9000));

  static {
    MINIO.start();
  }

  @DynamicPropertySource
  static void storageProperties(DynamicPropertyRegistry registry) {
    registry.add(
        "duitlah.storage.endpoint",
        () -> "http://" + MINIO.getHost() + ":" + MINIO.getMappedPort(9000));
    registry.add(
        "duitlah.storage.public-endpoint",
        () -> "http://" + MINIO.getHost() + ":" + MINIO.getMappedPort(9000));
    registry.add("duitlah.storage.bucket", () -> "duitlah-vault-automation-test");
    registry.add("duitlah.storage.access-key", () -> "duitlah");
    registry.add("duitlah.storage.secret-key", () -> "duitlah-test-secret");
    registry.add("duitlah.storage.path-style-access", () -> "true");
  }

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private ReceiptRepository receiptRepository;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String accountId;

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
                            new RegisterRequest(
                                "receipt-automation@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(result).get("accessToken").asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "E_WALLET")
            .put("currency", "MYR");
    accountId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(accountBody.toString()))
                .andReturn())
            .get("id")
            .asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private MockMultipartHttpServletRequestBuilder as(
      String token, MockMultipartHttpServletRequestBuilder builder) {
    builder.header("Authorization", "Bearer " + token);
    return builder;
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private MockMultipartFile receiptPhoto() {
    return new MockMultipartFile(
        "files",
        "receipt.jpg",
        "image/jpeg",
        new byte[] {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00});
  }

  private String uploadReceiptAndSimulateParse(BigDecimal totalAmount, LocalDate receiptDate)
      throws Exception {
    String receiptId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                        .file(receiptPhoto())
                        .param("purpose", "PERSONAL_EXPENSE"))
                .andReturn())
            .get(0)
            .get("id")
            .asText();
    Receipt receipt = receiptRepository.findById(UUID.fromString(receiptId)).orElseThrow();
    receipt.setTotalAmount(totalAmount);
    receipt.setReceiptDate(receiptDate);
    receipt.setOcrStatus(VaultOcrStatus.PARSED);
    receiptRepository.save(receipt);
    return receiptId;
  }

  private String createTransaction(String amount, String occurredOn) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", amount)
            .put("occurredOn", occurredOn);
    return json(mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn())
        .get("id")
        .asText();
  }

  @Test
  void suggestsAnExactMatchAheadOfAProbableOneAndExcludesUnrelatedTransactions() throws Exception {
    String exactTransactionId = createTransaction("42.50", "2026-08-10");
    createTransaction("42.50", "2026-08-13"); // probable: same amount, within date window
    createTransaction("99.00", "2026-08-10"); // no match: different amount, no tolerance
    // Income (not OUT) at the exact amount/date must never be suggested as an expense match.
    var incomeBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "INCOME")
            .put("amount", "42.50")
            .put("occurredOn", "2026-08-10");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(incomeBody.toString()));

    String receiptId =
        uploadReceiptAndSimulateParse(new BigDecimal("42.50"), LocalDate.of(2026, 8, 10));

    var result =
        mockMvc
            .perform(
                as(
                    accessToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/receipts/vault/" + receiptId + "/match-suggestions")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();
    JsonNode suggestions = json(result);
    assertThat(suggestions).hasSize(2);
    assertThat(suggestions.get(0).get("transactionId").asText()).isEqualTo(exactTransactionId);
    assertThat(suggestions.get(0).get("confidence").asText()).isEqualTo("EXACT");
    assertThat(suggestions.get(1).get("confidence").asText()).isEqualTo("PROBABLE");
  }

  @Test
  void aReceiptWithNoAmountOrDateSuggestsNothing() throws Exception {
    String receiptId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                        .file(receiptPhoto())
                        .param("purpose", "PERSONAL_EXPENSE"))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/receipts/vault/" + receiptId + "/match-suggestions")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }

  @Test
  void attachingAReceiptToAPersonalBillWiresUpTheDeadReceiptIdField() throws Exception {
    var billBody =
        objectMapper
            .createObjectNode()
            .put("name", "Electricity")
            .put("dueDate", "2026-09-01")
            .put("expectedAmount", "120.00");
    String billId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-bills"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(billBody.toString()))
                .andReturn())
            .get("id")
            .asText();

    String receiptId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                        .file(receiptPhoto())
                        .param("purpose", "PERSONAL_EXPENSE"))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post("/api/v1/personal-bills/" + billId + "/receipt"))
                .param("receiptId", receiptId))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.receiptId").value(receiptId));
  }

  @Test
  void attachingAnotherUsersReceiptToABillIsRejected() throws Exception {
    var billBody =
        objectMapper
            .createObjectNode()
            .put("name", "Electricity")
            .put("dueDate", "2026-09-01")
            .put("expectedAmount", "120.00");
    String billId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-bills"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(billBody.toString()))
                .andReturn())
            .get("id")
            .asText();

    var otherResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "receipt-automation-other@example.com",
                                "correct-horse-1",
                                "Ameer"))))
            .andReturn();
    String otherToken = json(otherResult).get("accessToken").asText();
    String otherReceiptId =
        json(mockMvc
                .perform(
                    as(otherToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                        .file(receiptPhoto())
                        .param("purpose", "PERSONAL_EXPENSE"))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post("/api/v1/personal-bills/" + billId + "/receipt"))
                .param("receiptId", otherReceiptId))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  @Test
  void needsReviewIsFalseWhenOcrHasNoConfidenceSignalAtAll() throws Exception {
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                    .file(receiptPhoto())
                    .param("purpose", "PERSONAL_EXPENSE"))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    assertThat(json(result).get(0).get("needsReview").asBoolean()).isFalse();
  }
}
