package com.duitlah.api.budgets;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * categoryId null = the overall monthly budget, not tied to any one category. {@code
 * periodYear}/{@code periodMonth} remain authoritative for every {@code CALENDAR_MONTH}-cycle
 * budget (every budget created before V2 Phase 3, and any created after it without specifying a
 * cycle) — {@code periodStartDate}/{@code periodEndDate} are only used, and only required, for
 * {@code PAYDAY}/{@code CUSTOM} cycles (spec section 21). See {@link BudgetCycleType}.
 */
@Entity
@Table(name = "budgets")
@Getter
@Setter
@NoArgsConstructor
public class Budget extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "category_id")
  private UUID categoryId;

  @Column(name = "period_year", nullable = false)
  private short periodYear;

  @Column(name = "period_month", nullable = false)
  private short periodMonth;

  @Column(name = "amount_limit", nullable = false)
  private BigDecimal amountLimit;

  @Enumerated(EnumType.STRING)
  @Column(name = "cycle_type", nullable = false)
  private BudgetCycleType cycleType;

  @Column(name = "period_start_date")
  private LocalDate periodStartDate;

  @Column(name = "period_end_date")
  private LocalDate periodEndDate;

  @Column(name = "budget_exceeded_notified_at")
  private Instant budgetExceededNotifiedAt;

  public Budget(
      UUID userId, UUID categoryId, int periodYear, int periodMonth, BigDecimal amountLimit) {
    this.userId = userId;
    this.categoryId = categoryId;
    this.periodYear = (short) periodYear;
    this.periodMonth = (short) periodMonth;
    this.amountLimit = amountLimit;
    this.cycleType = BudgetCycleType.CALENDAR_MONTH;
  }

  public Budget(
      UUID userId,
      UUID categoryId,
      BudgetCycleType cycleType,
      LocalDate periodStartDate,
      LocalDate periodEndDate,
      BigDecimal amountLimit) {
    this.userId = userId;
    this.categoryId = categoryId;
    this.periodYear = (short) periodStartDate.getYear();
    this.periodMonth = (short) periodStartDate.getMonthValue();
    this.amountLimit = amountLimit;
    this.cycleType = cycleType;
    this.periodStartDate = periodStartDate;
    this.periodEndDate = periodEndDate;
  }

  public boolean isCalendarMonth() {
    return cycleType == BudgetCycleType.CALENDAR_MONTH;
  }
}
