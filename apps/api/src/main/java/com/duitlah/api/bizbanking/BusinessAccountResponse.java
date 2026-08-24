package com.duitlah.api.bizbanking;

import java.math.BigDecimal;
import java.util.UUID;

public record BusinessAccountResponse(
    UUID id,
    String name,
    BusinessAccountType type,
    String currency,
    BigDecimal openingBalance,
    BigDecimal balance,
    UUID chartOfAccountsId,
    boolean archived) {

  public static BusinessAccountResponse from(BusinessAccount account, BigDecimal balance) {
    return new BusinessAccountResponse(
        account.getId(),
        account.getName(),
        account.getType(),
        account.getCurrency(),
        account.getOpeningBalance(),
        balance,
        account.getChartOfAccountsId(),
        account.isArchived());
  }
}
