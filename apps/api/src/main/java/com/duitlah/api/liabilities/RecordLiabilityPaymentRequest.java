package com.duitlah.api.liabilities;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code principalPortion + interestPortion} need not equal {@code amount} exactly (e.g. a fee
 * component) — this app doesn't second-guess the lender's own statement breakdown, it just records
 * what the user reports. If {@code accountId} is given, a real linked expense transaction is
 * created via {@code TransactionService#create} (the payment source, e.g. cash leaving a bank
 * account) — optional, since a user may just be logging history from a paper statement.
 */
public record RecordLiabilityPaymentRequest(
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @NotNull @DecimalMin(value = "0") BigDecimal principalPortion,
    BigDecimal interestPortion,
    @NotNull LocalDate paidOn,
    UUID accountId) {

  public BigDecimal interestPortionOrZero() {
    return interestPortion == null ? BigDecimal.ZERO : interestPortion;
  }
}
