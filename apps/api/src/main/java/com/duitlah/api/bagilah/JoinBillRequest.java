package com.duitlah.api.bagilah;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * {@code guestName} is required only when the requester has no valid session (see {@link
 * BillController#joinBill}) — an already-logged-in user joins as themselves and doesn't need one.
 */
public record JoinBillRequest(@NotBlank String token, @Size(max = 120) String guestName) {}
