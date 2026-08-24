package com.duitlah.api.ai;

import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AiController {

  private final AiChatService aiChatService;
  private final AffordabilityService affordabilityService;

  public AiController(AiChatService aiChatService, AffordabilityService affordabilityService) {
    this.aiChatService = aiChatService;
    this.affordabilityService = affordabilityService;
  }

  @PostMapping("/api/v1/ai/chat")
  public ChatResponse chat(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody ChatRequest request) {
    return aiChatService.chat(userId, request);
  }

  @PostMapping("/api/v1/ai/affordability")
  public AffordabilityResponse affordability(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody AffordabilityRequest request) {
    return affordabilityService.check(userId, request);
  }
}
