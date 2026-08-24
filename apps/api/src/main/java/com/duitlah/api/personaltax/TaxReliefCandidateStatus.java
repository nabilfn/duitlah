package com.duitlah.api.personaltax;

/** Exactly the language the spec asks for (section 27) — never a silent auto-claim. */
public enum TaxReliefCandidateStatus {
  POTENTIALLY_ELIGIBLE,
  NEEDS_REVIEW,
  MISSING_EVIDENCE,
  CONFIRMED,
  REJECTED
}
