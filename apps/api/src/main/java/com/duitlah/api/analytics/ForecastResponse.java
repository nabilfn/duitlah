package com.duitlah.api.analytics;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Cash-flow forecast to the end of the current month. The three components of the projection are
 * kept separate rather than pre-summed into one "confidence-free" number, per the master spec's
 * explicit instruction to distinguish confirmed, scheduled, and predicted rather than "pretend
 * predictions are guaranteed":
 *
 * <ul>
 *   <li>{@code currentBalance} — confirmed: the real, computed balance today.
 *   <li>{@code scheduledIncome}/{@code scheduledExpense} — scheduled: known recurring transactions
 *       due between now and {@code targetDate}.
 *   <li>{@code predictedVariableExpense} — predicted: a historical average, prorated for the
 *       remaining days in the month, of spending that ISN'T tied to a recurring rule.
 * </ul>
 */
public record ForecastResponse(
    BigDecimal currentBalance,
    LocalDate asOfDate,
    LocalDate targetDate,
    BigDecimal scheduledIncome,
    BigDecimal scheduledExpense,
    BigDecimal predictedVariableExpense,
    BigDecimal projectedBalance,
    String disclaimer) {}
