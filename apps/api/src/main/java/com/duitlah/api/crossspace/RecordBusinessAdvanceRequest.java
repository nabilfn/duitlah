package com.duitlah.api.crossspace;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code personalTransactionId} must already exist and belong to the caller (spec section 58 — an
 * existing Personal outflow gets linked, never synthesized). {@code expenseChartOfAccountsId} is
 * the Business expense account this advance funded.
 */
public record RecordBusinessAdvanceRequest(
    @NotNull UUID personalTransactionId,
    @NotNull UUID expenseChartOfAccountsId,
    @NotNull @Positive BigDecimal amount,
    @NotNull LocalDate occurredOn,
    String description) {}
