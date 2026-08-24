package com.duitlah.api.recurring;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code accountId}, {@code type}, and {@code startDate} are immutable after creation — the same
 * "identity fields don't change" convention as {@code UpdateTransactionRequest}. {@code
 * frequency}/{@code intervalCount} changes only affect future occurrences; {@code
 * nextOccurrenceDate} itself is never directly editable, only ever advanced by materialization.
 */
public record UpdateRecurringTransactionRequest(
    UUID categoryId,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @Size(max = 120) String merchant,
    @Size(max = 255) String description,
    String notes,
    @NotNull RecurrenceFrequency frequency,
    @Min(1) Integer intervalCount,
    LocalDate endDate,
    boolean isSubscription,
    boolean active) {

  public int intervalCountOrDefault() {
    return intervalCount == null ? 1 : intervalCount;
  }
}
