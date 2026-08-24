package com.duitlah.api.autotrack;

import com.duitlah.api.transactions.TransactionDirection;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record TransactionCandidateResponse(
    UUID id,
    CandidateSourceType sourceType,
    BigDecimal detectedAmount,
    String detectedCurrency,
    String detectedMerchant,
    LocalDate detectedDate,
    TransactionDirection detectedDirection,
    UUID suggestedAccountId,
    UUID suggestedCategoryId,
    BigDecimal confidence,
    CandidateStatus status,
    UUID duplicateOfTransactionId,
    BigDecimal duplicateConfidence,
    UUID resultingTransactionId) {

  public static TransactionCandidateResponse from(TransactionCandidate c) {
    return new TransactionCandidateResponse(
        c.getId(),
        c.getSourceType(),
        c.getDetectedAmount(),
        c.getDetectedCurrency(),
        c.getDetectedMerchant(),
        c.getDetectedDate(),
        c.getDetectedDirection(),
        c.getSuggestedAccountId(),
        c.getSuggestedCategoryId(),
        c.getConfidence(),
        c.getStatus(),
        c.getDuplicateOfTransactionId(),
        c.getDuplicateConfidence(),
        c.getResultingTransactionId());
  }
}
