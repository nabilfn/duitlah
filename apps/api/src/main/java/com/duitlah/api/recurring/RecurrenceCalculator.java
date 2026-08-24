package com.duitlah.api.recurring;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Pure date arithmetic for recurring-transaction schedules — no Spring/JPA, directly unit-testable,
 * the same shape as {@code BagilahCalculationEngine}/{@code DebtSimplifier}. Kept separate from
 * {@code RecurringTransactionService} so the schedule math (which callers actually need to trust)
 * can be tested without a database.
 */
public final class RecurrenceCalculator {

  private RecurrenceCalculator() {}

  /** The next occurrence after {@code date}, stepping by one period of the given frequency. */
  public static LocalDate advance(
      LocalDate date, RecurrenceFrequency frequency, int intervalCount) {
    return switch (frequency) {
      case DAILY -> date.plusDays(intervalCount);
      case WEEKLY -> date.plusWeeks(intervalCount);
      case MONTHLY -> date.plusMonths(intervalCount);
      case YEARLY -> date.plusYears(intervalCount);
    };
  }

  /**
   * Every occurrence date starting from {@code from} that falls within {@code [rangeStart,
   * rangeEnd]}, stopping early if {@code endDate} is reached. {@code from} is expected to already
   * be "the next upcoming occurrence" (i.e. a rule's own {@code nextOccurrenceDate}, which the
   * materialization job keeps current) — never far in the past — so this is always a small, bounded
   * loop (at most ~31 iterations for a daily rule over one calendar month), not an unbounded scan
   * back to a rule's original start date.
   */
  public static List<LocalDate> occurrencesBetween(
      LocalDate from,
      RecurrenceFrequency frequency,
      int intervalCount,
      LocalDate endDate,
      LocalDate rangeStart,
      LocalDate rangeEnd) {
    List<LocalDate> occurrences = new ArrayList<>();
    LocalDate cursor = from;
    while (!cursor.isAfter(rangeEnd) && (endDate == null || !cursor.isAfter(endDate))) {
      if (!cursor.isBefore(rangeStart)) {
        occurrences.add(cursor);
      }
      cursor = advance(cursor, frequency, intervalCount);
    }
    return occurrences;
  }
}
