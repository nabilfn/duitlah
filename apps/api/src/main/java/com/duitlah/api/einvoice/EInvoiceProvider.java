package com.duitlah.api.einvoice;

/** Spec section 55's own named abstraction. See package-info. */
public interface EInvoiceProvider {

  String providerName();

  /**
   * Whether this provider can actually be called right now — false whenever real credentials aren't
   * configured. Callers must check this and fail clearly rather than attempt a call that would only
   * fabricate a result.
   */
  boolean isAvailable();

  SubmissionResult submit(EInvoicePayload payload);

  DocumentStatusResult checkStatus(String documentUuid);

  void cancel(String documentUuid, String reason);

  void reject(String documentUuid, String reason);
}
