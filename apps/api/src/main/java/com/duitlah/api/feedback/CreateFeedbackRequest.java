package com.duitlah.api.feedback;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateFeedbackRequest(
    @NotNull FeedbackCategory category, @NotBlank @Size(max = 2000) String message) {}
