package com.duitlah.api.ai;

import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Used whenever no AI provider is configured ({@code duitlah.ai.anthropic-api-key} unset). Returns
 * an honest "not available" message rather than fabricating a financial insight -- the same
 * discipline as {@code receipts.UnavailableOcrService} returning a blank parse instead of guessing.
 */
public class UnavailableAiChatService implements AiChatService {

  private static final Logger log = LoggerFactory.getLogger(UnavailableAiChatService.class);

  @Override
  public ChatResponse chat(UUID userId, ChatRequest request) {
    log.info(
        "AI assistant is not configured (ANTHROPIC_API_KEY unset) -- returning a fixed reply.");
    return new ChatResponse(
        "The AI assistant isn't set up on this server yet. Ask whoever runs this Duitlah "
            + "instance to configure an AI provider to enable it.",
        false);
  }
}
