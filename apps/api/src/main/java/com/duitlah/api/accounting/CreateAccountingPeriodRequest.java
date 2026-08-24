package com.duitlah.api.accounting;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record CreateAccountingPeriodRequest(
    @NotNull LocalDate periodStart, @NotNull LocalDate periodEnd) {}
