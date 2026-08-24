package com.duitlah.api.bagilah;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

public record BillResponse(
    UUID id,
    UUID ownerUserId,
    UUID groupId,
    String merchant,
    LocalDate receiptDate,
    String currency,
    BigDecimal tax,
    AllocationStrategy taxStrategy,
    BigDecimal serviceCharge,
    AllocationStrategy serviceStrategy,
    BigDecimal discount,
    String discountLabel,
    BigDecimal declaredTotal,
    BigDecimal total,
    BigDecimal roundingAdjustment,
    BillStatus status,
    Instant finalizedAt) {

  public static BillResponse of(Bill bill) {
    return new BillResponse(
        bill.getId(),
        bill.getOwnerUserId(),
        bill.getGroupId(),
        bill.getMerchant(),
        bill.getReceiptDate(),
        bill.getCurrency(),
        bill.getTax(),
        bill.getTaxStrategy(),
        bill.getServiceCharge(),
        bill.getServiceStrategy(),
        bill.getDiscount(),
        bill.getDiscountLabel(),
        bill.getDeclaredTotal(),
        bill.getTotal(),
        bill.getRoundingAdjustment(),
        bill.getStatus(),
        bill.getFinalizedAt());
  }
}
