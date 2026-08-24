package com.duitlah.api.sales;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InvoiceController {

  private final InvoiceService invoices;

  public InvoiceController(InvoiceService invoices) {
    this.invoices = invoices;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices")
  @ResponseStatus(HttpStatus.CREATED)
  public InvoiceResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateInvoiceRequest request) {
    return invoices.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/invoices")
  public List<InvoiceResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return invoices.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}")
  public InvoiceResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return invoices.get(userId, spaceId, invoiceId);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/status")
  public InvoiceResponse changeStatus(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId,
      @Valid @RequestBody ChangeInvoiceStatusRequest request) {
    return invoices.changeStatus(userId, spaceId, invoiceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/payments")
  public List<InvoicePaymentResponse> listPayments(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId) {
    return invoices.listPayments(userId, spaceId, invoiceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/invoices/{invoiceId}/payments")
  @ResponseStatus(HttpStatus.CREATED)
  public InvoicePaymentResponse recordPayment(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID invoiceId,
      @Valid @RequestBody RecordInvoicePaymentRequest request) {
    return invoices.recordPayment(userId, spaceId, invoiceId, request);
  }
}
