package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record IncomeStatementResponse(
    LocalDate from,
    LocalDate to,
    List<IncomeStatementLineResponse> revenueLines,
    BigDecimal totalRevenue,
    List<IncomeStatementLineResponse> expenseLines,
    BigDecimal totalExpenses,
    BigDecimal netIncome) {}
