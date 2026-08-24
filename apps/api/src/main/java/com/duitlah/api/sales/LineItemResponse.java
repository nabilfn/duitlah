package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.util.UUID;

public record LineItemResponse(
    UUID id,
    UUID productId,
    String description,
    BigDecimal quantity,
    BigDecimal unitPrice,
    BigDecimal lineTotal) {

  static LineItemResponse of(QuotationLineItem li) {
    return new LineItemResponse(
        li.getId(),
        li.getProductId(),
        li.getDescription(),
        li.getQuantity(),
        li.getUnitPrice(),
        li.getLineTotal());
  }

  static LineItemResponse of(InvoiceLineItem li) {
    return new LineItemResponse(
        li.getId(),
        li.getProductId(),
        li.getDescription(),
        li.getQuantity(),
        li.getUnitPrice(),
        li.getLineTotal());
  }
}
