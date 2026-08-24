package com.duitlah.api.reconciliation;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ReconciliationSessionController {

  private final ReconciliationSessionService sessions;

  public ReconciliationSessionController(ReconciliationSessionService sessions) {
    this.sessions = sessions;
  }

  @GetMapping("/api/v1/spaces/{spaceId}/reconciliation/sessions")
  public List<ReconciliationSessionResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return sessions.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/reconciliation/sessions/{sessionId}")
  public ReconciliationSessionResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID sessionId) {
    return sessions.get(userId, spaceId, sessionId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/reconciliation/sessions/{sessionId}/summary")
  public ReconciliationSummaryResponse summary(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID sessionId) {
    return sessions.summary(userId, spaceId, sessionId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/reconciliation/sessions/{sessionId}/resolve-difference")
  public ReconciliationSessionResponse resolveDifference(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID sessionId,
      @Valid @RequestBody ResolveDifferenceRequest request) {
    return sessions.resolveDifference(userId, spaceId, sessionId, request);
  }
}
