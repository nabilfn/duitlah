package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.util.UUID;

public record TrialBalanceLineResponse(
    UUID accountId,
    String accountCode,
    String accountName,
    AccountType type,
    BigDecimal debit,
    BigDecimal credit) {}
