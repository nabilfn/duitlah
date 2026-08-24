package com.duitlah.api.bizbanking;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import java.math.BigDecimal;

public record CreateBusinessAccountRequest(
    @NotBlank String name,
    @NotNull BusinessAccountType type,
    @Pattern(regexp = "^[A-Z]{3}$") String currency,
    BigDecimal openingBalance) {

  public String currencyOrDefault() {
    return currency == null || currency.isBlank() ? "MYR" : currency;
  }

  public BigDecimal openingBalanceOrZero() {
    return openingBalance == null ? BigDecimal.ZERO : openingBalance;
  }
}
