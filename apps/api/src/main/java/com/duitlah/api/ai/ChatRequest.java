package com.duitlah.api.ai;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.List;
import java.util.UUID;

/**
 * Stateless multi-turn chat: the client resends the prior conversation on every request rather than
 * the server persisting sessions -- there's no product requirement yet for chat history to survive
 * across devices or app restarts, so the simplest thing that works is not storing it at all.
 *
 * <p>V2 Phase 12 -- {@code activeSpaceId} is spec section 66's "AI must understand active Financial
 * Space": omit it (or pass the user's own PERSONAL space) for a Personal-only conversation; pass a
 * BUSINESS space the user belongs to and Business tools become available alongside Personal ones
 * for that request. Shared (Groups/Bagilah/Settlements) tools are always available regardless.
 */
public record ChatRequest(
    @NotBlank @Size(max = 2000) String message,
    @Valid @Size(max = 20) List<ChatMessage> history,
    UUID activeSpaceId) {}
