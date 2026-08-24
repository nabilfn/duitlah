package com.duitlah.api.bills;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record PersonalBillResponse(
    UUID id,
    String name,
    String provider,
    LocalDate dueDate,
    BigDecimal expectedAmount,
    BillRecurrence recurrence,
    BillStatus status,
    UUID linkedTransactionId,
    UUID receiptId,
    String notes) {

  public static PersonalBillResponse from(PersonalBill bill) {
    return new PersonalBillResponse(
        bill.getId(),
        bill.getName(),
        bill.getProvider(),
        bill.getDueDate(),
        bill.getExpectedAmount(),
        bill.getRecurrence(),
        bill.getStatus(),
        bill.getLinkedTransactionId(),
        bill.getReceiptId(),
        bill.getNotes());
  }
}
