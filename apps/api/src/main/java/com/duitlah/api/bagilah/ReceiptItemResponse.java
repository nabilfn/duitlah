package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.util.UUID;

public record ReceiptItemResponse(
    UUID id,
    String name,
    BigDecimal quantity,
    BigDecimal unitPrice,
    BigDecimal itemDiscount,
    BigDecimal totalPrice) {

  public static ReceiptItemResponse of(ReceiptItem item) {
    return new ReceiptItemResponse(
        item.getId(),
        item.getName(),
        item.getQuantity(),
        item.getUnitPrice(),
        item.getItemDiscount(),
        item.getTotalPrice());
  }
}
