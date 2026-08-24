package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record GroupGoalContributionResponse(
    UUID id,
    UUID userId,
    String userDisplayName,
    BigDecimal amount,
    LocalDate occurredOn,
    String note) {}
