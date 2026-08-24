package com.duitlah.api.feedback;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FeedbackController {

  private final FeedbackService feedbackService;

  public FeedbackController(FeedbackService feedbackService) {
    this.feedbackService = feedbackService;
  }

  @PostMapping("/api/v1/feedback")
  @ResponseStatus(HttpStatus.CREATED)
  public FeedbackResponse submit(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateFeedbackRequest request) {
    return feedbackService.submit(userId, request);
  }

  @GetMapping("/api/v1/feedback/me")
  public List<FeedbackResponse> listMine(@AuthenticationPrincipal UUID userId) {
    return feedbackService.listForUser(userId);
  }
}
