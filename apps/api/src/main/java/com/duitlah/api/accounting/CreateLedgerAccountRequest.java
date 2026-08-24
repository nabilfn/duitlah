package com.duitlah.api.accounting;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateLedgerAccountRequest(
    @NotBlank String code,
    @NotBlank String name,
    @NotNull AccountType type,
    Boolean cashEquivalent) {

  public boolean cashEquivalentOrFalse() {
    return Boolean.TRUE.equals(cashEquivalent);
  }
}
