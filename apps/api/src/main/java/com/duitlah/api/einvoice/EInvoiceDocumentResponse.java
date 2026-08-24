package com.duitlah.api.einvoice;

import java.time.Instant;
import java.util.UUID;

public record EInvoiceDocumentResponse(
    UUID id,
    UUID invoiceId,
    EInvoiceStatus status,
    String submissionUid,
    String documentUuid,
    String longId,
    Instant validatedAt,
    String invalidReason,
    Instant cancelledAt,
    String cancellationReason,
    Instant rejectedAt,
    String rejectionReason,
    Instant createdAt) {

  public static EInvoiceDocumentResponse of(EInvoiceDocument doc) {
    return new EInvoiceDocumentResponse(
        doc.getId(),
        doc.getInvoiceId(),
        doc.getStatus(),
        doc.getSubmissionUid(),
        doc.getDocumentUuid(),
        doc.getLongId(),
        doc.getValidatedAt(),
        doc.getInvalidReason(),
        doc.getCancelledAt(),
        doc.getCancellationReason(),
        doc.getRejectedAt(),
        doc.getRejectionReason(),
        doc.getCreatedAt());
  }
}
