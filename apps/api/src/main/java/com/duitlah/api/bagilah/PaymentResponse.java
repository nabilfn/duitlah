package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.util.UUID;

public record PaymentResponse(UUID participantId, String displayName, BigDecimal amountPaid) {}
