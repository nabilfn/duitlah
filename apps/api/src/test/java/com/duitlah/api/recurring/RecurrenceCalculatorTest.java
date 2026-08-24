package com.duitlah.api.recurring;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.LocalDate;
import java.util.List;
import org.junit.jupiter.api.Test;

class RecurrenceCalculatorTest {

  @Test
  void dailyAdvancesByIntervalCount() {
    LocalDate date = LocalDate.of(2026, 8, 1);
    assertThat(RecurrenceCalculator.advance(date, RecurrenceFrequency.DAILY, 1))
        .isEqualTo(LocalDate.of(2026, 8, 2));
    assertThat(RecurrenceCalculator.advance(date, RecurrenceFrequency.DAILY, 3))
        .isEqualTo(LocalDate.of(2026, 8, 4));
  }

  @Test
  void weeklyAdvancesBySevenDaysPerInterval() {
    LocalDate date = LocalDate.of(2026, 8, 1);
    assertThat(RecurrenceCalculator.advance(date, RecurrenceFrequency.WEEKLY, 1))
        .isEqualTo(LocalDate.of(2026, 8, 8));
    assertThat(RecurrenceCalculator.advance(date, RecurrenceFrequency.WEEKLY, 2))
        .isEqualTo(LocalDate.of(2026, 8, 15));
  }

  @Test
  void monthlyPreservesDayOfMonthAcrossMonthBoundaries() {
    LocalDate date = LocalDate.of(2026, 1, 31);
    // Feb has no 31st -- java.time clamps to Feb 28/29, same as LocalDate.plusMonths always does.
    assertThat(RecurrenceCalculator.advance(date, RecurrenceFrequency.MONTHLY, 1))
        .isEqualTo(LocalDate.of(2026, 2, 28));
  }

  @Test
  void yearlyAdvancesByIntervalCountYears() {
    LocalDate date = LocalDate.of(2026, 8, 20);
    assertThat(RecurrenceCalculator.advance(date, RecurrenceFrequency.YEARLY, 2))
        .isEqualTo(LocalDate.of(2028, 8, 20));
  }

  @Test
  void occurrencesBetweenIncludesOnlyDatesWithinRange() {
    List<LocalDate> occurrences =
        RecurrenceCalculator.occurrencesBetween(
            LocalDate.of(2026, 8, 1),
            RecurrenceFrequency.WEEKLY,
            1,
            null,
            LocalDate.of(2026, 8, 1),
            LocalDate.of(2026, 8, 31));

    assertThat(occurrences)
        .containsExactly(
            LocalDate.of(2026, 8, 1),
            LocalDate.of(2026, 8, 8),
            LocalDate.of(2026, 8, 15),
            LocalDate.of(2026, 8, 22),
            LocalDate.of(2026, 8, 29));
  }

  @Test
  void occurrencesBetweenExcludesDatesBeforeRangeStart() {
    // A rule whose next occurrence is before the queried range (e.g. forecasting "tomorrow
    // onward" for a rule due today) should only report occurrences from rangeStart forward.
    List<LocalDate> occurrences =
        RecurrenceCalculator.occurrencesBetween(
            LocalDate.of(2026, 8, 20),
            RecurrenceFrequency.DAILY,
            1,
            null,
            LocalDate.of(2026, 8, 22),
            LocalDate.of(2026, 8, 24));

    assertThat(occurrences)
        .containsExactly(
            LocalDate.of(2026, 8, 22), LocalDate.of(2026, 8, 23), LocalDate.of(2026, 8, 24));
  }

  @Test
  void occurrencesBetweenStopsAtEndDate() {
    List<LocalDate> occurrences =
        RecurrenceCalculator.occurrencesBetween(
            LocalDate.of(2026, 8, 1),
            RecurrenceFrequency.DAILY,
            1,
            LocalDate.of(2026, 8, 3),
            LocalDate.of(2026, 8, 1),
            LocalDate.of(2026, 8, 31));

    assertThat(occurrences)
        .containsExactly(
            LocalDate.of(2026, 8, 1), LocalDate.of(2026, 8, 2), LocalDate.of(2026, 8, 3));
  }

  @Test
  void occurrencesBetweenReturnsEmptyWhenRuleEndsBeforeRangeStarts() {
    List<LocalDate> occurrences =
        RecurrenceCalculator.occurrencesBetween(
            LocalDate.of(2026, 1, 1),
            RecurrenceFrequency.MONTHLY,
            1,
            LocalDate.of(2026, 1, 1),
            LocalDate.of(2026, 8, 1),
            LocalDate.of(2026, 8, 31));

    assertThat(occurrences).isEmpty();
  }
}
