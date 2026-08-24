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
public class QuotationController {

  private final QuotationService quotations;

  public QuotationController(QuotationService quotations) {
    this.quotations = quotations;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/quotations")
  @ResponseStatus(HttpStatus.CREATED)
  public QuotationResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateQuotationRequest request) {
    return quotations.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/quotations")
  public List<QuotationResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return quotations.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/quotations/{quotationId}")
  public QuotationResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID quotationId) {
    return quotations.get(userId, spaceId, quotationId);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/quotations/{quotationId}/status")
  public QuotationResponse changeStatus(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID quotationId,
      @Valid @RequestBody ChangeQuotationStatusRequest request) {
    return quotations.changeStatus(userId, spaceId, quotationId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/quotations/{quotationId}/convert-to-invoice")
  @ResponseStatus(HttpStatus.CREATED)
  public InvoiceResponse convertToInvoice(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID quotationId,
      @Valid @RequestBody ConvertQuotationRequest request) {
    return quotations.convertToInvoice(userId, spaceId, quotationId, request.dueDate());
  }
}
