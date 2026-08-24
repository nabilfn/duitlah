package com.duitlah.api.analytics;

import com.duitlah.api.transactions.TransactionDirection;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * One calendar cell's worth of financial activity — either a real, already-posted transaction
 * ({@code confirmed = true}) or a recurring rule's projected future occurrence ({@code confirmed =
 * false}), computed on the fly and never persisted. See {@code AnalyticsService#calendar}.
 */
public record CalendarEntryResponse(
    LocalDate date,
    boolean confirmed,
    TransactionType type,
    TransactionDirection direction,
    BigDecimal amount,
    String merchant,
    String description) {}
