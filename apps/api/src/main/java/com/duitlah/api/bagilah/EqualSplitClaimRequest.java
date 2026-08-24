package com.duitlah.api.bagilah;

import jakarta.validation.constraints.NotEmpty;
import java.util.List;
import java.util.UUID;

/**
 * Convenience over {@link ClaimRequest}: splits the item's total_price evenly (to the cent) across
 * these participants, replacing any existing claims on the item.
 */
public record EqualSplitClaimRequest(@NotEmpty List<UUID> participantIds) {}
