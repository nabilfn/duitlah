package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.util.UUID;

public record BalanceSheetLineResponse(
    UUID accountId, String accountCode, String accountName, BigDecimal amount) {}
