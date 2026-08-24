package com.duitlah.api.accounting;

import java.time.LocalDate;
import java.util.UUID;

public record AccountingPeriodResponse(
    UUID id, LocalDate periodStart, LocalDate periodEnd, PeriodStatus status) {

  static AccountingPeriodResponse of(AccountingPeriod p) {
    return new AccountingPeriodResponse(
        p.getId(), p.getPeriodStart(), p.getPeriodEnd(), p.getStatus());
  }
}
