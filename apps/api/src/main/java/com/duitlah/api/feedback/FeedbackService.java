package com.duitlah.api.feedback;

import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FeedbackService {

  private final FeedbackRepository feedback;

  public FeedbackService(FeedbackRepository feedback) {
    this.feedback = feedback;
  }

  @Transactional
  public FeedbackResponse submit(UUID userId, CreateFeedbackRequest request) {
    Feedback saved =
        feedback.save(new Feedback(userId, request.category(), request.message().trim()));
    return FeedbackResponse.of(saved);
  }

  public List<FeedbackResponse> listForUser(UUID userId) {
    return feedback.findByUserIdOrderByCreatedAtDesc(userId).stream()
        .map(FeedbackResponse::of)
        .toList();
  }
}
