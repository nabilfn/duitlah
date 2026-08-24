package com.duitlah.api.recurring;

import com.duitlah.api.transactions.TransactionType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateRecurringTransactionRequest(
    @NotNull UUID accountId,
    @NotNull TransactionType type,
    UUID categoryId,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @Size(max = 120) String merchant,
    @Size(max = 255) String description,
    String notes,
    @NotNull RecurrenceFrequency frequency,
    @Min(1) Integer intervalCount,
    @NotNull LocalDate startDate,
    LocalDate endDate,
    boolean isSubscription) {

  public int intervalCountOrDefault() {
    return intervalCount == null ? 1 : intervalCount;
  }
}
