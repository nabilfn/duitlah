package com.duitlah.api.recurring;

import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record RecurringTransactionResponse(
    UUID id,
    UUID accountId,
    TransactionType type,
    TransactionDirection direction,
    UUID categoryId,
    BigDecimal amount,
    String merchant,
    String description,
    String notes,
    RecurrenceFrequency frequency,
    int intervalCount,
    LocalDate startDate,
    LocalDate endDate,
    LocalDate nextOccurrenceDate,
    boolean isSubscription,
    boolean active) {

  public static RecurringTransactionResponse from(RecurringTransaction r) {
    return new RecurringTransactionResponse(
        r.getId(),
        r.getAccountId(),
        r.getType(),
        r.getDirection(),
        r.getCategoryId(),
        r.getAmount(),
        r.getMerchant(),
        r.getDescription(),
        r.getNotes(),
        r.getFrequency(),
        r.getIntervalCount(),
        r.getStartDate(),
        r.getEndDate(),
        r.getNextOccurrenceDate(),
        r.isSubscription(),
        r.isActive());
  }
}
