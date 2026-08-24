package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record QuotationResponse(
    UUID id,
    UUID customerId,
    String quoteNumber,
    LocalDate issueDate,
    LocalDate expiryDate,
    QuotationStatus status,
    BigDecimal taxPercent,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal total,
    String notes,
    List<LineItemResponse> lineItems) {

  static QuotationResponse of(Quotation q, List<LineItemResponse> lineItems) {
    return new QuotationResponse(
        q.getId(),
        q.getCustomerId(),
        q.getQuoteNumber(),
        q.getIssueDate(),
        q.getExpiryDate(),
        q.getStatus(),
        q.getTaxPercent(),
        q.getSubtotal(),
        q.getTaxAmount(),
        q.getTotal(),
        q.getNotes(),
        lineItems);
  }
}
