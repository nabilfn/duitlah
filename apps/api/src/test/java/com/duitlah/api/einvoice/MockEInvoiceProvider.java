package com.duitlah.api.einvoice;

import java.time.Instant;
import java.util.UUID;

/**
 * Spec section 55's own named provider — "MockEInvoiceProvider // development/tests only" —
 * deliberately not shipped under {@code src/main}. Deterministic: always accepts a submission and
 * always reports the configured {@link #nextStatus} on a status check, so {@code
 * EInvoiceWorkflowFlowTests} can exercise the full happy path without a real LHDN connection,
 * matching {@code UnavailableEInvoiceProvider}'s own honesty guarantee in production.
 */
public class MockEInvoiceProvider implements EInvoiceProvider {

  public volatile boolean available = true;
  public volatile EInvoiceStatus nextStatus = EInvoiceStatus.VALID;
  public volatile String nextInvalidReason = "Mock validation failure";

  @Override
  public String providerName() {
    return "MOCK";
  }

  @Override
  public boolean isAvailable() {
    return available;
  }

  @Override
  public SubmissionResult submit(EInvoicePayload payload) {
    return new SubmissionResult(
        true, "MOCKSUB-" + UUID.randomUUID(), "MOCKDOC-" + UUID.randomUUID(), null);
  }

  @Override
  public DocumentStatusResult checkStatus(String documentUuid) {
    if (nextStatus == EInvoiceStatus.INVALID) {
      return new DocumentStatusResult(
          EInvoiceStatus.INVALID, null, Instant.now(), nextInvalidReason);
    }
    return new DocumentStatusResult(
        EInvoiceStatus.VALID, "MOCKLONGID-" + UUID.randomUUID(), Instant.now(), null);
  }

  @Override
  public void cancel(String documentUuid, String reason) {}

  @Override
  public void reject(String documentUuid, String reason) {}
}
