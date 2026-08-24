package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.util.List;

/**
 * Before a bill is finalized this is computed live from current claims (so the owner sees the
 * effect of each claim as they make it); after finalization it's read back from the frozen {@code
 * bill_final_amounts} snapshot instead of being recomputed.
 */
public record BreakdownResponse(
    boolean valid,
    List<ItemIssueResponse> issues,
    BigDecimal subtotal,
    BigDecimal computedTotal,
    BigDecimal roundingAdjustment,
    List<ParticipantBreakdownResponse> participants) {}
