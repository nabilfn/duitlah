package com.duitlah.api.reconciliation;

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
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMultipartHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

/** Duitlah V2 Phase 7 — session summary and "Resolve Difference". */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ReconciliationSessionFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-reconciliation-test");
    registry.add("duitlah.storage.access-key", () -> "duitlah");
    registry.add("duitlah.storage.secret-key", () -> "duitlah-test-secret");
    registry.add("duitlah.storage.path-style-access", () -> "true");
  }

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String businessAccountId;
  private String sessionId;
  private String importId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("session-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "SessionCo")
            .put("legalName", "SessionCo Sdn Bhd");
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
            .put("openingBalance", "1000.00");
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

    var uploadResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.multipart(
                            "/api/v1/spaces/" + spaceId + "/reconciliation/statement-imports"))
                    .file(
                        new MockMultipartFile(
                            "file",
                            "statement.csv",
                            "text/csv",
                            "Date,Description,Amount\n2026-08-01,Bank Fee,-15.00\n"
                                .getBytes(java.nio.charset.StandardCharsets.UTF_8)))
                    .param("businessAccountId", businessAccountId))
            .andReturn();
    var uploadJson = objectMapper.readTree(uploadResult.getResponse().getContentAsString());
    importId = uploadJson.get("id").asText();
    sessionId = uploadJson.get("reconciliationSessionId").asText();
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

  private MockMultipartHttpServletRequestBuilder as(
      String token, MockMultipartHttpServletRequestBuilder builder) {
    builder.header("Authorization", "Bearer " + token);
    return builder;
  }

  @Test
  void summaryReflectsUnmatchedLinesAndTheCurrentLedgerBalance() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/reconciliation/sessions/"
                        + sessionId
                        + "/summary")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.unmatchedCount").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$.matchedCount").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.ledgerBalance").value(1000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.statementEndingBalance").isEmpty());
  }

  @Test
  void resolvingADifferencePostsAnAdjustmentEntryAndCompletesTheSession() throws Exception {
    // Ledger balance is 1000 (opening) - 0 (the fee line is still unmatched, not yet posted).
    // The bank statement says the account actually ended at 985 (1000 - the 15 fee) -- resolving
    // that 15 gap should post one adjustment entry and complete the session.
    var body =
        objectMapper
            .createObjectNode()
            .put("statementEndingBalance", "985.00")
            .put("description", "Unrecorded bank fee");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/sessions/"
                            + sessionId
                            + "/resolve-difference"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("COMPLETED"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + businessAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(985.00));
  }

  @Test
  void aNonOwnerCannotResolveTheDifference() throws Exception {
    String viewerToken = register("session-viewer@example.com", "Viewer");
    var addBody =
        objectMapper
            .createObjectNode()
            .put("email", "session-viewer@example.com")
            .put("role", "VIEWER");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));

    var body = objectMapper.createObjectNode().put("statementEndingBalance", "985.00");
    mockMvc
        .perform(
            as(
                    viewerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/sessions/"
                            + sessionId
                            + "/resolve-difference"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }
}
