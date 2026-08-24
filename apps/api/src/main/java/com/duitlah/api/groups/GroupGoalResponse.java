package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record GroupGoalResponse(
    UUID id,
    String name,
    BigDecimal targetAmount,
    LocalDate targetDate,
    BigDecimal currentAmount,
    BigDecimal remaining,
    BigDecimal percentage,
    boolean archived,
    List<MemberContribution> byMember) {

  public record MemberContribution(UUID userId, String displayName, BigDecimal totalContributed) {}

  /** {@code percentage} is not clamped to 100 — an overachieved goal legitimately reads >100%. */
  public static GroupGoalResponse of(
      GroupGoal goal, BigDecimal currentAmount, List<MemberContribution> byMember) {
    BigDecimal remaining = goal.getTargetAmount().subtract(currentAmount);
    BigDecimal percentage =
        goal.getTargetAmount().signum() <= 0
            ? BigDecimal.ZERO
            : currentAmount
                .divide(goal.getTargetAmount(), 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));
    return new GroupGoalResponse(
        goal.getId(),
        goal.getName(),
        goal.getTargetAmount(),
        goal.getTargetDate(),
        currentAmount,
        remaining,
        percentage,
        goal.isArchived(),
        byMember);
  }
}
