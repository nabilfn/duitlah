package com.duitlah.api.receipts;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
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
 * The Receipt Vault (spec section 15), independent of Bagilah's own scan-and-confirm flow. Like
 * {@code ReceiptScanFlowTests}, OCR-success behavior (a vault upload auto-creating an AutoTrack
 * candidate once a real amount is read) can't be exercised without a real ANTHROPIC_API_KEY in CI —
 * these tests cover the same natural no-API-key fallback path Bagilah's own scan tests do; the
 * receipt-to-candidate wiring itself is exercised directly in {@code AutoTrackFlowTests} via {@code
 * TransactionCandidateService.create}, the exact method this path would call.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ReceiptVaultFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-vault-test");
    registry.add("duitlah.storage.access-key", () -> "duitlah");
    registry.add("duitlah.storage.secret-key", () -> "duitlah-test-secret");
    registry.add("duitlah.storage.path-style-access", () -> "true");
  }

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;

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
                            new RegisterRequest("vault@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(result).get("accessToken").asText();
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

  @Test
  void uploadingWithNoOcrProviderConfiguredStillStoresTheReceiptWithFolderAndTags()
      throws Exception {
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                    .file(receiptPhoto())
                    .param("purpose", "PERSONAL_EXPENSE")
                    .param("folder", "Groceries")
                    .param("tags", "urgent", "review"))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].ocrStatus").value("FAILED"))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].folder").value("Groceries"))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].tags.length()").value(2))
            .andReturn();

    String receiptId = json(result).get(0).get("id").asText();
    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/receipts/vault/" + receiptId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.purpose").value("PERSONAL_EXPENSE"));
  }

  @Test
  void unsupportedFileTypeIsRejected() throws Exception {
    var textFile = new MockMultipartFile("files", "notes.txt", "text/plain", "hello".getBytes());
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                .file(textFile)
                .param("purpose", "TAX_EVIDENCE"))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("UNSUPPORTED_IMAGE_TYPE"));
  }

  @Test
  void searchingByFolderReturnsOnlyMatchingReceipts() throws Exception {
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
            .file(receiptPhoto())
            .param("purpose", "BUSINESS_EXPENSE")
            .param("folder", "Office Supplies"));
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
            .file(receiptPhoto())
            .param("purpose", "PERSONAL_EXPENSE")
            .param("folder", "Groceries"));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/receipts/vault"))
                .param("folder", "Groceries"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].folder").value("Groceries"));
  }

  @Test
  void attachingAReceiptToAnExistingTransactionLinksIt() throws Exception {
    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "E_WALLET")
            .put("currency", "MYR");
    String accountId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(accountBody.toString()))
                .andReturn())
            .get("id")
            .asText();
    var transactionBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "25.00")
            .put("occurredOn", "2026-08-20");
    String transactionId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(transactionBody.toString()))
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
                    MockMvcRequestBuilders.post("/api/v1/receipts/vault/" + receiptId + "/attach"))
                .param("transactionId", transactionId))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.linkedTransactionId").value(transactionId));
  }

  @Test
  void nonOwnerCannotSeeAnotherUsersReceipt() throws Exception {
    String receiptId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                        .file(receiptPhoto())
                        .param("purpose", "UNSPECIFIED"))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    var other =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "vault-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/receipts/vault/" + receiptId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
