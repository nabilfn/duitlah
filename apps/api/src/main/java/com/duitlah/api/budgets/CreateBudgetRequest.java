package com.duitlah.api.budgets;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code periodYear}/{@code periodMonth} are required only for the default {@code CALENDAR_MONTH}
 * cycle (validated in {@code BudgetService}, not here, since the requirement is conditional on
 * {@code cycleType}) — existing clients that never send {@code cycleType} at all keep working
 * exactly as before. {@code PAYDAY}/{@code CUSTOM} instead require {@code periodStartDate}/{@code
 * periodEndDate} (spec section 21).
 */
public record CreateBudgetRequest(
    UUID categoryId,
    @Min(2000) @Max(3000) Integer periodYear,
    @Min(1) @Max(12) Integer periodMonth,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amountLimit,
    BudgetCycleType cycleType,
    LocalDate periodStartDate,
    LocalDate periodEndDate) {

  public BudgetCycleType cycleTypeOrDefault() {
    return cycleType == null ? BudgetCycleType.CALENDAR_MONTH : cycleType;
  }
}
