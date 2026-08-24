package com.duitlah.api.accounting;

import java.math.BigDecimal;

/**
 * Every account type has a "normal" side that increases its balance — ASSET/EXPENSE increase on the
 * DEBIT side, LIABILITY/EQUITY/REVENUE increase on the CREDIT side. Reports show each account's
 * balance signed relative to its own normal side (so a healthy Sales Revenue account reads as a
 * positive number even though its journal lines are all CREDITs), not relative to raw
 * debit=positive bookkeeping.
 */
final class NormalBalance {

  private NormalBalance() {}

  static BigDecimal signedAmount(AccountType type, JournalDirection direction, BigDecimal amount) {
    boolean debitNormal = type == AccountType.ASSET || type == AccountType.EXPENSE;
    boolean isDebit = direction == JournalDirection.DEBIT;
    boolean increases = debitNormal == isDebit;
    return increases ? amount : amount.negate();
  }
}
