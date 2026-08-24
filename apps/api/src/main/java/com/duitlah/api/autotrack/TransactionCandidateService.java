package com.duitlah.api.autotrack;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.transactionrules.TransactionRuleService;
import com.duitlah.api.transactions.CreateTransactionRequest;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import com.duitlah.api.transactions.TransactionResponse;
import com.duitlah.api.transactions.TransactionService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The pipeline's own last two boxes (spec section 10's diagram): a candidate is created already
 * carrying every earlier box's output (parse/normalize done by its producer, duplicate-detected,
 * account/category suggested, confidence assigned) and this service only ever moves it forward on
 * an explicit user action — {@link #confirm} is the single path that writes a real {@code
 * transactions} row, and it always goes through {@link TransactionService#create}, the same entry
 * point a manual "Add transaction" uses, so a confirmed candidate is an ordinary transaction from
 * that point on.
 */
@Service
public class TransactionCandidateService {

  private final TransactionCandidateRepository candidates;
  private final TransactionRepository transactions;
  private final TransactionService transactionService;
  private final DuplicateDetectionService duplicateDetection;
  private final CategorySuggestionService categorySuggestion;
  private final TransactionRuleService transactionRuleService;

  public TransactionCandidateService(
      TransactionCandidateRepository candidates,
      TransactionRepository transactions,
      TransactionService transactionService,
      DuplicateDetectionService duplicateDetection,
      CategorySuggestionService categorySuggestion,
      TransactionRuleService transactionRuleService) {
    this.candidates = candidates;
    this.transactions = transactions;
    this.transactionService = transactionService;
    this.duplicateDetection = duplicateDetection;
    this.categorySuggestion = categorySuggestion;
    this.transactionRuleService = transactionRuleService;
  }

  /** Called by {@code receipts}/{@code statements} once they've parsed a row into these fields. */
  @Transactional
  public TransactionCandidate create(
      UUID userId,
      UUID spaceId,
      CandidateSourceType sourceType,
      UUID receiptId,
      UUID statementImportId,
      BigDecimal amount,
      String currency,
      String merchant,
      LocalDate date,
      com.duitlah.api.transactions.TransactionDirection direction,
      UUID accountHint,
      BigDecimal confidence) {
    UUID suggestedAccountId =
        accountHint != null
            ? accountHint
            : transactions
                .findFirstByUserIdOrderByOccurredOnDescCreatedAtDesc(userId)
                .map(Transaction::getAccountId)
                .orElse(null);
    UUID suggestedCategoryId = categorySuggestion.suggest(userId, merchant).orElse(null);

    TransactionCandidate candidate =
        new TransactionCandidate(
            userId,
            spaceId,
            sourceType,
            receiptId,
            statementImportId,
            amount,
            currency,
            merchant,
            date,
            direction,
            suggestedAccountId,
            suggestedCategoryId,
            confidence);

    duplicateDetection
        .detect(userId, amount, merchant, date, suggestedAccountId)
        .ifPresent(
            match -> {
              candidate.setDuplicateOfTransactionId(match.transactionId());
              candidate.setDuplicateConfidence(match.confidence());
            });

    candidates.save(candidate);
    return candidate;
  }

  public List<TransactionCandidateResponse> list(UUID userId, CandidateStatus status) {
    List<TransactionCandidate> rows =
        status != null
            ? candidates.findByUserIdAndStatusOrderByDetectedDateDesc(userId, status)
            : candidates.findByUserIdOrderByDetectedDateDesc(userId);
    return rows.stream().map(TransactionCandidateResponse::from).toList();
  }

  public TransactionCandidateResponse get(UUID userId, UUID candidateId) {
    return TransactionCandidateResponse.from(requireOwned(userId, candidateId));
  }

  @Transactional
  public TransactionResponse confirm(
      UUID userId, UUID candidateId, CreateTransactionRequest request) {
    TransactionCandidate candidate = requireOwned(userId, candidateId);
    requireResolvable(candidate);

    TransactionResponse created = transactionService.create(userId, request);
    candidate.setResultingTransactionId(created.id());
    candidate.setStatus(CandidateStatus.CONFIRMED);
    candidates.save(candidate);
    transactionRuleService.learnFromConfirmation(
        userId, candidate.getDetectedMerchant(), created.categoryId());
    return created;
  }

  @Transactional
  public void reject(UUID userId, UUID candidateId) {
    TransactionCandidate candidate = requireOwned(userId, candidateId);
    requireResolvable(candidate);
    candidate.setStatus(CandidateStatus.REJECTED);
    candidates.save(candidate);
  }

  /** "Merge" from the spec's own example UI (section 12): this is already the same transaction. */
  @Transactional
  public void merge(UUID userId, UUID candidateId) {
    TransactionCandidate candidate = requireOwned(userId, candidateId);
    requireResolvable(candidate);
    if (candidate.getDuplicateOfTransactionId() == null) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "NOT_A_POSSIBLE_DUPLICATE",
          "This candidate wasn't flagged as a possible duplicate.");
    }
    candidate.setStatus(CandidateStatus.DUPLICATE);
    candidates.save(candidate);
  }

  private void requireResolvable(TransactionCandidate candidate) {
    if (candidate.getStatus() != CandidateStatus.PENDING) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "CANDIDATE_ALREADY_RESOLVED",
          "This candidate has already been " + candidate.getStatus().name().toLowerCase() + ".");
    }
  }

  private TransactionCandidate requireOwned(UUID userId, UUID candidateId) {
    return candidates
        .findByIdAndUserId(candidateId, userId)
        .orElseThrow(() -> new NotFoundException("CANDIDATE_NOT_FOUND", "Candidate not found."));
  }
}
