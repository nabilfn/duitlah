package com.duitlah.api.autotrack;

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
 * End-to-end AutoTrack pipeline (spec sections 10-13): a generic-CSV statement upload produces real
 * {@link TransactionCandidate} rows, which a human then confirms, rejects, or resolves as a
 * duplicate. Runs against a real MinIO container the same way {@code ReceiptScanFlowTests} does,
 * since statement uploads go through {@code common.storage.ObjectStorage} too.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AutoTrackFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-autotrack-test");
    registry.add("duitlah.storage.access-key", () -> "duitlah");
    registry.add("duitlah.storage.secret-key", () -> "duitlah-test-secret");
    registry.add("duitlah.storage.path-style-access", () -> "true");
  }

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String accountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "autotrack@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Maybank")
            .put("type", "BANK")
            .put("currency", "MYR");
    var accountResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId = json(accountResult).get("id").asText();
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

  private MockMultipartFile csv(String content) {
    return new MockMultipartFile(
        "file",
        "statement.csv",
        "text/csv",
        content.getBytes(java.nio.charset.StandardCharsets.UTF_8));
  }

  @Test
  void uploadingAGenericCsvStatementCreatesOnePendingCandidatePerRow() throws Exception {
    String csvContent =
        "Date,Description,Amount\n"
            + "2026-08-20,ZUS Coffee,-18.90\n"
            + "2026-08-21,Salary,3500.00\n";

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/statement-imports"))
                .file(csv(csvContent))
                .param("accountId", accountId))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PARSED"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.rowCount").value(2));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/autotrack/candidates"))
                .param("status", "PENDING"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].detectedMerchant").value("Salary"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].detectedDirection").value("IN"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[1].detectedMerchant").value("ZUS Coffee"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[1].detectedDirection").value("OUT"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[1].detectedAmount").value(18.90));
  }

  @Test
  void confirmingACandidateCreatesARealTransactionAndMarksItConfirmed() throws Exception {
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/statement-imports"))
            .file(csv("Date,Description,Amount\n2026-08-20,ZUS Coffee,-18.90\n"))
            .param("accountId", accountId));

    var candidatesResult =
        mockMvc
            .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/autotrack/candidates")))
            .andReturn();
    String candidateId = json(candidatesResult).get(0).get("id").asText();

    var confirmBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "18.90")
            .put("merchant", "ZUS Coffee")
            .put("occurredOn", "2026-08-20");

    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/autotrack/candidates/" + candidateId + "/confirm"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(confirmBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.merchant").value("ZUS Coffee"));

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get("/api/v1/autotrack/candidates/" + candidateId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("CONFIRMED"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.resultingTransactionId").isNotEmpty());
  }

  @Test
  void rejectingAPendingCandidateMarksItRejectedAndConfirmingItAgainFails() throws Exception {
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/statement-imports"))
            .file(csv("Date,Description,Amount\n2026-08-20,ZUS Coffee,-18.90\n"))
            .param("accountId", accountId));
    String candidateId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.get("/api/v1/autotrack/candidates")))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/autotrack/candidates/" + candidateId + "/reject")))
        .andExpect(MockMvcResultMatchers.status().isOk());

    var confirmBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "18.90")
            .put("occurredOn", "2026-08-20");
    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/autotrack/candidates/" + candidateId + "/confirm"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(confirmBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("CANDIDATE_ALREADY_RESOLVED"));
  }

  @Test
  void aStatementRowMatchingAnExistingTransactionIsFlaggedAsAPossibleDuplicateAndCanBeMerged()
      throws Exception {
    var transactionBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "18.90")
            .put("merchant", "ZUS Coffee")
            .put("occurredOn", "2026-08-20");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(transactionBody.toString()));

    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/statement-imports"))
            .file(csv("Date,Description,Amount\n2026-08-20,ZUS Coffee,-18.90\n"))
            .param("accountId", accountId));

    var candidate =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.get("/api/v1/autotrack/candidates")))
                .andReturn())
            .get(0);
    org.assertj.core.api.Assertions.assertThat(candidate.get("duplicateOfTransactionId").isNull())
        .isFalse();
    String candidateId = candidate.get("id").asText();

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/autotrack/candidates/" + candidateId + "/merge")))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.get("/api/v1/autotrack/candidates/" + candidateId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DUPLICATE"));
  }

  @Test
  void unsupportedStatementFileTypeIsRejected() throws Exception {
    var textFile = new MockMultipartFile("file", "notes.txt", "text/plain", "hello".getBytes());
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/statement-imports"))
                .file(textFile)
                .param("accountId", accountId))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("UNSUPPORTED_FILE_TYPE"));
  }

  @Test
  void nonOwnerCannotSeeAnotherUsersCandidate() throws Exception {
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/statement-imports"))
            .file(csv("Date,Description,Amount\n2026-08-20,ZUS Coffee,-18.90\n"))
            .param("accountId", accountId));
    String candidateId =
        json(mockMvc
                .perform(
                    as(accessToken, MockMvcRequestBuilders.get("/api/v1/autotrack/candidates")))
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
                                "autotrack-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();

    mockMvc
        .perform(
            as(
                otherToken,
                MockMvcRequestBuilders.get("/api/v1/autotrack/candidates/" + candidateId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
