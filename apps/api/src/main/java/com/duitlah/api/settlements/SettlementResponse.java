package com.duitlah.api.settlements;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record SettlementResponse(
    UUID id,
    UUID fromUserId,
    String fromDisplayName,
    UUID toUserId,
    String toDisplayName,
    BigDecimal amount,
    BigDecimal amountPaid,
    BigDecimal amountRemaining,
    SettlementStatus status,
    SourceType sourceType,
    UUID sourceId,
    Instant createdAt,
    PaymentHandoffLink handoff) {}
