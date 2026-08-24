package com.duitlah.api.receipts;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * The structured result of running OCR over a receipt photo. Every field the user might need to
 * correct (product spec section 10) is nullable/zero-able on purpose — OCR may fail to read the
 * merchant name, the date, or any charge line, and the review UI must still work with partial
 * results rather than refusing to let the user proceed. {@code overallConfidence} is a simple
 * average of the per-field confidences, used only to decide whether to show a "double-check this
 * scan" banner — it is not stored anywhere the calculation engine reads from.
 */
public record ParsedReceipt(
    String merchant,
    double merchantConfidence,
    LocalDate receiptDate,
    double receiptDateConfidence,
    List<ParsedReceiptItem> items,
    BigDecimal tax,
    double taxConfidence,
    BigDecimal serviceCharge,
    double serviceConfidence,
    BigDecimal discount,
    double discountConfidence,
    BigDecimal total,
    double totalConfidence,
    double overallConfidence) {

  public static ParsedReceipt unavailable() {
    return new ParsedReceipt(null, 0, null, 0, List.of(), null, 0, null, 0, null, 0, null, 0, 0);
  }

  /**
   * V2 Phase 13 (Smart Capture improvement): the one server-computed threshold behind a
   * "double-check this scan" banner, so every client applies the same rule instead of each one
   * guessing its own cutoff.
   */
  public static final double LOW_CONFIDENCE_THRESHOLD = 0.7;

  public boolean needsReview() {
    return overallConfidence < LOW_CONFIDENCE_THRESHOLD;
  }
}
