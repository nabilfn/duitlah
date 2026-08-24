package com.duitlah.api.personaltax;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TaxReliefCandidateController {

  private final TaxReliefCandidateService candidateService;

  public TaxReliefCandidateController(TaxReliefCandidateService candidateService) {
    this.candidateService = candidateService;
  }

  @PostMapping("/api/v1/personal-tax/relief-candidates")
  @ResponseStatus(HttpStatus.CREATED)
  public TaxReliefCandidateResponse create(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreateTaxReliefCandidateRequest request) {
    return candidateService.create(userId, request);
  }

  @GetMapping("/api/v1/personal-tax/relief-candidates")
  public List<TaxReliefCandidateResponse> list(
      @AuthenticationPrincipal UUID userId,
      @RequestParam int yearOfAssessment,
      @RequestParam(required = false) TaxReliefCandidateStatus status) {
    return candidateService.list(userId, yearOfAssessment, status);
  }

  @PostMapping("/api/v1/personal-tax/relief-candidates/{candidateId}/confirm")
  public ConfirmedTaxReliefResponse confirm(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID candidateId,
      @Valid @RequestBody ConfirmTaxReliefCandidateRequest request) {
    return candidateService.confirm(userId, candidateId, request);
  }

  @PostMapping("/api/v1/personal-tax/relief-candidates/{candidateId}/reject")
  public TaxReliefCandidateResponse reject(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID candidateId) {
    return candidateService.reject(userId, candidateId);
  }

  @GetMapping("/api/v1/personal-tax/confirmed-reliefs")
  public List<ConfirmedTaxReliefResponse> listConfirmed(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return candidateService.listConfirmed(userId, yearOfAssessment);
  }

  @DeleteMapping("/api/v1/personal-tax/confirmed-reliefs/{reliefId}")
  public void deleteConfirmed(@AuthenticationPrincipal UUID userId, @PathVariable UUID reliefId) {
    candidateService.deleteConfirmed(userId, reliefId);
  }
}
