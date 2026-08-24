package com.duitlah.api.sales;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record CreateQuotationRequest(
    @NotNull UUID customerId,
    @NotNull LocalDate issueDate,
    LocalDate expiryDate,
    @DecimalMin(value = "0", inclusive = true) BigDecimal taxPercent,
    String notes,
    @NotEmpty @Valid List<LineItemRequest> lineItems) {

  public BigDecimal taxPercentOrZero() {
    return taxPercent == null ? BigDecimal.ZERO : taxPercent;
  }
}
