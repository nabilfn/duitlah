package com.duitlah.api.reconciliation;

import java.math.BigDecimal;

/**
 * {@code ledgerBalance} is the business account's current computed balance (spec: reconciliation
 * assumes you're working through the most recent statement) — see {@code ReconciliationService}.
 */
public record ReconciliationSummaryResponse(
    long unmatchedCount,
    long matchedCount,
    long createdCount,
    long ignoredCount,
    long splitCount,
    BigDecimal statementEndingBalance,
    BigDecimal ledgerBalance,
    BigDecimal difference) {}
