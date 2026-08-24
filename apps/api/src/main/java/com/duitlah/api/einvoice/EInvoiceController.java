package com.duitlah.api.einvoice;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EInvoiceController {

  private final EInvoiceService einvoiceService;

  public EInvoiceController(EInvoiceService einvoiceService) {
    this.einvoiceService = einvoiceService;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/prepare")
  public EInvoiceDocumentResponse prepare(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return einvoiceService.prepare(userId, spaceId, invoiceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/submit")
  public EInvoiceDocumentResponse submit(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return einvoiceService.submit(userId, spaceId, invoiceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/sync-status")
  public EInvoiceDocumentResponse syncStatus(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return einvoiceService.syncStatus(userId, spaceId, invoiceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/cancel")
  public EInvoiceDocumentResponse cancel(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId,
      @Valid @RequestBody CancelEInvoiceRequest request) {
    return einvoiceService.cancel(userId, spaceId, invoiceId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/reject")
  public EInvoiceDocumentResponse reject(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId,
      @Valid @RequestBody RejectEInvoiceRequest request) {
    return einvoiceService.reject(userId, spaceId, invoiceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice")
  public EInvoiceDocumentResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return einvoiceService.get(userId, spaceId, invoiceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/einvoice/logs")
  public List<EInvoiceProviderLogResponse> logs(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return einvoiceService.providerLogs(userId, spaceId, invoiceId);
  }
}
