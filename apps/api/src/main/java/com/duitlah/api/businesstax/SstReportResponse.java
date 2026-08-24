package com.duitlah.api.businesstax;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Section 54's "reporting period"/"collected tax"/"payable tax" fields, computed from the existing
 * "SST/GST Payable" ledger account rather than a second tax-tracking mechanism. Both figures are
 * zero if the space hasn't mapped or seeded that account yet — the same best-effort posture as
 * every automatic-posting method in {@code accounting}.
 */
public record SstReportResponse(
    LocalDate from, LocalDate to, BigDecimal collectedTax, BigDecimal payableTax) {}
