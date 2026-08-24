package com.duitlah.api.recurring;

import java.math.BigDecimal;
import java.util.List;

/**
 * {@code estimatedMonthlyTotal} normalizes every active subscription's own frequency onto a monthly
 * basis (DAILY×30, WEEKLY×4.345, MONTHLY×1, YEARLY÷12) purely for this one summary number — never
 * for anything transactional. It's an estimate, not a reconciled figure, so it's fine for it to not
 * sum exactly to any real month's actual postings.
 */
public record SubscriptionsSummaryResponse(
    BigDecimal estimatedMonthlyTotal, List<RecurringTransactionResponse> subscriptions) {}
