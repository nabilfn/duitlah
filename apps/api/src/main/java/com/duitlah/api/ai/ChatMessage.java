package com.duitlah.api.ai;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/** One turn of prior conversation, echoed back by the client on every request (see ChatRequest). */
public record ChatMessage(@NotNull ChatMessageRole role, @NotBlank String content) {}
