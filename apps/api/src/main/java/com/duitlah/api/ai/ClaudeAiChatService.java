package com.duitlah.api.ai;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.spaces.FinancialSpaceResponse;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.spaces.SpaceType;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Real AI provider: implements the product spec's assistant architecture (sections 40, 65) as an
 * agentic tool-use loop against Claude's Messages API -- "Question -> Approved read-only tools ->
 * Structured financial facts -> LLM -> Explanation." The model can only ever answer by calling one
 * of the fixed, read-only tools exposed by whichever {@link AiToolProvider}s are active for this
 * chat's context, never by inventing numbers or reaching outside that surface -- this is the
 * concrete mechanism behind "the LLM must not directly access repositories" (section 65) and
 * "authoritative numbers must be returned by deterministic services; the model may only explain
 * those outputs" (section 67, the explanation layer). Every number the model narrates came from a
 * tool result it cannot alter, and {@link AffordabilityService}'s own math never runs through the
 * model at all.
 *
 * <p>V2 Phase 12 generalized this from a single hardcoded Personal-only tool switch into the
 * pluggable {@link AiToolProvider} pattern (matching {@code EInvoiceProvider}/{@code
 * NotificationProvider}) so Business and Shared tool sets could be added without this class growing
 * a second and third copy of the same dispatch logic. {@code request.activeSpaceId()} (spec section
 * 66, "AI must understand active Financial Space") decides which providers are active for a given
 * request: PERSONAL and SHARED are always active; BUSINESS activates only once the active space is
 * confirmed to be a real BUSINESS space the caller belongs to.
 *
 * <p>Same raw-HTTP style as {@code receipts.ClaudeVisionOcrService} (no Anthropic SDK dependency)
 * -- see that class for why tool results/inputs are walked defensively rather than blindly trusted.
 */
public class ClaudeAiChatService implements AiChatService {

  private static final Logger log = LoggerFactory.getLogger(ClaudeAiChatService.class);
  private static final URI ANTHROPIC_MESSAGES_URI =
      URI.create("https://api.anthropic.com/v1/messages");
  private static final String ANTHROPIC_VERSION = "2023-06-01";
  private static final int MAX_TOOL_ROUNDS = 5;

  private static final String BASE_SYSTEM_PROMPT =
      "You are Duitlah's financial assistant. You answer questions about the current user's finances by "
          + "calling the provided tools -- never guess, estimate, or invent a number that didn't come from a "
          + "tool result. You have no ability to move money, create or edit transactions, or make payments; if "
          + "asked to do any of those, explain that you can only provide information, not take action. Never "
          + "guarantee investment returns or present your answers as professional financial advice -- add a "
          + "brief disclaimer when giving affordability or forecast-based answers. If a tool result is "
          + "uncertain or estimated (forecasts, predicted spending), say so plainly rather than stating it as "
          + "fact. For tax relief questions, never state that something is definitely eligible yourself -- "
          + "relay the tool's own status exactly (e.g. \"potentially eligible\" or \"needs review\"), since "
          + "tax eligibility can be genuinely uncertain. Keep answers concise and in the user's currency (MYR, "
          + "shown as RM).";

  private final String apiKey;
  private final String model;
  private final List<AiToolProvider> toolProviders;
  private final SpaceService spaceService;
  private final HttpClient httpClient;
  private final ObjectMapper objectMapper = new ObjectMapper();

