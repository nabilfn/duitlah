package com.duitlah.api.analytics;

import com.duitlah.api.finance.AccountService;
import com.duitlah.api.transactions.TransactionRepository;
import com.duitlah.api.transactions.TransactionResponse;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

  private final AccountService accountService;
  private final TransactionRepository transactions;

  public DashboardService(AccountService accountService, TransactionRepository transactions) {
    this.accountService = accountService;
    this.transactions = transactions;
  }

  public DashboardResponse forUser(UUID userId) {
    BigDecimal availableBalance = accountService.totalAvailableBalance(userId);

    LocalDate today = LocalDate.now();
    LocalDate monthStart = today.with(TemporalAdjusters.firstDayOfMonth());
    LocalDate monthEnd = today.with(TemporalAdjusters.lastDayOfMonth());

    BigDecimal monthIncome =
        transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
            userId, TransactionType.INCOME, monthStart, monthEnd);
    BigDecimal monthExpense =
        transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
            userId, TransactionType.EXPENSE, monthStart, monthEnd);

    var recent =
        transactions.findTop10ByUserIdOrderByOccurredOnDescCreatedAtDesc(userId).stream()
            .map(TransactionResponse::from)
            .toList();

    return new DashboardResponse(availableBalance, monthIncome, monthExpense, recent);
  }
}
