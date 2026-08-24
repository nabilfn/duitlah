package com.duitlah.api.settlements;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record SettlementPaymentResponse(
    UUID id,
    BigDecimal amount,
    UUID recordedByUserId,
    String recordedByDisplayName,
    String note,
    Instant paidAt) {}
