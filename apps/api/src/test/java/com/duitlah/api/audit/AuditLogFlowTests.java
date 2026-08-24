package com.duitlah.api.audit;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.UUID;
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
 * Reads {@link AuditLogRepository} directly rather than through a REST endpoint -- product spec
 * section 50 asks that these actions be recorded, not that there's an admin UI to browse them yet
 * (no such endpoint exists), so a direct repository check is the honest way to verify the actual
 * requirement.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AuditLogFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private AuditLogRepository auditLogRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private UUID userId;

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
                            new RegisterRequest("audit@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    var body = objectMapper.readTree(result.getResponse().getContentAsString());
    accessToken = body.get("accessToken").asText();
    userId = UUID.fromString(body.get("user").get("id").asText());
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  @Test
  void creatingATransactionWritesAnAuditLog() throws Exception {
    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    var accountResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    String accountId =
        objectMapper.readTree(accountResult.getResponse().getContentAsString()).get("id").asText();

    var txBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "20.00")
            .put("occurredOn", "2026-08-01");
    var txResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(txBody.toString()))
            .andReturn();
    UUID transactionId =
        UUID.fromString(
            objectMapper.readTree(txResult.getResponse().getContentAsString()).get("id").asText());

    var log =
        auditLogRepository
            .findByEntityTypeAndEntityIdOrderByCreatedAtDesc("Transaction", transactionId)
            .stream()
            .findFirst()
            .orElseThrow();
    assertThat(log.getAction()).isEqualTo(AuditAction.TRANSACTION_CREATED);
    assertThat(log.getActorUserId()).isEqualTo(userId);
    assertThat(log.getMetadata()).contains("20.00");
  }

  @Test
  void changingPasswordWritesASecuritySettingsAuditLog() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("currentPassword", "correct-horse-1")
            .put("newPassword", "new-horse-battery-2");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/users/me/change-password"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    var logs = auditLogRepository.findByActorUserIdOrderByCreatedAtDesc(userId);
    assertThat(logs).anyMatch(l -> l.getAction() == AuditAction.SECURITY_SETTINGS_CHANGED);
  }

  @Test
  void updatingProfileWritesAnAccountInfoAuditLog() throws Exception {
    var body = objectMapper.createObjectNode().put("displayName", "New Name");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.patch("/api/v1/users/me"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isOk());

    var logs = auditLogRepository.findByActorUserIdOrderByCreatedAtDesc(userId);
    assertThat(logs).anyMatch(l -> l.getAction() == AuditAction.ACCOUNT_INFO_CHANGED);
  }
}
