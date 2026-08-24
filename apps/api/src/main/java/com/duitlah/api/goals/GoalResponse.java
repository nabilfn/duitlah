package com.duitlah.api.goals;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.UUID;

public record GoalResponse(
    UUID id,
    String name,
    GoalType type,
    BigDecimal targetAmount,
    LocalDate targetDate,
    BigDecimal currentAmount,
    BigDecimal remaining,
    BigDecimal percentage,
    boolean archived) {

  /** {@code percentage} is not clamped to 100 — an overachieved goal legitimately reads >100%. */
  public static GoalResponse of(Goal goal, BigDecimal currentAmount) {
    BigDecimal remaining = goal.getTargetAmount().subtract(currentAmount);
    BigDecimal percentage =
        goal.getTargetAmount().signum() <= 0
            ? BigDecimal.ZERO
            : currentAmount
                .divide(goal.getTargetAmount(), 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));
    return new GoalResponse(
        goal.getId(),
        goal.getName(),
        goal.getType(),
        goal.getTargetAmount(),
        goal.getTargetDate(),
        currentAmount,
        remaining,
        percentage,
        goal.isArchived());
  }
}
