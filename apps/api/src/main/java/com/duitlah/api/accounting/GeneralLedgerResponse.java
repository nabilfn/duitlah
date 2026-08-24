package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record GeneralLedgerResponse(
    UUID accountId,
    String accountCode,
    String accountName,
    BigDecimal openingBalance,
    List<GeneralLedgerLineResponse> lines,
    BigDecimal closingBalance) {}
