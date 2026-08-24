package com.duitlah.api.ai;

/**
 * {@code available} is false whenever no LLM provider is configured (see UnavailableAiChatService)
 * -- {@code reply} is still a real, honest message in that case (never a fabricated financial
 * insight), just not one that came from a model.
 */
public record ChatResponse(String reply, boolean available) {}
