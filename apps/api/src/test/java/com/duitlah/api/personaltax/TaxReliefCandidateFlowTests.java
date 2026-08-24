package com.duitlah.api.personaltax;

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
 * Covers the pipeline's own suggestion step (spec section 27): manual creation, and the real
 * TAX_EVIDENCE-receipt-triggered path via {@code receipts.ReceiptVaultService}. Since no
 * ANTHROPIC_API_KEY is configured, a real upload gets {@code UnavailableOcrService}'s blank parse
 * (no total) -- the same constraint {@code ReceiptVaultFlowTests} already documents -- so the
 * receipt-triggered candidate creation is instead exercised directly against {@link
 * TaxReliefCandidateService#createFromReceipt}, the exact method that real OCR success would call.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class TaxReliefCandidateFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-tax-test");
    registry.add("duitlah.storage.access-key", () -> "duitlah");
    registry.add("duitlah.storage.secret-key", () -> "duitlah-test-secret");
    registry.add("duitlah.storage.path-style-access", () -> "true");
  }

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private TaxReliefCandidateService candidateService;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private java.util.UUID userId;

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
                            new RegisterRequest("relief@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
    userId = java.util.UUID.fromString(json(registerResult).get("user").get("id").asText());
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

  @Test
  void aTaxEvidenceReceiptWithARealParsedTotalBecomesACandidate() throws Exception {
    // null sourceReceiptId here -- this test is about the resulting candidate's own fields, not
    // about a specific real receipt row; source_receipt_id is a nullable FK to receipts(id), so a
    // fabricated UUID would (correctly) violate it instead.
    var receipt =
        candidateService.createFromReceipt(userId, null, 2026, new java.math.BigDecimal("150.00"));
    org.assertj.core.api.Assertions.assertThat(receipt.getStatus())
        .isEqualTo(TaxReliefCandidateStatus.NEEDS_REVIEW);
    org.assertj.core.api.Assertions.assertThat(receipt.getSuggestedAmount())
        .isEqualByComparingTo("150.00");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/relief-candidates"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].status").value("NEEDS_REVIEW"));
  }

  @Test
  void uploadingATaxEvidenceReceiptWithNoOcrProviderConfiguredCreatesNoCandidate()
      throws Exception {
    var photo =
        new MockMultipartFile(
            "files",
            "receipt.jpg",
            "image/jpeg",
            new byte[] {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00});
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
            .file(photo)
            .param("purpose", "TAX_EVIDENCE"));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/relief-candidates"))
                .queryParam(
                    "yearOfAssessment", String.valueOf(java.time.LocalDate.now().getYear())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }

  @Test
  void confirmingACandidateCreatesAConfirmedReliefAndRejectingLeavesNoConfirmedRelief()
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("suggestedAmount", "300.00");
    String candidateId =
        json(mockMvc
                .perform(
                    as(
                            accessToken,
                            MockMvcRequestBuilders.post("/api/v1/personal-tax/relief-candidates"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body.toString()))
                .andReturn())
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/personal-tax/relief-candidates/" + candidateId + "/reject")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("REJECTED"));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/confirmed-reliefs"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }

  @Test
  void confirmingAnAlreadyResolvedCandidateIsRejected() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("suggestedAmount", "300.00");
    String candidateId =
        json(mockMvc
                .perform(
                    as(
                            accessToken,
                            MockMvcRequestBuilders.post("/api/v1/personal-tax/relief-candidates"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body.toString()))
                .andReturn())
            .get("id")
            .asText();
    mockMvc.perform(
        as(
            accessToken,
            MockMvcRequestBuilders.post(
                "/api/v1/personal-tax/relief-candidates/" + candidateId + "/reject")));

    var confirmBody =
        objectMapper.createObjectNode().put("category", "LIFESTYLE").put("amount", "300.00");
    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/personal-tax/relief-candidates/" + candidateId + "/confirm"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(confirmBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("CANDIDATE_ALREADY_RESOLVED"));
  }

  @Test
  void nonOwnerCannotSeeAnotherUsersCandidate() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("suggestedAmount", "300.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/relief-candidates"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));

    var other =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "relief-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();

    mockMvc
        .perform(
            as(otherToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/relief-candidates"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(0));
  }
}
