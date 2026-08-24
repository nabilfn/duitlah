package com.duitlah.api.receipts;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record ReceiptResponse(
    UUID id,
    ReceiptPurpose purpose,
    VaultOcrStatus ocrStatus,
    String merchant,
    LocalDate receiptDate,
    BigDecimal totalAmount,
    Double overallConfidence,
    boolean needsReview,
    String folder,
    List<String> tags,
    UUID linkedTransactionId,
    UUID linkedBillId,
    String imageUrl) {

  public static ReceiptResponse from(Receipt receipt, String imageUrl) {
    boolean needsReview =
        receipt.getOcrStatus() == VaultOcrStatus.PARSED
            && receipt.getOverallConfidence() != null
            && receipt.getOverallConfidence() < ParsedReceipt.LOW_CONFIDENCE_THRESHOLD;
    return new ReceiptResponse(
        receipt.getId(),
        receipt.getPurpose(),
        receipt.getOcrStatus(),
        receipt.getMerchant(),
        receipt.getReceiptDate(),
        receipt.getTotalAmount(),
        receipt.getOverallConfidence(),
        needsReview,
        receipt.getFolder(),
        List.of(receipt.getTags()),
        receipt.getLinkedTransactionId(),
        receipt.getLinkedBillId(),
        imageUrl);
  }
}
