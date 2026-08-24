package com.duitlah.api.transactions;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

public record TransactionResponse(
    UUID id,
    UUID accountId,
    TransactionType type,
    TransactionDirection direction,
    UUID categoryId,
    UUID transferGroupId,
    UUID recurringTransactionId,
    BigDecimal amount,
    String merchant,
    String description,
    String notes,
    LocalDate occurredOn,
    String originalCurrency,
    BigDecimal originalAmount,
    BigDecimal exchangeRate,
    Instant convertedAt) {

  public static TransactionResponse from(Transaction t) {
    return new TransactionResponse(
        t.getId(),
        t.getAccountId(),
        t.getType(),
        t.getDirection(),
        t.getCategoryId(),
        t.getTransferGroupId(),
        t.getRecurringTransactionId(),
        t.getAmount(),
        t.getMerchant(),
        t.getDescription(),
        t.getNotes(),
        t.getOccurredOn(),
        t.getOriginalCurrency(),
        t.getOriginalAmount(),
        t.getExchangeRate(),
        t.getConvertedAt());
  }
}
