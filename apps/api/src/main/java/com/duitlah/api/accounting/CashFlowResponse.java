package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * A direct-method summary over accounts flagged {@code cashEquivalent} — total in, total out, and
 * the resulting change in cash for the period. Formal Operating/Investing/Financing categorization
 * is a documented simplification this phase doesn't attempt (see {@code CashFlowService}).
 */
public record CashFlowResponse(
    LocalDate from,
    LocalDate to,
    BigDecimal openingCash,
    BigDecimal totalCashIn,
    BigDecimal totalCashOut,
    BigDecimal netChange,
    BigDecimal closingCash) {}
