package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.util.UUID;

public record ParticipantBreakdownResponse(
    UUID participantId,
    String displayName,
    BigDecimal subtotal,
    BigDecimal taxShare,
    BigDecimal serviceShare,
    BigDecimal discountShare,
    BigDecimal roundingShare,
    BigDecimal finalAmount) {}
