package com.duitlah.api.ai;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
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
 * V2 Phase 12 -- {@link ClaudeAiChatService#resolveActiveContext} is the concrete mechanism behind
 * spec section 66's "AI must understand active Financial Space." No ANTHROPIC_API_KEY is configured
 * in tests (see {@link AiFlowTests}), so the real bean is always {@link UnavailableAiChatService};
 * this constructs a {@link ClaudeAiChatService} directly with real, Spring-managed {@link
 * AiToolProvider} beans and a real {@link SpaceService}, exercising only the routing logic that
 * decides which providers are active -- never the outbound HTTP call to Anthropic.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AiWorkspaceContextFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private List<AiToolProvider> toolProviders;
  @Autowired private SpaceService spaceService;

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
                                "ai-context@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    JsonNode registerResponse = objectMapper.readTree(result.getResponse().getContentAsString());
    accessToken = registerResponse.get("accessToken").asText();
    userId = UUID.fromString(registerResponse.get("user").get("id").asText());
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private ClaudeAiChatService newService() {
    return new ClaudeAiChatService("test-key", "test-model", toolProviders, spaceService);
  }

  @Test
  void withNoActiveSpacePersonalAndSharedToolsAreActiveButNotBusiness() {
    ClaudeAiChatService.ActiveContext context = newService().resolveActiveContext(userId, null);

    assertThat(context.spaceId()).isNull();
    assertThat(context.providers())
        .extracting(AiToolProvider::context)
        .containsExactlyInAnyOrder(AiToolContext.PERSONAL, AiToolContext.SHARED);
  }

  @Test
  void aRealBusinessSpaceActivatesBusinessToolsAlongsidePersonalAndShared() throws Exception {
    var spaceBody =
        objectMapper
            .createObjectNode()
            .put("name", "My Business")
            .put("legalName", "My Business Sdn Bhd");
    var spaceResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(spaceBody.toString()))
            .andReturn();
    UUID spaceId =
        UUID.fromString(
            objectMapper
                .readTree(spaceResult.getResponse().getContentAsString())
                .get("id")
                .asText());

    ClaudeAiChatService.ActiveContext context = newService().resolveActiveContext(userId, spaceId);

    assertThat(context.spaceId()).isEqualTo(spaceId);
    assertThat(context.providers())
        .extracting(AiToolProvider::context)
        .containsExactlyInAnyOrder(
            AiToolContext.PERSONAL, AiToolContext.SHARED, AiToolContext.BUSINESS);
  }

  @Test
  void aForeignOrInvalidSpaceIdFallsBackToPersonalAndSharedOnly() {
    ClaudeAiChatService.ActiveContext context =
        newService().resolveActiveContext(userId, UUID.randomUUID());

    assertThat(context.spaceId()).isNull();
    assertThat(context.providers())
        .extracting(AiToolProvider::context)
        .containsExactlyInAnyOrder(AiToolContext.PERSONAL, AiToolContext.SHARED);
  }
}
