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
 * V2 Phase 13 -- "intelligent reconciliation": a single explicit action that auto-applies every
 * unambiguous EXACT suggestion across an import, leaving anything ambiguous (more than one EXACT
 * candidate) or unmatched for a human, per {@link ReconciliationActionService#autoMatchExact}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ReconciliationAutoMatchFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-automatch-test");
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

    ownerToken = register("automatch-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "AutoMatchCo")
            .put("legalName", "AutoMatchCo Sdn Bhd");
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
  void autoMatchAppliesOnlyUnambiguousExactSuggestionsAndSkipsTheRest() throws Exception {
    // Line A: exactly one matching ledger entry -- auto-matched.
    addLedgerEntry("OUT", "800.00", "2026-08-01", "Rent");
    // Line B: two ledger entries at the same amount+date -- genuinely ambiguous, skipped.
    addLedgerEntry("OUT", "500.00", "2026-08-02", "Utility A");
    addLedgerEntry("OUT", "500.00", "2026-08-02", "Utility B");
    // Line C: no matching ledger entry at all -- skipped.

    String importId =
        uploadStatement(
            "Date,Description,Amount\n"
                + "2026-08-01,Rent Payment,-800.00\n"
                + "2026-08-02,Utility Payment,-500.00\n"
                + "2026-08-03,Unmatched Payment,-300.00\n");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/reconciliation/statement-imports/"
                        + importId
                        + "/auto-match")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.matchedCount").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$.skippedCount").value(2));

    JsonNode lines = getLines(importId);
    for (JsonNode line : lines) {
      String description = line.get("description").asText();
      if (description.equals("Rent Payment")) {
        org.assertj.core.api.Assertions.assertThat(line.get("status").asText())
            .isEqualTo("MATCHED");
      } else {
        org.assertj.core.api.Assertions.assertThat(line.get("status").asText())
            .isEqualTo("UNMATCHED");
      }
    }
  }

  @Test
  void autoMatchingAgainAfterFirstRunFindsNothingLeftToMatch() throws Exception {
    addLedgerEntry("OUT", "800.00", "2026-08-01", "Rent");
    String importId = uploadStatement("Date,Description,Amount\n2026-08-01,Rent Payment,-800.00\n");

    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/"
                    + spaceId
                    + "/reconciliation/statement-imports/"
                    + importId
                    + "/auto-match")));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/reconciliation/statement-imports/"
                        + importId
                        + "/auto-match")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.matchedCount").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.skippedCount").value(0));
  }
}
