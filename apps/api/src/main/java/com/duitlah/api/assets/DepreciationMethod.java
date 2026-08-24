package com.duitlah.api.assets;

/**
 * Two well-known, deterministic, literal formulas (spec section 50's "depreciation method" field) —
 * never a fabricated or estimated figure. See {@link DepreciationCalculator} for the exact math.
 */
public enum DepreciationMethod {
  STRAIGHT_LINE,
  DOUBLE_DECLINING_BALANCE
}
