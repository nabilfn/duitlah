package com.duitlah.api.bagilah;

import jakarta.validation.constraints.Size;
import java.util.UUID;

/**
 * Exactly one of {@code userId}/{@code guestName} must be set — validated in {@link BillService}.
 */
public record AddParticipantRequest(UUID userId, @Size(max = 120) String guestName) {}
