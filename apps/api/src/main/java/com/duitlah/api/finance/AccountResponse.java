package com.duitlah.api.finance;

import java.math.BigDecimal;
import java.util.UUID;

public record AccountResponse(
    UUID id,
    String name,
    AccountType type,
    String currency,
    BigDecimal openingBalance,
    BigDecimal balance,
    boolean archived) {

  public static AccountResponse from(Account account, BigDecimal balance) {
    return new AccountResponse(
        account.getId(),
        account.getName(),
        account.getType(),
        account.getCurrency(),
        account.getOpeningBalance(),
        balance,
        account.isArchived());
  }
}
