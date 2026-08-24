package com.duitlah.api.bagilah;

import java.util.UUID;

/**
 * {@code guestToken} is set only for a guest join (see {@code bill_guest_sessions}) — an
 * authenticated user joining via the same link already has a real session and gets {@code null}
 * here, since they just navigate to the normal `/bagilah/{billId}` page with their existing token.
 */
public record JoinBillResponse(
    UUID billId, UUID participantId, String displayName, boolean guest, String guestToken) {}
