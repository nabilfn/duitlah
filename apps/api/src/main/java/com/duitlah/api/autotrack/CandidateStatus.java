package com.duitlah.api.autotrack;

/** Exactly the 5 statuses the spec's own transaction-candidate model names (section 11). */
public enum CandidateStatus {
  PENDING,
  CONFIRMED,
  REJECTED,
  DUPLICATE,
  FAILED
}
