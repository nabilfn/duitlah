package com.duitlah.api.personaltax;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The pipeline's own last two boxes (spec section 27): a candidate arrives already carrying its
 * suggestion (from {@link #createFromReceipt}, called by {@code
 * receipts.ReceiptVaultService#upload} for a real {@code TAX_EVIDENCE}-tagged upload — never a
 * fabricated merchant-category guess) and this service only ever moves it forward on an explicit
 * user action.
 */
@Service
public class TaxReliefCandidateService {

  private final TaxReliefCandidateRepository candidates;
  private final ConfirmedTaxReliefRepository confirmedReliefs;
  private final TaxYearService taxYearService;

  public TaxReliefCandidateService(
      TaxReliefCandidateRepository candidates,
      ConfirmedTaxReliefRepository confirmedReliefs,
      TaxYearService taxYearService) {
    this.candidates = candidates;
    this.confirmedReliefs = confirmedReliefs;
    this.taxYearService = taxYearService;
  }

  /**
   * Called by {@code receipts.ReceiptVaultService} for a TAX_EVIDENCE upload with a parsed total.
   */
  @Transactional
  public TaxReliefCandidate createFromReceipt(
      UUID userId, UUID receiptId, int yearOfAssessment, BigDecimal amount) {
    TaxReliefCandidate candidate =
        new TaxReliefCandidate(
            userId,
            yearOfAssessment,
            null,
            receiptId,
            amount,
            TaxReliefCandidateStatus.NEEDS_REVIEW);
    candidates.save(candidate);
    return candidate;
  }

  @Transactional
  public TaxReliefCandidateResponse create(UUID userId, CreateTaxReliefCandidateRequest request) {
    TaxReliefCandidate candidate =
        new TaxReliefCandidate(
            userId,
            request.yearOfAssessment(),
            request.category(),
            null,
            request.suggestedAmount(),
            request.statusOrDefault());
    candidate.setNotes(request.notes());
    candidates.save(candidate);
    return TaxReliefCandidateResponse.from(candidate);
  }

  public List<TaxReliefCandidateResponse> list(
      UUID userId, int yearOfAssessment, TaxReliefCandidateStatus status) {
    List<TaxReliefCandidate> rows =
        status != null
            ? candidates.findByUserIdAndYearOfAssessmentAndStatusOrderByCreatedAtDesc(
                userId, yearOfAssessment, status)
            : candidates.findByUserIdAndYearOfAssessmentOrderByCreatedAtDesc(
                userId, yearOfAssessment);
    return rows.stream().map(TaxReliefCandidateResponse::from).toList();
  }

  @Transactional
  public ConfirmedTaxReliefResponse confirm(
      UUID userId, UUID candidateId, ConfirmTaxReliefCandidateRequest request) {
    TaxReliefCandidate candidate = requireOwned(userId, candidateId);
    requireUnresolved(candidate);

    TaxYear taxYear = taxYearService.requireYear(candidate.getYearOfAssessment());
    BigDecimal maxAmount =
        taxYearService.reliefRulesFor(taxYear).stream()
            .filter(rule -> rule.getCategory() == request.category())
            .map(TaxReliefRule::getMaxAmount)
            .findFirst()
            .orElse(request.amount());
    BigDecimal clampedAmount = request.amount().min(maxAmount);

    ConfirmedTaxRelief relief =
        confirmedReliefs
            .findByUserIdAndYearOfAssessmentAndCategory(
                userId, candidate.getYearOfAssessment(), request.category())
            .orElseGet(
                () ->
                    new ConfirmedTaxRelief(
                        userId,
                        candidate.getYearOfAssessment(),
                        request.category(),
                        clampedAmount));
    relief.setConfirmedAmount(clampedAmount);
    relief.setSourceCandidateId(candidateId);
    confirmedReliefs.save(relief);

    candidate.setCategory(request.category());
    candidate.setStatus(TaxReliefCandidateStatus.CONFIRMED);
    candidates.save(candidate);

    return ConfirmedTaxReliefResponse.from(relief);
  }

  @Transactional
  public TaxReliefCandidateResponse reject(UUID userId, UUID candidateId) {
    TaxReliefCandidate candidate = requireOwned(userId, candidateId);
    requireUnresolved(candidate);
    candidate.setStatus(TaxReliefCandidateStatus.REJECTED);
    candidates.save(candidate);
    return TaxReliefCandidateResponse.from(candidate);
  }

  public List<ConfirmedTaxReliefResponse> listConfirmed(UUID userId, int yearOfAssessment) {
    return confirmedReliefs.findByUserIdAndYearOfAssessment(userId, yearOfAssessment).stream()
        .map(ConfirmedTaxReliefResponse::from)
        .toList();
  }

  @Transactional
  public void deleteConfirmed(UUID userId, UUID confirmedReliefId) {
    ConfirmedTaxRelief relief =
        confirmedReliefs
            .findByIdAndUserId(confirmedReliefId, userId)
            .orElseThrow(
                () ->
                    new NotFoundException(
                        "CONFIRMED_RELIEF_NOT_FOUND", "Confirmed relief not found."));
    confirmedReliefs.delete(relief);
  }

  /**
   * How many candidates are still awaiting review for a category — used by {@link
   * FilingReadinessService}.
   */
  public boolean hasPendingCandidates(
      UUID userId, int yearOfAssessment, PersonalTaxReliefCategory category) {
    return !candidates
        .findByUserIdAndYearOfAssessmentAndCategoryAndStatusIn(
            userId,
            yearOfAssessment,
            category,
            List.of(
                TaxReliefCandidateStatus.NEEDS_REVIEW,
                TaxReliefCandidateStatus.POTENTIALLY_ELIGIBLE))
        .isEmpty();
  }

  private void requireUnresolved(TaxReliefCandidate candidate) {
    if (candidate.isResolved()) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "CANDIDATE_ALREADY_RESOLVED",
          "This candidate has already been " + candidate.getStatus().name().toLowerCase() + ".");
    }
  }

  private TaxReliefCandidate requireOwned(UUID userId, UUID candidateId) {
    return candidates
        .findByIdAndUserId(candidateId, userId)
        .orElseThrow(() -> new NotFoundException("CANDIDATE_NOT_FOUND", "Candidate not found."));
  }
}
