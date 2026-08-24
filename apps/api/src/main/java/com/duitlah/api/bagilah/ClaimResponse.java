package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.util.UUID;

public record ClaimResponse(
    UUID id, UUID participantId, String displayName, ClaimType claimType, BigDecimal value) {}
