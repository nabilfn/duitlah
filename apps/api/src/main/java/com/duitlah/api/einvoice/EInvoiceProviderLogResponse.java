package com.duitlah.api.einvoice;

import java.time.Instant;
import java.util.UUID;

public record EInvoiceProviderLogResponse(
    UUID id,
    EInvoiceOperation operation,
    String providerName,
    boolean success,
    String detail,
    Instant createdAt) {

  public static EInvoiceProviderLogResponse of(EInvoiceProviderLog log) {
    return new EInvoiceProviderLogResponse(
        log.getId(),
        log.getOperation(),
        log.getProviderName(),
        log.isSuccess(),
        log.getDetail(),
        log.getCreatedAt());
  }
}
