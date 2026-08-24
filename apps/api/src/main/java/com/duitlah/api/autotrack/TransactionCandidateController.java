package com.duitlah.api.autotrack;

import com.duitlah.api.transactions.CreateTransactionRequest;
import com.duitlah.api.transactions.TransactionResponse;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TransactionCandidateController {

  private final TransactionCandidateService candidateService;

  public TransactionCandidateController(TransactionCandidateService candidateService) {
    this.candidateService = candidateService;
  }

  @GetMapping("/api/v1/autotrack/candidates")
  public List<TransactionCandidateResponse> list(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(required = false) CandidateStatus status) {
    return candidateService.list(userId, status);
  }

  @GetMapping("/api/v1/autotrack/candidates/{candidateId}")
  public TransactionCandidateResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID candidateId) {
    return candidateService.get(userId, candidateId);
  }

  @PostMapping("/api/v1/autotrack/candidates/{candidateId}/confirm")
  public TransactionResponse confirm(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID candidateId,
      @Valid @RequestBody CreateTransactionRequest request) {
    return candidateService.confirm(userId, candidateId, request);
  }

  @PostMapping("/api/v1/autotrack/candidates/{candidateId}/reject")
  public void reject(@AuthenticationPrincipal UUID userId, @PathVariable UUID candidateId) {
    candidateService.reject(userId, candidateId);
  }

  @PostMapping("/api/v1/autotrack/candidates/{candidateId}/merge")
  public void merge(@AuthenticationPrincipal UUID userId, @PathVariable UUID candidateId) {
    candidateService.merge(userId, candidateId);
  }
}
