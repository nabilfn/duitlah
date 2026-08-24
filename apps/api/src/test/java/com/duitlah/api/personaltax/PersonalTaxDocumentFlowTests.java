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

/** Spec section 28 — either a direct upload, or a link to an existing Receipt Vault entry. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class PersonalTaxDocumentFlowTests {

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
    registry.add("duitlah.storage.bucket", () -> "duitlah-tax-docs-test");
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

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "taxdocs@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
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
  void uploadingAnEaFormDirectlyStoresItWithoutRequiringAReceipt() throws Exception {
    var file =
        new MockMultipartFile(
            "file", "ea-2026.pdf", "application/pdf", "not a real pdf".getBytes());
    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.multipart("/api/v1/personal-tax/documents/upload"))
                .file(file)
                .param("yearOfAssessment", "2026")
                .param("type", "EA"))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.type").value("EA"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.hasFile").value(true));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/documents"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));
  }

  @Test
  void linkingAnOwnedReceiptSucceeds() throws Exception {
    var photo =
        new MockMultipartFile(
            "files",
            "receipt.jpg",
            "image/jpeg",
            new byte[] {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00});
    var vaultResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                    .file(photo)
                    .param("purpose", "TAX_EVIDENCE"))
            .andReturn();
    String receiptId = json(vaultResult).get(0).get("id").asText();

    var body =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("type", "MEDICAL_RECEIPT")
            .put("receiptId", receiptId);
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/documents"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.receiptId").value(receiptId));
  }

  @Test
  void linkingAnotherUsersReceiptIsNotFound() throws Exception {
    var other =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "taxdocs-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();
    var photo =
        new MockMultipartFile(
            "files",
            "receipt.jpg",
            "image/jpeg",
            new byte[] {(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, 0x00});
    var vaultResult =
        mockMvc
            .perform(
                as(otherToken, MockMvcRequestBuilders.multipart("/api/v1/receipts/vault"))
                    .file(photo)
                    .param("purpose", "TAX_EVIDENCE"))
            .andReturn();
    String otherReceiptId = json(vaultResult).get(0).get("id").asText();

    var body =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("type", "MEDICAL_RECEIPT")
            .put("receiptId", otherReceiptId);
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/documents"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("RECEIPT_NOT_FOUND"));
  }
}
