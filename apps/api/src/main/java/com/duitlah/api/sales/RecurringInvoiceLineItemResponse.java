package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.util.UUID;

public record RecurringInvoiceLineItemResponse(
    UUID id, UUID productId, String description, BigDecimal quantity, BigDecimal unitPrice) {

  static RecurringInvoiceLineItemResponse of(RecurringInvoiceLineItem li) {
    return new RecurringInvoiceLineItemResponse(
        li.getId(), li.getProductId(), li.getDescription(), li.getQuantity(), li.getUnitPrice());
  }
}
