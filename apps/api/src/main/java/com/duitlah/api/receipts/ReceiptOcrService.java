package com.duitlah.api.receipts;

/**
 * Abstraction over the OCR/vision provider (product spec section 10: "OCR provider should be
 * abstracted behind an interface"). {@link UnavailableOcrService} is the fallback when no provider
 * is configured; {@link ClaudeVisionOcrService} is the real implementation. Either way, this never
 * throws for "couldn't read it" — a receipt OCR can't parse is exactly the case the
 * review-and-correct UI exists for, not an error condition.
 */
public interface ReceiptOcrService {

  ParsedReceipt parse(byte[] imageBytes, String contentType);
}
