package com.duitlah.api.accounting;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;
import javax.sql.DataSource;
import org.junit.jupiter.api.Assertions;
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
 * Duitlah V2 Phase 6. Every posted entry's debits must equal its credits — enforced twice, at the
 * service level (this class's first two tests) and at the database level (the last test, which
 * bypasses the service entirely via raw JDBC to prove the trigger itself is real).
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class JournalEntryFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private DataSource dataSource;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String spaceId;
  private String cashAccountId;
  private String capitalAccountId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("journal-owner@example.com", "Owner");

    var body =
        objectMapper
            .createObjectNode()
            .put("name", "JournalCo")
            .put("legalName", "JournalCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));
    cashAccountId = accountIdByCode("1000");
    capitalAccountId = accountIdByCode("3000");
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

  private String accountIdByCode(String code) throws Exception {
    var result =
        mockMvc
            .perform(
                as(
                    ownerToken,
                    MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
            .andReturn();
    for (var node : objectMapper.readTree(result.getResponse().getContentAsString())) {
      if (node.get("code").asText().equals(code)) {
        return node.get("id").asText();
      }
    }
    throw new IllegalStateException("No account with code " + code);
  }

  @Test
  void aBalancedManualEntryIsPostedAndListedOnTheGeneralLedger() throws Exception {
    var lines =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", cashAccountId)
                    .put("direction", "DEBIT")
                    .put("amount", "500.00"))
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", capitalAccountId)
                    .put("direction", "CREDIT")
                    .put("amount", "500.00"));
    var body =
        objectMapper
            .createObjectNode()
            .put("entryDate", "2026-08-01")
            .put("description", "Owner capital injection")
            .set("lines", lines);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/accounting/journal-entries"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.lines.length()").value(2));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                        "/api/v1/spaces/" + spaceId + "/accounting/reports/general-ledger")
                    .param("accountId", cashAccountId)
                    .param("from", "2026-08-01")
                    .param("to", "2026-08-31")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.closingBalance").value(500.00));
  }

  @Test
  void anUnbalancedManualEntryIsRejectedByTheService() throws Exception {
    var lines =
        objectMapper
            .createArrayNode()
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", cashAccountId)
                    .put("direction", "DEBIT")
                    .put("amount", "500.00"))
            .add(
                objectMapper
                    .createObjectNode()
                    .put("accountId", capitalAccountId)
                    .put("direction", "CREDIT")
                    .put("amount", "400.00"));
    var body =
        objectMapper
            .createObjectNode()
            .put("entryDate", "2026-08-01")
            .put("description", "Mismatched entry")
            .set("lines", lines);

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/accounting/journal-entries"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("JOURNAL_ENTRY_NOT_BALANCED"));
  }

  @Test
  void theDatabaseItselfRejectsAnUnbalancedEntryEvenIfTheServiceIsBypassed() throws Exception {
    UUID entryId = UUID.randomUUID();
    UUID lineId = UUID.randomUUID();
    UUID ownerId =
        userRepository.findByEmailIgnoreCase("journal-owner@example.com").orElseThrow().getId();

    try (Connection connection = dataSource.getConnection()) {
      connection.setAutoCommit(false);
      try (Statement statement = connection.createStatement()) {
        statement.execute(
            "INSERT INTO journal_entries (id, space_id, entry_date, description, source_type, source_id, created_by_user_id, created_at) VALUES ('"
                + entryId
                + "', '"
                + spaceId
                + "', '2026-08-01', 'Raw bypass attempt', 'MANUAL', NULL, '"
                + ownerId
                + "', now())");
        statement.execute(
            "INSERT INTO journal_lines (id, journal_entry_id, account_id, direction, amount, sort_order) VALUES ('"
                + lineId
                + "', '"
                + entryId
                + "', '"
                + cashAccountId
                + "', 'DEBIT', 100.00, 0)");
      }
      SQLException thrown = Assertions.assertThrows(SQLException.class, connection::commit);
      Assertions.assertTrue(thrown.getMessage().contains("not balanced"));
    }
  }
}
