package com.duitlah.api.liabilities;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record SetCreditCardDetailsRequest(
    @NotNull @DecimalMin(value = "0.01") BigDecimal creditLimit,
    @Min(1) @Max(28) int statementDay,
    @Min(1) @Max(28) int paymentDueDay,
    BigDecimal minimumPaymentPercent) {

  public BigDecimal minimumPaymentPercentOrDefault() {
    return minimumPaymentPercent == null ? new BigDecimal("5.00") : minimumPaymentPercent;
  }
}
