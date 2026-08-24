package com.duitlah.api.budgets;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.finance.Category;
import com.duitlah.api.finance.CategoryResponse;
import com.duitlah.api.finance.CategoryService;
import com.duitlah.api.finance.CategoryType;
import com.duitlah.api.notifications.NotificationService;
import com.duitlah.api.transactions.TransactionRepository;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BudgetService {

  private final BudgetRepository budgets;
  private final CategoryService categoryService;
  private final TransactionRepository transactions;
  private final NotificationService notificationService;

  public BudgetService(
      BudgetRepository budgets,
      CategoryService categoryService,
      TransactionRepository transactions,
      NotificationService notificationService) {
    this.budgets = budgets;
    this.categoryService = categoryService;
    this.transactions = transactions;
    this.notificationService = notificationService;
  }

  public List<BudgetResponse> listForPeriod(UUID userId, int periodYear, int periodMonth) {
    List<Budget> found =
        budgets.findByUserIdAndPeriodYearAndPeriodMonth(
            userId, (short) periodYear, (short) periodMonth);
    Map<UUID, String> categoryNames =
        categoryService.listForUser(userId).stream()
            .collect(Collectors.toMap(CategoryResponse::id, CategoryResponse::name));

    return found.stream()
        .map(
            budget -> {
              LocalDate from = periodStartOf(budget, periodYear, periodMonth);
              LocalDate to = periodEndOf(budget, periodYear, periodMonth);
              BigDecimal spent = spentFor(userId, budget.getCategoryId(), from, to);
              String categoryName =
                  budget.getCategoryId() == null
                      ? "Overall"
                      : categoryNames.getOrDefault(budget.getCategoryId(), "Unknown category");
              return BudgetResponse.of(budget, categoryName, spent);
            })
        .toList();
  }

  /**
   * A CALENDAR_MONTH budget's real period is always the calendar month, regardless of what its
   * (deliberately non-authoritative for that cycle) periodStartDate/periodEndDate columns hold.
   */
  private static LocalDate periodStartOf(Budget budget, int periodYear, int periodMonth) {
    return budget.isCalendarMonth()
        ? LocalDate.of(periodYear, periodMonth, 1)
        : budget.getPeriodStartDate();
  }

  private static LocalDate periodEndOf(Budget budget, int periodYear, int periodMonth) {
    return budget.isCalendarMonth()
        ? LocalDate.of(periodYear, periodMonth, 1).with(TemporalAdjusters.lastDayOfMonth())
        : budget.getPeriodEndDate();
  }

  private BigDecimal spentFor(UUID userId, UUID categoryId, LocalDate from, LocalDate to) {
    if (categoryId == null) {
      return transactions.sumAmountByUserIdAndTypeAndOccurredOnBetween(
          userId, TransactionType.EXPENSE, from, to);
    }
    Category category = categoryService.requireUsable(userId, categoryId, CategoryType.EXPENSE);
    List<UUID> categoryIds = categoryService.expandToSelfAndChildren(category);
    return transactions.sumAmountByUserIdAndTypeAndCategoryIdInAndOccurredOnBetween(
        userId, TransactionType.EXPENSE, categoryIds, from, to);
  }

  @Transactional
  public BudgetResponse create(UUID userId, CreateBudgetRequest request) {
    BudgetCycleType cycleType = request.cycleTypeOrDefault();
    Budget budget =
        cycleType == BudgetCycleType.CALENDAR_MONTH
            ? createCalendarMonthBudget(userId, request)
            : createCustomCycleBudget(userId, request, cycleType);
    budgets.save(budget);

    String categoryName = categoryNameFor(userId, budget.getCategoryId());
    LocalDate from = periodStartOf(budget, budget.getPeriodYear(), budget.getPeriodMonth());
    LocalDate to = periodEndOf(budget, budget.getPeriodYear(), budget.getPeriodMonth());
    BigDecimal spent = spentFor(userId, request.categoryId(), from, to);
    return BudgetResponse.of(budget, categoryName, spent);
  }

  /** Exactly the pre-Phase-3 behavior — untouched, including its own duplicate-budget check. */
  private Budget createCalendarMonthBudget(UUID userId, CreateBudgetRequest request) {
    if (request.periodYear() == null || request.periodMonth() == null) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "PERIOD_REQUIRED", "periodYear and periodMonth are required.");
    }
    YearMonth.of(
        request.periodYear(), request.periodMonth()); // throws DateTimeException if invalid
    short year = (short) request.periodYear().intValue();
    short month = (short) request.periodMonth().intValue();

    if (request.categoryId() == null) {
      if (budgets.existsByUserIdAndCategoryIdIsNullAndPeriodYearAndPeriodMonth(
          userId, year, month)) {
        throw new ConflictException(
            "BUDGET_ALREADY_EXISTS", "You already have an overall budget for this month.");
      }
    } else {
      categoryService.requireUsable(userId, request.categoryId(), CategoryType.EXPENSE);
      if (budgets.existsByUserIdAndCategoryIdAndPeriodYearAndPeriodMonth(
          userId, request.categoryId(), year, month)) {
        throw new ConflictException(
            "BUDGET_ALREADY_EXISTS", "You already have a budget for this category this month.");
      }
    }
    return new Budget(userId, request.categoryId(), year, month, request.amountLimit());
  }

  /**
   * No duplicate-budget check here — "one budget per category per calendar month" doesn't
   * generalize cleanly to arbitrary payday/custom ranges (a user may reasonably want two
   * overlapping custom-period budgets), so this is deliberately permissive rather than guessing at
   * a rule the spec doesn't state.
   */
  private Budget createCustomCycleBudget(
      UUID userId, CreateBudgetRequest request, BudgetCycleType cycleType) {
    if (request.periodStartDate() == null || request.periodEndDate() == null) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "CUSTOM_PERIOD_REQUIRED",
          "periodStartDate and periodEndDate are required for a " + cycleType.name() + " budget.");
    }
    if (!request.periodEndDate().isAfter(request.periodStartDate())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "INVALID_PERIOD", "periodEndDate must be after periodStartDate.");
    }
    if (request.categoryId() != null) {
      categoryService.requireUsable(userId, request.categoryId(), CategoryType.EXPENSE);
    }
    return new Budget(
        userId,
        request.categoryId(),
        cycleType,
        request.periodStartDate(),
        request.periodEndDate(),
        request.amountLimit());
  }

  /**
   * "Notification rules" (V2 Phase 13) — the new {@code BUDGET_EXCEEDED} trigger, evaluated daily
   * by {@link BudgetAlertScheduler} for every budget whose period covers {@code asOf}. Same
   * "notified once per dip, cleared once it resolves" dedup shape as {@code
   * catalog.products.low_stock_notified_at}, just keyed on {@link
   * Budget#getBudgetExceededNotifiedAt()} instead.
   */
  @Transactional
  public void evaluateBudgetAlerts(LocalDate asOf) {
    for (Budget budget : budgets.findAll()) {
      if (!coversDate(budget, asOf)) {
        continue;
      }
      LocalDate from = periodStartOf(budget, asOf.getYear(), asOf.getMonthValue());
      LocalDate to = periodEndOf(budget, asOf.getYear(), asOf.getMonthValue());
      BigDecimal spent = spentFor(budget.getUserId(), budget.getCategoryId(), from, to);
      boolean exceeded = spent.compareTo(budget.getAmountLimit()) > 0;

      if (exceeded && budget.getBudgetExceededNotifiedAt() == null) {
        String categoryName = categoryNameFor(budget.getUserId(), budget.getCategoryId());
        notificationService.notify(
            budget.getUserId(),
            "BUDGET_EXCEEDED",
            categoryName + " budget exceeded",
            "You've spent RM"
                + spent
                + " against your RM"
                + budget.getAmountLimit()
                + " "
                + categoryName
                + " budget for this period.");
        budget.setBudgetExceededNotifiedAt(Instant.now());
        budgets.save(budget);
      } else if (!exceeded && budget.getBudgetExceededNotifiedAt() != null) {
        budget.setBudgetExceededNotifiedAt(null);
        budgets.save(budget);
      }
    }
  }

  private static boolean coversDate(Budget budget, LocalDate date) {
    if (budget.isCalendarMonth()) {
      return budget.getPeriodYear() == date.getYear()
          && budget.getPeriodMonth() == date.getMonthValue();
    }
    return !date.isBefore(budget.getPeriodStartDate()) && !date.isAfter(budget.getPeriodEndDate());
  }

  private String categoryNameFor(UUID userId, UUID categoryId) {
    if (categoryId == null) {
      return "Overall";
    }
    return categoryService.requireUsable(userId, categoryId, CategoryType.EXPENSE).getName();
  }

  @Transactional
  public void delete(UUID userId, UUID budgetId) {
    budgets.delete(requireOwned(userId, budgetId));
  }

  @Transactional
  public BudgetResponse update(UUID userId, UUID budgetId, UpdateBudgetRequest request) {
    Budget budget = requireOwned(userId, budgetId);
    budget.setAmountLimit(request.amountLimit());
    budgets.save(budget);

    LocalDate from = periodStartOf(budget, budget.getPeriodYear(), budget.getPeriodMonth());
    LocalDate to = periodEndOf(budget, budget.getPeriodYear(), budget.getPeriodMonth());
    BigDecimal spent = spentFor(userId, budget.getCategoryId(), from, to);
    String categoryName = categoryNameFor(userId, budget.getCategoryId());
    return BudgetResponse.of(budget, categoryName, spent);
  }

  private Budget requireOwned(UUID userId, UUID budgetId) {
    return budgets
        .findByIdAndUserId(budgetId, userId)
        .orElseThrow(() -> new NotFoundException("BUDGET_NOT_FOUND", "Budget not found."));
  }
}
