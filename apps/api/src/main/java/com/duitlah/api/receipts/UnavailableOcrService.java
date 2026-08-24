package com.duitlah.api.receipts;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Used whenever no OCR provider is configured ({@code duitlah.receipts.ocr.anthropic-api-key}
 * unset) — every scan comes back completely blank, which sends the user straight into the
 * manual-entry review form instead of failing the upload outright.
 */
public class UnavailableOcrService implements ReceiptOcrService {

  private static final Logger log = LoggerFactory.getLogger(UnavailableOcrService.class);

  @Override
  public ParsedReceipt parse(byte[] imageBytes, String contentType) {
    log.info("OCR is not configured (ANTHROPIC_API_KEY unset) -- returning a blank parse result.");
    return ParsedReceipt.unavailable();
  }
}
