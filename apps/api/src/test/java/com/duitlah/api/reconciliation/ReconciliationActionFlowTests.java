package com.duitlah.api.reconciliation;

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
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMultipartHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

/**
 * Duitlah V2 Phase 7 — the matching engine and the four line-level actions (Match, Create
 * Transaction, Ignore, Split).
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ReconciliationActionFlowTests {

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

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("action-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "ActionCo")
            .put("legalName", "ActionCo Sdn Bhd");
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

  private MockMultipartHttpServletRequestBuilder as(
      String token, MockMultipartHttpServletRequestBuilder builder) {
    builder.header("Authorization", "Bearer " + token);
    return builder;
  }

  private MockMultipartFile csv(String content) {
    return new MockMultipartFile(
        "file",
        "statement.csv",
        "text/csv",
        content.getBytes(java.nio.charset.StandardCharsets.UTF_8));
  }

  private void addLedgerEntry(
      String direction, String amount, String occurredOn, String description) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("direction", direction)
            .put("amount", amount)
            .put("occurredOn", occurredOn)
            .put("description", description);
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/business-accounts/"
                        + businessAccountId
                        + "/entries"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));
  }

  private String uploadStatement(String csvContent) throws Exception {
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.multipart(
                            "/api/v1/spaces/" + spaceId + "/reconciliation/statement-imports"))
                    .file(csv(csvContent))
                    .param("businessAccountId", businessAccountId))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private JsonNode getLines(String importId) throws Exception {
    var result =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/statement-imports/"
                            + importId
                            + "/lines")))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void anExactMatchIsSuggestedAndConfirmingItMarksTheLineMatched() throws Exception {
    addLedgerEntry("OUT", "800.00", "2026-08-01", "Rent");
    String importId = uploadStatement("Date,Description,Amount\n2026-08-01,Rent Payment,-800.00\n");
    String lineId = getLines(importId).get(0).get("id").asText();

    var suggestions =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/statement-imports/"
                            + importId
                            + "/lines/"
                            + lineId
                            + "/suggestions")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
            .andExpect(MockMvcResultMatchers.jsonPath("$[0].confidence").value("EXACT"))
            .andReturn();
    String entryId =
        objectMapper
            .readTree(suggestions.getResponse().getContentAsString())
            .get(0)
            .get("businessAccountEntryId")
            .asText();

    var matchBody = objectMapper.createObjectNode().put("businessAccountEntryId", entryId);
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/statement-imports/"
                            + importId
                            + "/lines/"
                            + lineId
                            + "/match"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(matchBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("MATCHED"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/reconciliation/statement-imports/"
                        + importId
                        + "/lines/"
                        + lineId
                        + "/ignore")))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.code").value("STATEMENT_LINE_ALREADY_RESOLVED"));
  }

  @Test
  void createTransactionPostsARealLedgerEntryForAnUnmatchedLine() throws Exception {
    String importId = uploadStatement("Date,Description,Amount\n2026-08-05,Bank Interest,25.00\n");
    String lineId = getLines(importId).get(0).get("id").asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/reconciliation/statement-imports/"
                        + importId
                        + "/lines/"
                        + lineId
                        + "/create-transaction")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("CREATED"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + businessAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(25.00));
  }

  @Test
  void ignoringALineLeavesTheLedgerUntouched() throws Exception {
    String importId =
        uploadStatement("Date,Description,Amount\n2026-08-06,Bank Marketing Note,5.00\n");
    String lineId = getLines(importId).get(0).get("id").asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/reconciliation/statement-imports/"
                        + importId
                        + "/lines/"
                        + lineId
                        + "/ignore")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("IGNORED"));
  }

  @Test
  void splittingALineCreatesMultipleLedgerEntriesSummingToTheOriginalAmount() throws Exception {
    String importId =
        uploadStatement("Date,Description,Amount\n2026-08-07,Bulk Transfer,-300.00\n");
    String lineId = getLines(importId).get(0).get("id").asText();

    var portions =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Office supplies")
                    .put("amount", "100.00"))
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Utilities")
                    .put("amount", "200.00"));
    var splitBody = objectMapper.createObjectNode().set("portions", portions);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/statement-imports/"
                            + importId
                            + "/lines/"
                            + lineId
                            + "/split"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(splitBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("SPLIT"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + businessAccountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(-300.00));
  }

  @Test
  void splitPortionsThatDoNotSumToTheLineAmountAreRejected() throws Exception {
    String importId =
        uploadStatement("Date,Description,Amount\n2026-08-08,Bulk Transfer,-300.00\n");
    String lineId = getLines(importId).get(0).get("id").asText();

    var portions =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Partial one")
                    .put("amount", "100.00"))
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Partial two")
                    .put("amount", "150.00"));
    var splitBody = objectMapper.createObjectNode().set("portions", portions);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/reconciliation/statement-imports/"
                            + importId
                            + "/lines/"
                            + lineId
                            + "/split"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(splitBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.code")
                .value("SPLIT_PORTIONS_DO_NOT_SUM_TO_LINE_AMOUNT"));
  }
}
