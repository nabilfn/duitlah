package com.duitlah.api.sales;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RecurringInvoiceController {

  private final RecurringInvoiceService recurringInvoices;

  public RecurringInvoiceController(RecurringInvoiceService recurringInvoices) {
    this.recurringInvoices = recurringInvoices;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/recurring-invoices")
  @ResponseStatus(HttpStatus.CREATED)
  public RecurringInvoiceResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateRecurringInvoiceRequest request) {
    return recurringInvoices.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/recurring-invoices")
  public List<RecurringInvoiceResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return recurringInvoices.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/recurring-invoices/{recurringInvoiceId}")
  public RecurringInvoiceResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID recurringInvoiceId) {
    return recurringInvoices.get(userId, spaceId, recurringInvoiceId);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/recurring-invoices/{recurringInvoiceId}/active")
  public RecurringInvoiceResponse setActive(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID recurringInvoiceId,
      @RequestBody Map<String, Boolean> body) {
    return recurringInvoices.setActive(
        userId, spaceId, recurringInvoiceId, Boolean.TRUE.equals(body.get("active")));
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/recurring-invoices/{recurringInvoiceId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID recurringInvoiceId) {
    recurringInvoices.delete(userId, spaceId, recurringInvoiceId);
  }
}
