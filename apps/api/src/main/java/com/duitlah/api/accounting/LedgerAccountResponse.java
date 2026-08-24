package com.duitlah.api.accounting;

import java.util.UUID;

public record LedgerAccountResponse(
    UUID id,
    String code,
    String name,
    AccountType type,
    boolean systemDefault,
    boolean cashEquivalent,
    boolean archived) {

  static LedgerAccountResponse of(LedgerAccount a) {
    return new LedgerAccountResponse(
        a.getId(),
        a.getCode(),
        a.getName(),
        a.getType(),
        a.isSystemDefault(),
        a.isCashEquivalent(),
        a.isArchived());
  }
}
