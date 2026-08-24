package com.duitlah.api.einvoice;

import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Records a provider interaction in its own, independent transaction ({@code REQUIRES_NEW}) so the
 * log entry survives even when the caller's own transaction subsequently rolls back (e.g. a
 * failed/unavailable attempt that throws) — "all provider interactions must be auditable" (spec
 * section 56) means a failed attempt is exactly the kind of interaction that must not be lost.
 */
@Service
public class EInvoiceProviderLogRecorder {

  private final EInvoiceProviderLogRepository providerLogs;

  public EInvoiceProviderLogRecorder(EInvoiceProviderLogRepository providerLogs) {
    this.providerLogs = providerLogs;
  }

  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void record(
      UUID einvoiceDocumentId,
      EInvoiceOperation operation,
      String providerName,
      boolean success,
      String detail) {
    providerLogs.save(
        new EInvoiceProviderLog(einvoiceDocumentId, operation, providerName, success, detail));
  }
}
