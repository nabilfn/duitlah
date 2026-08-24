package com.duitlah.api.einvoice;

import java.time.Instant;

/**
 * {@code status} is only ever {@code SUBMITTED} (still pending), {@code VALID}, or {@code INVALID}
 * — a provider never returns any other {@link EInvoiceStatus} from a status check.
 */
public record DocumentStatusResult(
    EInvoiceStatus status, String longId, Instant validatedAt, String invalidReason) {}
