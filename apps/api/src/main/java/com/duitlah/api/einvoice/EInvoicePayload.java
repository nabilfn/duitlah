package com.duitlah.api.einvoice;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record EInvoicePayload(
    String sellerTin,
    String sellerName,
    String sellerRegistrationNumber,
    String buyerTin,
    String buyerName,
    String buyerRegistrationNumber,
    String invoiceNumber,
    LocalDate issueDate,
    String currency,
    BigDecimal subtotal,
    BigDecimal taxAmount,
    BigDecimal total,
    List<EInvoicePayloadLine> lines) {

  public record EInvoicePayloadLine(
      String description, BigDecimal quantity, BigDecimal unitPrice, BigDecimal lineTotal) {}
}
