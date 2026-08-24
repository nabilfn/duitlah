package com.duitlah.api.catalog;

/**
 * Purely a classification label — no SST/GST rate lookup or filing logic lives here; that's Phase
 * 10's ("LHDN / MyInvois / SST") explicit scope.
 */
public enum TaxClassification {
  STANDARD_RATED,
  ZERO_RATED,
  EXEMPT,
  NOT_APPLICABLE
}
