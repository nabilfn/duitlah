package com.duitlah.api.ai;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.Map;
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

/**
 * V2 Phase 12 -- direct dispatch coverage for the tools {@link PersonalAiToolProvider}, {@link
 * BusinessAiToolProvider}, and {@link SharedAiToolProvider} added on top of V1's original 9 (still
 * covered separately by {@link AiFlowTests}). No ANTHROPIC_API_KEY is configured in tests, so
 * {@code execute(...)} is called directly against the real, Spring-managed provider beans -- the
 * same "never mock what the real service can answer" posture the rest of this codebase's tests use,
 * just entered through the provider instead of through a live Claude tool-use loop.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AiToolProviderFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private PersonalAiToolProvider personalAiToolProvider;
  @Autowired private BusinessAiToolProvider businessAiToolProvider;
  @Autowired private SharedAiToolProvider sharedAiToolProvider;

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
                            new RegisterRequest(
                                "ai-tools@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    JsonNode registerResponse = objectMapper.readTree(result.getResponse().getContentAsString());
    accessToken = registerResponse.get("accessToken").asText();
    userId = UUID.fromString(registerResponse.get("user").get("id").asText());
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private UUID createBusinessSpace() throws Exception {
    var body =
        objectMapper.createObjectNode().put("name", "Tool Co").put("legalName", "Tool Co Sdn Bhd");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return UUID.fromString(
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText());
  }

  @Test
  void personalToolsAddedInV2DispatchCorrectlyForAFreshUser() {
    assertThat(personalAiToolProvider.execute(userId, null, "get_net_worth", null)).isNotNull();
    assertThat((List<?>) personalAiToolProvider.execute(userId, null, "get_loans", null)).isEmpty();
    assertThat((List<?>) personalAiToolProvider.execute(userId, null, "get_bills", null)).isEmpty();

    JsonNode yearInput = objectMapper.createObjectNode().put("yearOfAssessment", 2026);
    assertThat(personalAiToolProvider.execute(userId, null, "get_tax_summary", yearInput))
        .isNotNull();

    Object reliefsResult =
        personalAiToolProvider.execute(userId, null, "get_tax_reliefs", yearInput);
    assertThat(reliefsResult).isInstanceOf(Map.class);
    @SuppressWarnings("unchecked")
    Map<String, Object> reliefs = (Map<String, Object>) reliefsResult;
    assertThat(reliefs).containsKeys("candidates", "confirmed");
    assertThat((List<?>) reliefs.get("candidates")).isEmpty();
    assertThat((List<?>) reliefs.get("confirmed")).isEmpty();
  }

  @Test
  void personalProviderRejectsAnUnknownToolName() {
    org.junit.jupiter.api.Assertions.assertThrows(
        IllegalArgumentException.class,
        () -> personalAiToolProvider.execute(userId, null, "not_a_real_tool", null));
  }

  @Test
  void businessToolsDispatchCorrectlyForAFreshBusinessSpace() throws Exception {
    UUID spaceId = createBusinessSpace();

    assertThat(businessAiToolProvider.execute(userId, spaceId, "get_business_dashboard", null))
        .isNotNull();
    assertThat((List<?>) businessAiToolProvider.execute(userId, spaceId, "get_receivables", null))
        .isEmpty();
    assertThat((List<?>) businessAiToolProvider.execute(userId, spaceId, "get_payables", null))
        .isEmpty();
    assertThat(
            (List<?>) businessAiToolProvider.execute(userId, spaceId, "get_overdue_invoices", null))
        .isEmpty();

    Object reconciliation =
        businessAiToolProvider.execute(userId, spaceId, "get_reconciliation_status", null);
    assertThat(reconciliation).isInstanceOf(Map.class);
    @SuppressWarnings("unchecked")
    Map<String, Object> reconciliationMap = (Map<String, Object>) reconciliation;
    assertThat(reconciliationMap).containsKey("message");
  }

  @Test
  void businessProviderRejectsAnUnknownToolName() throws Exception {
    UUID spaceId = createBusinessSpace();
    org.junit.jupiter.api.Assertions.assertThrows(
        IllegalArgumentException.class,
        () -> businessAiToolProvider.execute(userId, spaceId, "not_a_real_tool", null));
  }

  @Test
  void sharedToolsDispatchCorrectlyForAFreshUserWithNoGroups() {
    assertThat((List<?>) sharedAiToolProvider.execute(userId, null, "get_group_balances", null))
        .isEmpty();
    assertThat(sharedAiToolProvider.execute(userId, null, "get_settlements", null)).isNotNull();
    assertThat((List<?>) sharedAiToolProvider.execute(userId, null, "get_bagilah_summary", null))
        .isEmpty();
  }

  @Test
  void sharedProviderRejectsAnUnknownToolName() {
    org.junit.jupiter.api.Assertions.assertThrows(
        IllegalArgumentException.class,
        () -> sharedAiToolProvider.execute(userId, null, "not_a_real_tool", null));
  }
}
