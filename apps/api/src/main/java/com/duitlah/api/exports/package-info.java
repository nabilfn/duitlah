/**
 * User-controlled exports (V2 Phase 3, spec section 23). Implemented for the personal-finance data
 * this app actually has today — transactions, budgets, personal bills, loans/liabilities, net worth
 * — plus a full archive ZIP bundling all of them. The spec's own list also names tax
 * summary/business accounting/invoices/Bagilah/Groups/settlements exports; those are deliberately
 * not built here — tax and business accounting don't exist as features yet (later V2 phases), and
 * Bagilah/Groups/settlements exports are a real but separate scope decision left for whichever
 * phase actually prioritizes them, not silently forgotten.
 *
 * <p>PDF export ({@link com.duitlah.api.exports.PdfExportWriter}) is a plain, PDFBox-drawn text
 * table — real and correct, but deliberately not a styled, branded report; building that would need
 * a proper layout engine this app doesn't otherwise depend on, for a first export pass that CSV/
 * XLSX already cover completely for any real downstream use (spreadsheets, accounting software).
 */
package com.duitlah.api.exports;
