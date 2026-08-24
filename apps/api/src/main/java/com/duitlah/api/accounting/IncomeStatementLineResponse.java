package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.util.UUID;

public record IncomeStatementLineResponse(
    UUID accountId, String accountCode, String accountName, BigDecimal amount) {}
