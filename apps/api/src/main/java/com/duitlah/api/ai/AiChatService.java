package com.duitlah.api.ai;

import java.util.UUID;

/**
 * Abstraction over the LLM provider (same "optional external provider" posture as {@code
 * receipts.ReceiptOcrService}/{@code common.mail.EmailSender}). {@link UnavailableAiChatService} is
 * the fallback when no provider is configured; {@link ClaudeAiChatService} is the real
 * implementation.
 */
public interface AiChatService {

  ChatResponse chat(UUID userId, ChatRequest request);
}
