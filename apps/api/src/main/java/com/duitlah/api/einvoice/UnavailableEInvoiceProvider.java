package com.duitlah.api.einvoice;

import com.duitlah.api.common.error.ApiException;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

/**
 * The default provider in every environment until a space configures real LHDN-issued credentials
 * (spec section 55: "Production must never return fake success"). Every method fails clearly and
 * immediately rather than fabricating a submission, a valid status, or a successful cancellation —
 * the caller ({@code EInvoiceService}) surfaces this as a real, honest {@code 503
 * EINVOICE_PROVIDER_UNAVAILABLE} rather than silently succeeding.
 */
@Service
@ConditionalOnProperty(
    name = "duitlah.myinvois.enabled",
    havingValue = "false",
    matchIfMissing = true)
public class UnavailableEInvoiceProvider implements EInvoiceProvider {

  @Override
  public String providerName() {
    return "UNAVAILABLE";
  }

  @Override
  public boolean isAvailable() {
    return false;
  }

  @Override
  public SubmissionResult submit(EInvoicePayload payload) {
    throw unavailable();
  }

  @Override
  public DocumentStatusResult checkStatus(String documentUuid) {
    throw unavailable();
  }

  @Override
  public void cancel(String documentUuid, String reason) {
    throw unavailable();
  }

  @Override
  public void reject(String documentUuid, String reason) {
    throw unavailable();
  }

  private ApiException unavailable() {
    return new ApiException(
        HttpStatus.SERVICE_UNAVAILABLE,
        "EINVOICE_PROVIDER_UNAVAILABLE",
        "MyInvois isn't configured for this environment yet — no e-Invoice document was submitted or changed.");
  }
}
