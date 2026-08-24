package com.duitlah.api.subscriptions;

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

/**
 * A real MinIO container is needed here (not just Testcontainers' shared Postgres/Redis) because
 * exercising the receipt-scan monthly limit requires actually calling {@code
 * ReceiptScanService.upload}, which writes through {@code ObjectStorage} -- same setup as {@code
 * receipts.ReceiptScanFlowTests}, for the same reason (see that class's Javadoc).
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class SubscriptionFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-subscriptions-test");
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
                            new RegisterRequest("subs@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
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

  private String createGroup(String name) throws Exception {
    var body = objectMapper.createObjectNode().put("name", name).put("type", "GENERAL");
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void freeUserWithNoSubscriptionRowGetsDefaultLimits() throws Exception {
    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/subscriptions/me")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.tier").value("FREE"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").doesNotExist())
        .andExpect(MockMvcResultMatchers.jsonPath("$.maxActiveGroups").value(3))
        .andExpect(MockMvcResultMatchers.jsonPath("$.maxReceiptScansPerMonth").value(5));
  }

  @Test
  void freeUserCannotOwnMoreThanThreeActiveGroups() throws Exception {
    createGroup("One");
    createGroup("Two");
    createGroup("Three");

    var body = objectMapper.createObjectNode().put("name", "Four").put("type", "GENERAL");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("GROUP_LIMIT_REACHED"));
  }

  @Test
  void archivingAGroupFreesUpAFreeUsersQuota() throws Exception {
    createGroup("One");
    createGroup("Two");
    String thirdId = createGroup("Three");

    var archiveBody =
        objectMapper
            .createObjectNode()
            .put("name", "Three")
            .put("type", "GENERAL")
            .put("archived", true);
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.patch("/api/v1/groups/" + thirdId))
                .contentType(MediaType.APPLICATION_JSON)
                .content(archiveBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    // Now only 2 active groups -- a 4th (real, distinct) group should be allowed.
    var body = objectMapper.createObjectNode().put("name", "Four").put("type", "GENERAL");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/groups"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }

  @Test
  void freeUserCannotScanMoreThanFiveReceiptsPerMonth() throws Exception {
    // Real JPEG magic bytes (FF D8 FF) -- Phase 14 added a content-signature check alongside the
    // declared Content-Type, so a fake placeholder byte array would now be rejected as a mismatch.
    MockMultipartFile photo =
        new MockMultipartFile(
            "image",
            "receipt.jpg",
            "image/jpeg",
            new byte[] {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00});
    for (int i = 0; i < 5; i++) {
      mockMvc
          .perform(
              as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans"))
                  .file(photo))
          .andExpect(MockMvcResultMatchers.status().isCreated());
    }

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/scans")).file(photo))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("RECEIPT_SCAN_LIMIT_REACHED"));
  }

  @Test
  void purchaseVerificationFailsHonestlyWithNoRealProviderConfigured() throws Exception {
    var body =
        objectMapper.createObjectNode().put("source", "APPLE").put("receiptData", "fake-receipt");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/subscriptions/verify"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("PURCHASE_VERIFICATION_FAILED"));
  }
}
