package com.duitlah.api.feedback;

import java.time.Instant;
import java.util.UUID;

public record FeedbackResponse(
    UUID id, FeedbackCategory category, String message, Instant createdAt) {

  static FeedbackResponse of(Feedback feedback) {
    return new FeedbackResponse(
        feedback.getId(), feedback.getCategory(), feedback.getMessage(), feedback.getCreatedAt());
  }
}
