package com.duitlah.api.autotrack;

/**
 * The spec's AutoTrack diagram (section 10) lists more sources than this phase implements
 * (notification capture, shared text, wallet capture, future bank integrations) — those need
 * mobile-native OS integration (a notification listener, a share-sheet intent handler) that's a
 * separate later phase's work, not a value added here with no code path behind it.
 */
public enum CandidateSourceType {
  RECEIPT_OCR,
  STATEMENT_CSV,
  STATEMENT_XLSX,
  STATEMENT_PDF
}
