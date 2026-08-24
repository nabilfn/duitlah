package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record BalanceSheetResponse(
    LocalDate asOf,
    List<BalanceSheetLineResponse> assets,
    BigDecimal totalAssets,
    List<BalanceSheetLineResponse> liabilities,
    BigDecimal totalLiabilities,
    List<BalanceSheetLineResponse> equity,
    BigDecimal totalEquity,
    BigDecimal currentEarnings,
    BigDecimal totalLiabilitiesAndEquity) {}
