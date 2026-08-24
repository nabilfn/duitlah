package com.duitlah.api.goals;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ContributionResponse(UUID id, BigDecimal amount, LocalDate occurredOn, String note) {

  public static ContributionResponse from(GoalContribution c) {
    return new ContributionResponse(c.getId(), c.getAmount(), c.getOccurredOn(), c.getNote());
  }
}
