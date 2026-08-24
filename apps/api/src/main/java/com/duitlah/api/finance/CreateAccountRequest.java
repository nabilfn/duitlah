package com.duitlah.api.finance;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public record CreateAccountRequest(
    @NotBlank @Size(max = 120) String name,
    @NotNull AccountType type,
    @Pattern(regexp = "[A-Z]{3}") String currency,
    BigDecimal openingBalance) {

  public String currencyOrDefault() {
    return currency == null || currency.isBlank() ? "MYR" : currency;
  }

  public BigDecimal openingBalanceOrZero() {
    return openingBalance == null ? BigDecimal.ZERO : openingBalance;
  }
}
