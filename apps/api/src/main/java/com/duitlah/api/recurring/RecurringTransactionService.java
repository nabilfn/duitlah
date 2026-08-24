package com.duitlah.api.recurring;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.finance.Account;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.finance.CategoryService;
import com.duitlah.api.finance.CategoryType;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionRepository;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RecurringTransactionService {

  private static final BigDecimal WEEKS_PER_MONTH = new BigDecimal("4.345");
  private static final BigDecimal DAYS_PER_MONTH = new BigDecimal("30");
  private static final BigDecimal MONTHS_PER_YEAR = new BigDecimal("12");

  private final RecurringTransactionRepository recurringTransactions;
  private final TransactionRepository transactions;
  private final AccountService accountService;
  private final CategoryService categoryService;

  public RecurringTransactionService(
      RecurringTransactionRepository recurringTransactions,
      TransactionRepository transactions,
      AccountService accountService,
      CategoryService categoryService) {
    this.recurringTransactions = recurringTransactions;
    this.transactions = transactions;
    this.accountService = accountService;
    this.categoryService = categoryService;
  }

  @Transactional
  public RecurringTransactionResponse create(
      UUID userId, CreateRecurringTransactionRequest request) {
    Account account = accountService.requireOwned(userId, request.accountId());
    if (request.categoryId() != null) {
      CategoryType categoryType =
          request.type() == TransactionType.INCOME ? CategoryType.INCOME : CategoryType.EXPENSE;
      categoryService.requireUsable(userId, request.categoryId(), categoryType);
    }

    TransactionDirection direction =
        request.type() == TransactionType.INCOME
            ? TransactionDirection.IN
            : TransactionDirection.OUT;
    RecurringTransaction rule =
        new RecurringTransaction(
            userId,
            account.getId(),
            request.type(),
            direction,
            request.categoryId(),
            request.amount(),
            request.merchant(),
            request.description(),
            request.notes(),
            request.frequency(),
            request.intervalCountOrDefault(),
            request.startDate(),
            request.endDate(),
            request.isSubscription());
    recurringTransactions.save(rule);
    return RecurringTransactionResponse.from(rule);
  }

  public List<RecurringTransactionResponse> list(UUID userId) {
    return recurringTransactions.findByUserIdOrderByNextOccurrenceDateAsc(userId).stream()
        .map(RecurringTransactionResponse::from)
        .toList();
  }

  public RecurringTransactionResponse get(UUID userId, UUID id) {
    return RecurringTransactionResponse.from(requireOwned(userId, id));
  }

  public SubscriptionsSummaryResponse subscriptionsSummary(UUID userId) {
    List<RecurringTransaction> subs =
        recurringTransactions
            .findByUserIdAndSubscriptionTrueAndActiveTrueOrderByNextOccurrenceDateAsc(userId);
    BigDecimal total =
        subs.stream()
            .map(RecurringTransactionService::monthlyEquivalent)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .setScale(2, RoundingMode.HALF_UP);
    return new SubscriptionsSummaryResponse(
        total, subs.stream().map(RecurringTransactionResponse::from).toList());
  }

  private static BigDecimal monthlyEquivalent(RecurringTransaction rule) {
    return switch (rule.getFrequency()) {
      case DAILY ->
          rule.getAmount()
              .multiply(DAYS_PER_MONTH)
              .divide(BigDecimal.valueOf(rule.getIntervalCount()), 4, RoundingMode.HALF_UP);
      case WEEKLY ->
          rule.getAmount()
              .multiply(WEEKS_PER_MONTH)
              .divide(BigDecimal.valueOf(rule.getIntervalCount()), 4, RoundingMode.HALF_UP);
      case MONTHLY ->
          rule.getAmount()
              .divide(BigDecimal.valueOf(rule.getIntervalCount()), 4, RoundingMode.HALF_UP);
      case YEARLY ->
          rule.getAmount()
              .divide(
                  MONTHS_PER_YEAR.multiply(BigDecimal.valueOf(rule.getIntervalCount())),
                  4,
                  RoundingMode.HALF_UP);
    };
  }

  @Transactional
  public RecurringTransactionResponse update(
      UUID userId, UUID id, UpdateRecurringTransactionRequest request) {
    RecurringTransaction rule = requireOwned(userId, id);
    if (request.categoryId() != null) {
      CategoryType categoryType =
          rule.getType() == TransactionType.INCOME ? CategoryType.INCOME : CategoryType.EXPENSE;
      categoryService.requireUsable(userId, request.categoryId(), categoryType);
    }
    rule.setCategoryId(request.categoryId());
    rule.setAmount(request.amount());
    rule.setMerchant(request.merchant());
    rule.setDescription(request.description());
    rule.setNotes(request.notes());
    rule.setFrequency(request.frequency());
    rule.setIntervalCount(request.intervalCountOrDefault());
    rule.setEndDate(request.endDate());
    rule.setSubscription(request.isSubscription());
    rule.setActive(request.active());
    recurringTransactions.save(rule);
    return RecurringTransactionResponse.from(rule);
  }

  @Transactional
  public void delete(UUID userId, UUID id) {
    recurringTransactions.delete(requireOwned(userId, id));
  }

  /**
   * Creates a real {@code Transaction} for every elapsed occurrence of every active rule due on or
   * before {@code asOf}, advancing each rule's {@code nextOccurrenceDate} as it goes. Runs inside
   * one transaction per call (invoked daily by {@link RecurringTransactionScheduler}, or directly
   * in tests) rather than per-rule, since a missed run of a day or two should "catch up" by posting
   * one transaction per elapsed period rather than silently skipping them.
   */
  @Transactional
  public int materializeAllDue(LocalDate asOf) {
    List<RecurringTransaction> due =
        recurringTransactions.findByActiveTrueAndNextOccurrenceDateLessThanEqual(asOf);
    int created = 0;
    for (RecurringTransaction rule : due) {
      while (rule.isActive() && !rule.getNextOccurrenceDate().isAfter(asOf)) {
        Transaction transaction =
            new Transaction(
                rule.getUserId(),
                rule.getAccountId(),
                rule.getType(),
                rule.getDirection(),
                rule.getCategoryId(),
                null,
                rule.getAmount(),
                rule.getMerchant(),
                rule.getDescription(),
                rule.getNotes(),
                rule.getNextOccurrenceDate());
        transaction.setRecurringTransactionId(rule.getId());
        transactions.save(transaction);
        created++;

        LocalDate next =
            RecurrenceCalculator.advance(
                rule.getNextOccurrenceDate(), rule.getFrequency(), rule.getIntervalCount());
        rule.setNextOccurrenceDate(next);
        if (rule.getEndDate() != null && next.isAfter(rule.getEndDate())) {
          rule.setActive(false);
        }
      }
      recurringTransactions.save(rule);
    }
    return created;
  }

  private RecurringTransaction requireOwned(UUID userId, UUID id) {
    return recurringTransactions
        .findByIdAndUserId(id, userId)
        .orElseThrow(
            () ->
                new NotFoundException(
                    "RECURRING_TRANSACTION_NOT_FOUND", "Recurring transaction not found."));
  }
}
