package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * {@code net = paid - owed}: positive means this participant is owed money back, negative means
 * they still owe. This is a net position per bill, not a simplified "who owes whom" transfer graph
 * across multiple bills/payers -- that's the {@code settlements} module's job (Phase 9), same
 * boundary already drawn for {@code groups} (see docs/database.md).
 */
public record BillBalanceResponse(
    UUID participantId, String displayName, BigDecimal paid, BigDecimal owed, BigDecimal net) {}
