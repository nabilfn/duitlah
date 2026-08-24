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
public class ReconciliationLineController {

  private final MatchingService matchingService;
  private final ReconciliationActionService actionService;

  public ReconciliationLineController(
      MatchingService matchingService, ReconciliationActionService actionService) {
    this.matchingService = matchingService;
    this.actionService = actionService;
  }

  @GetMapping(
      "/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/lines/{lineId}/suggestions")
  public List<MatchSuggestionResponse> suggestMatches(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId,
      @PathVariable UUID lineId) {
    return matchingService.suggestMatches(userId, spaceId, importId, lineId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/auto-match")
  public AutoMatchSummary autoMatch(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId) {
    return actionService.autoMatchExact(userId, spaceId, importId);
  }

  @PostMapping(
      "/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/lines/{lineId}/match")
  public StatementLineResponse match(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId,
      @PathVariable UUID lineId,
      @Valid @RequestBody MatchLineRequest request) {
    return actionService.match(userId, spaceId, importId, lineId, request);
  }

  @PostMapping(
      "/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/lines/{lineId}/create-transaction")
  public StatementLineResponse createTransaction(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId,
      @PathVariable UUID lineId) {
    return actionService.createTransaction(userId, spaceId, importId, lineId);
  }

  @PostMapping(
      "/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/lines/{lineId}/ignore")
  public StatementLineResponse ignore(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId,
      @PathVariable UUID lineId) {
    return actionService.ignore(userId, spaceId, importId, lineId);
  }

  @PostMapping(
      "/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/lines/{lineId}/split")
  public StatementLineResponse split(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId,
      @PathVariable UUID lineId,
      @Valid @RequestBody SplitLineRequest request) {
    return actionService.split(userId, spaceId, importId, lineId, request);
  }
}
