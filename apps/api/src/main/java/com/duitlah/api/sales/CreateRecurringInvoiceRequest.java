package com.duitlah.api.sales;

import com.duitlah.api.recurring.RecurrenceFrequency;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record CreateRecurringInvoiceRequest(
    @NotNull UUID customerId,
    @DecimalMin(value = "0", inclusive = true) BigDecimal taxPercent,
    String notes,
    @Min(0) Integer paymentTermDays,
    @NotNull RecurrenceFrequency frequency,
    @Min(1) Integer intervalCount,
    @NotNull LocalDate startDate,
    LocalDate endDate,
    @NotEmpty @Valid List<LineItemRequest> lineItems) {

  public BigDecimal taxPercentOrZero() {
    return taxPercent == null ? BigDecimal.ZERO : taxPercent;
  }

  public int paymentTermDaysOrDefault() {
    return paymentTermDays == null ? 30 : paymentTermDays;
  }

  public int intervalCountOrDefault() {
    return intervalCount == null ? 1 : intervalCount;
  }
}
