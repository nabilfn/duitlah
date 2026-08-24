package com.duitlah.api.einvoice;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

/**
 * Duitlah V2 Phase 10 — the full e-Invoice workflow (prepare -> submit -> sync -> valid ->
 * cancel/reject), exercised against the deterministic {@link MockEInvoiceProvider} rather than a
 * real LHDN connection.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import({TestcontainersConfiguration.class, MockEInvoiceConfiguration.class})
class EInvoiceWorkflowFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private MockEInvoiceProvider mockProvider;
  @Autowired private EInvoiceDocumentRepository documents;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String invoiceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();
    mockProvider.available = true;
    mockProvider.nextStatus = EInvoiceStatus.VALID;

    ownerToken = register("einv-owner@example.com", "Owner");

    var body =
        objectMapper.createObjectNode().put("name", "EInvCo").put("legalName", "EInvCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var profileBody =
        objectMapper
            .createObjectNode()
            .put("legalName", "EInvCo Sdn Bhd")
            .put("tin", "C1234567890")
            .put("registrationNumber", "202301000999");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.put("/api/v1/spaces/" + spaceId + "/business-profile"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(profileBody.toString()));

    var customer =
        objectMapper.createObjectNode().put("name", "Buyer Sdn Bhd").put("tin", "C9876543210");
    var customerResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/customers"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(customer.toString()))
            .andReturn();
    String customerId =
        objectMapper.readTree(customerResult.getResponse().getContentAsString()).get("id").asText();

    var lineItems =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("description", "Website Development")
                    .put("quantity", "1")
                    .put("unitPrice", "5000.00"));
    var invoiceBody =
        objectMapper
            .createObjectNode()
            .put("customerId", customerId)
            .put("issueDate", "2026-03-01")
            .put("dueDate", "2026-03-31")
            .set("lineItems", lineItems);
    var invoiceResult =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/invoices"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(invoiceBody.toString()))
            .andReturn();
    invoiceId =
        objectMapper.readTree(invoiceResult.getResponse().getContentAsString()).get("id").asText();

    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.patch(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/status"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.createObjectNode().put("status", "SENT").toString()));
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

  private void prepare() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/prepare")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("READY"));
  }

  @Test
  void theFullHappyPathReachesValidAndCanThenBeCancelled() throws Exception {
    prepare();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/submit")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("SUBMITTED"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.submissionUid").isNotEmpty())
        .andExpect(MockMvcResultMatchers.jsonPath("$.documentUuid").isNotEmpty());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/invoices/"
                        + invoiceId
                        + "/einvoice/sync-status")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("VALID"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.longId").isNotEmpty());

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/invoices/"
                            + invoiceId
                            + "/einvoice/cancel"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper
                        .createObjectNode()
                        .put("reason", "Wrong amount, will reissue")
                        .toString()))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("CANCELLED"));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/logs")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(3))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.operation=='SUBMIT')].success").value(true))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.operation=='CANCEL')].success").value(true));
  }

  @Test
  void anInvalidStatusIsPersistedWithItsReason() throws Exception {
    prepare();
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/submit")));

    mockProvider.nextStatus = EInvoiceStatus.INVALID;
    mockProvider.nextInvalidReason = "Buyer TIN does not match LHDN records";
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/"
                        + spaceId
                        + "/invoices/"
                        + invoiceId
                        + "/einvoice/sync-status")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("INVALID"))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.invalidReason")
                .value(org.hamcrest.Matchers.containsString("Buyer TIN")));
  }

  @Test
  void cancellingAfterThe72HourWindowIsRejected() throws Exception {
    prepare();
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/submit")));
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/sync-status")));

    EInvoiceDocument doc =
        documents
            .findByInvoiceIdAndSpaceId(
                java.util.UUID.fromString(invoiceId), java.util.UUID.fromString(spaceId))
            .orElseThrow();
    doc.setValidatedAt(Instant.now().minus(73, ChronoUnit.HOURS));
    documents.save(doc);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/invoices/"
                            + invoiceId
                            + "/einvoice/cancel"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.createObjectNode().put("reason", "Too late").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("EINVOICE_WINDOW_EXPIRED"));
  }

  @Test
  void rejectingBeforeValidationIsRejected() throws Exception {
    prepare();
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/invoices/" + invoiceId + "/einvoice/submit")));

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/invoices/"
                            + invoiceId
                            + "/einvoice/reject"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.createObjectNode().put("reason", "Not our invoice").toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("EINVOICE_NOT_VALID"));
  }
}
