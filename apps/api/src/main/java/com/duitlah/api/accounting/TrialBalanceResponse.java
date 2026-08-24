package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record TrialBalanceResponse(
    LocalDate asOf,
    List<TrialBalanceLineResponse> lines,
    BigDecimal totalDebit,
    BigDecimal totalCredit) {}
