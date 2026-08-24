package com.duitlah.api.receipts;

import static org.assertj.core.api.Assertions.assertThat;

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
 * Runs against a real MinIO container (not a mocked ObjectStorage) so presigned-URL generation and
 * put/get actually get exercised against an S3-compatible backend, matching this project's usual
 * "test against real dependencies" stance. Wired here rather than in the shared {@link
 * TestcontainersConfiguration} because {@code @DynamicPropertySource} is only honored on the test
 * class itself, not on an {@code @Import}-ed configuration class — and only this test class
 * actually needs a live MinIO; {@code S3ObjectStorage} tolerates being unreachable everywhere else
 * (see its Javadoc). OCR is a different story: there's no way to test a real Claude API call
 * without a real key and real network access in CI, so these tests rely on the natural no-API-key
 * fallback (UnavailableOcrService) that's already active whenever ANTHROPIC_API_KEY isn't set — the
 * same posture as LoggingEmailSender standing in for real SMTP.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ReceiptScanFlowTests {

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
    // No internal-vs-public split needed here (unlike docker-compose.yml): the test JVM and the
    // container's mapped port are on the same host network either way.
    registry.add(
        "duitlah.storage.endpoint",
        () -> "http://" + MINIO.getHost() + ":" + MINIO.getMappedPort(9000));
    registry.add(
        "duitlah.storage.public-endpoint",
        () -> "http://" + MINIO.getHost() + ":" + MINIO.getMappedPort(9000));
    registry.add("duitlah.storage.bucket", () -> "duitlah-receipts-test");
    registry.add("duitlah.storage.access-key", () -> "duitlah");
    registry.add("duitlah.storage.secret-key", () -> "duitlah-test-secret");
    registry.add("duitlah.storage.path-style-access", () -> "true");
  }

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String ownerToken;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var owner = registerAndReturn("nabil@example.com", "Nabil");
    ownerToken = owner.get("accessToken").asText();
  }

  private JsonNode registerAndReturn(String email, String name) throws Exception {
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(email, "correct-horse-1", name))))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private MockMultipartHttpServletRequestBuilder as(
      String token, MockMultipartHttpServletRequestBuilder builder) {
    builder.header("Authorization", "Bearer " + token);
    return builder;
  }

  private JsonNode json(org.springframework.test.web.servlet.MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private MockMultipartFile receiptPhoto() {
    // Real JPEG magic bytes (FF D8 FF) -- Phase 14 added a content-signature check alongside the
    // declared Content-Type, so a fake placeholder byte array would now be rejected as a mismatch.
    return new MockMultipartFile(
        "image",
        "receipt.jpg",
        "image/jpeg",
        new byte[] {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00});
  }

  @Test
  void uploadingWithNoOcrProviderConfiguredReturnsABlankParseReadyForManualEntry()
      throws Exception {
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                    .file(receiptPhoto()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("FAILED"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.parsedReceipt.merchant").doesNotExist())
            .andExpect(MockMvcResultMatchers.jsonPath("$.imageUrl").isNotEmpty())
            .andReturn();

    // A real presigned S3 URL, not a placeholder — actually signed against MinIO.
    String imageUrl = json(result).get("imageUrl").asText();
    assertThat(imageUrl).contains("X-Amz-Signature");
  }

  @Test
  void unsupportedFileTypeIsRejected() throws Exception {
    var textFile =
        new MockMultipartFile("image", "receipt.txt", "text/plain", "not an image".getBytes());
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                .file(textFile))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("UNSUPPORTED_IMAGE_TYPE"));
  }

  @Test
  void fileWhoseBytesDontMatchItsDeclaredContentTypeIsRejected() throws Exception {
    // A plain-text payload dressed up with an "image/jpeg" label -- the declared Content-Type
    // alone must never be trusted; the actual bytes are checked against JPEG's real magic number.
    var spoofed =
        new MockMultipartFile(
            "image", "receipt.jpg", "image/jpeg", "this is not a real jpeg".getBytes());
    mockMvc
        .perform(
            as(ownerToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                .file(spoofed))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("IMAGE_CONTENT_MISMATCH"));
  }

  @Test
  void confirmingAScanCreatesARealOrdinaryBillWithTheUsersCorrectedValues() throws Exception {
    var uploadResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                    .file(receiptPhoto()))
            .andReturn();
    String scanId = json(uploadResult).get("id").asText();

    var confirmBody =
        objectMapper
            .createObjectNode()
            .put("merchant", "Mamak Corner")
            .put("receiptDate", "2026-08-21")
            .put("tax", "1.00")
            .put("taxStrategy", "PROPORTIONAL")
            .put("serviceCharge", "0.00")
            .put("serviceStrategy", "PROPORTIONAL")
            .put("discount", "0.00");
    var items = confirmBody.putArray("items");
    items.addObject().put("name", "Nasi Goreng").put("quantity", "1").put("unitPrice", "16.00");

    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/receipts/scans/" + scanId + "/confirm"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(confirmBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.jsonPath("$.merchant").value("Mamak Corner"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("DRAFT"))
            .andReturn();
    String billId = json(result).get("id").asText();

    // It's a completely ordinary bill from here -- items really landed in receipt_items.
    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/bills/" + billId + "/items")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].name").value("Nasi Goreng"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].totalPrice").value(16.00));

    // And the scan itself is now marked confirmed and linked to that bill.
    mockMvc
        .perform(as(ownerToken, MockMvcRequestBuilders.get("/api/v1/receipts/scans/" + scanId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("CONFIRMED"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.billId").value(billId));
  }

  @Test
  void confirmingTheSameScanTwiceIsRejected() throws Exception {
    var uploadResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                    .file(receiptPhoto()))
            .andReturn();
    String scanId = json(uploadResult).get("id").asText();

    var confirmBody =
        objectMapper
            .createObjectNode()
            .put("merchant", "Mamak Corner")
            .put("receiptDate", "2026-08-21")
            .put("tax", "0.00")
            .put("taxStrategy", "PROPORTIONAL")
            .put("serviceCharge", "0.00")
            .put("serviceStrategy", "PROPORTIONAL")
            .put("discount", "0.00");
    confirmBody.putArray("items");

    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/receipts/scans/" + scanId + "/confirm"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(confirmBody.toString()));

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post("/api/v1/receipts/scans/" + scanId + "/confirm"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(confirmBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("SCAN_ALREADY_CONFIRMED"));
  }

  @Test
  void nonOwnerCannotSeeAnotherUsersScan() throws Exception {
    var uploadResult =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                    .file(receiptPhoto()))
            .andReturn();
    String scanId = json(uploadResult).get("id").asText();

    var other = registerAndReturn("ameer@example.com", "Ameer");
    String otherToken = other.get("accessToken").asText();

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/receipts/scans/" + scanId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
