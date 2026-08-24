package com.duitlah.api.analytics;

import com.duitlah.api.transactions.TransactionResponse;
import java.math.BigDecimal;
import java.util.List;

public record DashboardResponse(
    BigDecimal availableBalance,
    BigDecimal monthIncome,
    BigDecimal monthExpense,
    List<TransactionResponse> recentTransactions) {}
