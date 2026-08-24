package com.duitlah.api.receipts;

import java.util.UUID;

public record ReceiptScanResponse(
    UUID id,
    ScanStatus status,
    String provider,
    Double overallConfidence,
    boolean needsReview,
    ParsedReceipt parsedReceipt,
    String imageUrl,
    String errorMessage,
    UUID billId) {}
