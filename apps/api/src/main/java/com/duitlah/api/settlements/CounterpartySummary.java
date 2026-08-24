package com.duitlah.api.settlements;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * {@code netAmount} is always positive here — which list it's in (owed to me vs. I owe) already
 * says the direction. {@code oldestUnpaidDays} is the age of the longest-outstanding unpaid/
 * partially-paid settlement with this person, matching the product spec's "14 days" / "Today"
 * display (section 34).
 */
public record CounterpartySummary(
    UUID userId, String displayName, BigDecimal netAmount, long oldestUnpaidDays) {}
