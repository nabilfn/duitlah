package com.duitlah.api.subscriptions;

import java.time.Instant;

/**
 * {@code maxActiveGroups}/{@code maxReceiptScansPerMonth} are null for PLUS (unlimited) and a
 * concrete number for FREE — see {@link SubscriptionService} for where those limits are defined and
 * enforced. {@code status}/{@code expiresAt} are null when the user has never had a subscription
 * row at all (the common FREE case).
 */
public record EntitlementResponse(
    SubscriptionTier tier,
    SubscriptionStatus status,
    Instant expiresAt,
    Integer maxActiveGroups,
    int activeGroupCount,
    Integer maxReceiptScansPerMonth,
    int receiptScansThisMonth) {}
