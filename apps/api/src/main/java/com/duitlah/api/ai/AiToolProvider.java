package com.duitlah.api.ai;

import com.fasterxml.jackson.databind.JsonNode;
import java.util.List;
import java.util.UUID;

/**
 * V2 Phase 12 — the pluggable tool abstraction spec section 66's "workspace-aware tools" needs,
 * matching this codebase's established provider pattern ({@code EInvoiceProvider}, {@code
 * NotificationProvider}). {@link ClaudeAiChatService} auto-wires every bean of this type via {@code
 * List<AiToolProvider>}, aggregates whichever ones are active for the current chat's context into
 * the tools array sent to the model, and dispatches each {@code tool_use} block to whichever
 * provider owns that tool name. Every implementation is a thin pass-through to an
 * already-authorized, already-existing service — the same "Finance Query Layer" discipline {@link
 * FinanceQueryService} established, just generalized across contexts instead of hardcoded to one
 * class. {@code spaceId} is only meaningful for {@link AiToolContext#BUSINESS} providers; {@code
 * PERSONAL}/{@code SHARED} providers ignore it.
 */
public interface AiToolProvider {

  AiToolContext context();

  List<AiToolDefinition> definitions();

  /**
   * Returns the raw result object to be JSON-serialized and handed back to the model as a tool
   * result — never a pre-formatted string, so every provider's result shape stays exactly the same
   * as the deterministic service it came from. Throws on an unknown tool name or invalid input; the
   * caller ({@link ClaudeAiChatService}) catches and turns that into an honest "this query couldn't
   * be completed" tool result rather than letting it propagate.
   */
  Object execute(UUID userId, UUID spaceId, String toolName, JsonNode input);
}