  public ClaudeAiChatService(
      String apiKey, String model, List<AiToolProvider> toolProviders, SpaceService spaceService) {
    this.apiKey = apiKey;
    this.model = model;
    this.toolProviders = toolProviders;
    this.spaceService = spaceService;
    this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(15)).build();
  }

  @Override
  public ChatResponse chat(UUID userId, ChatRequest request) {
    ActiveContext activeContext = resolveActiveContext(userId, request.activeSpaceId());
    Map<String, AiToolProvider> toolOwners = new HashMap<>();
    for (AiToolProvider provider : activeContext.providers()) {
      for (AiToolDefinition definition : provider.definitions()) {
        toolOwners.put(definition.name(), provider);
      }
    }

    ArrayNode messages = objectMapper.createArrayNode();
    for (ChatMessage turn :
        request.history() == null ? List.<ChatMessage>of() : request.history()) {
      messages.add(
          textMessage(turn.role() == ChatMessageRole.USER ? "user" : "assistant", turn.content()));
    }
    messages.add(textMessage("user", request.message()));

    try {
      for (int round = 0; round < MAX_TOOL_ROUNDS; round++) {
        JsonNode response = send(messages, activeContext);
        if (response == null) {
          return new ChatResponse(
              "Something went wrong reaching the AI assistant. Please try again.", true);
        }

        JsonNode content = response.get("content");
        String stopReason = textOrNull(response, "stop_reason");
        if (!"tool_use".equals(stopReason) || content == null || !content.isArray()) {
          return new ChatResponse(extractText(content), true);
        }

        ObjectNode assistantTurn = objectMapper.createObjectNode();
        assistantTurn.put("role", "assistant");
        assistantTurn.set("content", content);
        messages.add(assistantTurn);

        ObjectNode toolResultsTurn = objectMapper.createObjectNode();
        toolResultsTurn.put("role", "user");
        ArrayNode toolResults = toolResultsTurn.putArray("content");
        for (JsonNode block : content) {
          if (!"tool_use".equals(textOrNull(block, "type"))) {
            continue;
          }
          String toolUseId = textOrNull(block, "id");
          String toolName = textOrNull(block, "name");
          JsonNode input = block.get("input");
          String resultJson =
              executeTool(userId, activeContext.spaceId(), toolOwners, toolName, input);

          ObjectNode toolResult = toolResults.addObject();
          toolResult.put("type", "tool_result");
          toolResult.put("tool_use_id", toolUseId);
          toolResult.put("content", resultJson);
        }
        messages.add(toolResultsTurn);
      }
      log.warn("AI chat exceeded {} tool-use rounds without a final answer.", MAX_TOOL_ROUNDS);
      return new ChatResponse(
          "I wasn't able to fully work through that one -- could you try asking a simpler or more specific question?",
          true);
    } catch (IOException | InterruptedException e) {
      if (e instanceof InterruptedException) {
        Thread.currentThread().interrupt();
      }
      log.warn("AI chat call failed.", e);
      return new ChatResponse(
          "Something went wrong reaching the AI assistant. Please try again.", true);
    }
  }

  /**
   * Section 66: PERSONAL and SHARED are always available; BUSINESS only once {@code activeSpaceId}
   * resolves to a real BUSINESS space the caller belongs to -- membership is enforced by {@link
   * SpaceService#getSpace}, the same 404-not-403 chokepoint every other module uses. An
   * invalid/foreign space id simply falls back to the Personal+Shared context rather than failing
   * the whole chat request over a bad id.
   */
  ActiveContext resolveActiveContext(UUID userId, UUID activeSpaceId) {
    List<AiToolProvider> active =
        toolProviders.stream()
            .filter(
                p -> p.context() == AiToolContext.PERSONAL || p.context() == AiToolContext.SHARED)
            .collect(java.util.stream.Collectors.toCollection(java.util.ArrayList::new));

    if (activeSpaceId == null) {
      return new ActiveContext(null, null, active);
    }
    try {
      FinancialSpaceResponse space = spaceService.getSpace(userId, activeSpaceId);
      if (space.type() == SpaceType.BUSINESS) {
        toolProviders.stream()
            .filter(p -> p.context() == AiToolContext.BUSINESS)
            .forEach(active::add);
        return new ActiveContext(activeSpaceId, space.name(), active);
      }
      return new ActiveContext(null, null, active);
    } catch (ApiException e) {
      return new ActiveContext(null, null, active);
    }
  }

  record ActiveContext(UUID spaceId, String spaceName, List<AiToolProvider> providers) {}

  private JsonNode send(ArrayNode messages, ActiveContext activeContext)
      throws IOException, InterruptedException {
    ObjectNode root = objectMapper.createObjectNode();
    root.put("model", model);
    root.put("max_tokens", 1024);
    root.put("system", systemPrompt(activeContext));
    root.set("messages", messages);
    root.set("tools", buildTools(activeContext.providers()));

    HttpRequest httpRequest =
        HttpRequest.newBuilder(ANTHROPIC_MESSAGES_URI)
            .header("x-api-key", apiKey)
            .header("anthropic-version", ANTHROPIC_VERSION)
            .header("content-type", "application/json")
            .timeout(Duration.ofSeconds(60))
            .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(root)))
            .build();

    HttpResponse<String> httpResponse =
        httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
    if (httpResponse.statusCode() != 200) {
      log.warn(
          "Anthropic API returned status {} for a chat call: {}",
          httpResponse.statusCode(),
          httpResponse.body());
      return null;
    }
    return objectMapper.readTree(httpResponse.body());
  }

  private String systemPrompt(ActiveContext activeContext) {
    if (activeContext.spaceId() == null) {
      return BASE_SYSTEM_PROMPT + " You are currently helping with the user's Personal finances.";
    }
    return BASE_SYSTEM_PROMPT
        + " You are currently helping with the user's Business space \""
        + activeContext.spaceName()
        + "\" -- Business tools refer to that business's own books, separate from the user's Personal finances.";
  }

  private String executeTool(
      UUID userId,
      UUID spaceId,
      Map<String, AiToolProvider> toolOwners,
      String toolName,
      JsonNode input) {
    try {
      AiToolProvider owner = toolName == null ? null : toolOwners.get(toolName);
      if (owner == null) {
        return "{\"error\": \"Unknown tool.\"}";
      }
      Object result = owner.execute(userId, spaceId, toolName, input);
      return objectMapper.writeValueAsString(result);
    } catch (RuntimeException | IOException e) {
      log.warn("AI tool call '{}' failed.", toolName, e);
      return "{\"error\": \"This query couldn't be completed.\"}";
    }
  }

  private ObjectNode textMessage(String role, String text) {
    ObjectNode message = objectMapper.createObjectNode();
    message.put("role", role);
    message.put("content", text);
    return message;
  }

  private String extractText(JsonNode content) {
    if (content == null || !content.isArray()) {
      return "I didn't get a usable response -- please try again.";
    }
    StringBuilder sb = new StringBuilder();
    for (JsonNode block : content) {
      if ("text".equals(textOrNull(block, "type"))) {
        if (!sb.isEmpty()) {
          sb.append('\n');
        }
        sb.append(textOrNull(block, "text"));
      }
    }
    return sb.isEmpty() ? "I didn't get a usable response -- please try again." : sb.toString();
  }

  private ArrayNode buildTools(List<AiToolProvider> providers) {
    ArrayNode tools = objectMapper.createArrayNode();
    for (AiToolProvider provider : providers) {
      for (AiToolDefinition definition : provider.definitions()) {
        ObjectNode tool = objectMapper.createObjectNode();
        tool.put("name", definition.name());
        tool.put("description", definition.description());
        tool.set("input_schema", definition.inputSchema());
        tools.add(tool);
      }
    }
    return tools;
  }

  private static String textOrNull(JsonNode node, String field) {
    JsonNode value = node.get(field);
    return value == null || value.isNull() ? null : value.asText();
  }
}
