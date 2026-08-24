package com.duitlah.api.receipts;

import java.math.BigDecimal;

/**
 * One line item as read off the receipt by OCR. {@code confidence} is the provider's own
 * self-reported estimate (0.0-1.0) of how sure it is this line was read correctly — a heuristic,
 * not a calibrated probability, but still useful for flagging what the user should double-check
 * (product spec section 10: "Never trust OCR completely").
 */
public record ParsedReceiptItem(
    String name,
    BigDecimal quantity,
    BigDecimal unitPrice,
    BigDecimal totalPrice,
    double confidence) {}
