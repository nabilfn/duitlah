package com.duitlah.api.reconciliation;

/** Never persisted — computed fresh by {@link MatchingService} on every request. */
public enum MatchConfidence {
  EXACT,
  PROBABLE
}
