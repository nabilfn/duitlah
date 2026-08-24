package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record InvoiceResponse(
    UUID id,
    UUID customerId,
    String invoiceNumber,
    LocalDate issueDate,
    LocalDate dueDate,
    InvoiceStatus status,
    InvoiceEffectiveStatus effectiveStatus,
    BigDecimal taxPercent,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal total,
    BigDecimal amountPaid,
    BigDecimal amountCredited,
    BigDecimal amountOutstanding,
    UUID convertedFromQuotationId,
    UUID sourceRecurringInvoiceId,
    String notes,
    List<LineItemResponse> lineItems) {

  static InvoiceResponse of(
      Invoice invoice,
      InvoiceEffectiveStatus effectiveStatus,
      BigDecimal amountPaid,
      BigDecimal amountCredited,
      BigDecimal amountOutstanding,
      List<LineItemResponse> lineItems) {
    return new InvoiceResponse(
        invoice.getId(),
        invoice.getCustomerId(),
        invoice.getInvoiceNumber(),
        invoice.getIssueDate(),
        invoice.getDueDate(),
        invoice.getStatus(),
        effectiveStatus,
        invoice.getTaxPercent(),
        invoice.getSubtotal(),
        invoice.getTaxAmount(),
        invoice.getTotal(),
        amountPaid,
        amountCredited,
        amountOutstanding,
        invoice.getConvertedFromQuotationId(),
        invoice.getSourceRecurringInvoiceId(),
        invoice.getNotes(),
        lineItems);
  }
}
