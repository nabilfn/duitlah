package com.duitlah.api.assets;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Two literal, well-known formulas — never a fabricated or estimated figure, matching this
 * codebase's "deterministic, explainable calculation" discipline everywhere else a real number is
 * at stake ({@code inventory.InventoryValuationService}, {@code accounting.JournalEntryService}).
 *
 * <p><b>Straight-Line</b>: {@code (cost - salvageValue) / usefulLifeMonths} every period, flat.
 *
 * <p><b>Double Declining Balance</b>: {@code netBookValue * (2 / usefulLifeMonths)} every period —
 * the standard "double" variant of the reducing-balance method (twice the straight-line rate
 * applied to the shrinking net book value), not a generic unspecified "declining balance" so the
 * exact rate used is never ambiguous.
 *
 * <p>Both are floored so an asset is never depreciated below its salvage value, regardless of
 * rounding across periods.
 */
final class DepreciationCalculator {

  private DepreciationCalculator() {}

  static BigDecimal nextPeriodAmount(
      DepreciationMethod method,
      BigDecimal cost,
      BigDecimal salvageValue,
      int usefulLifeMonths,
      BigDecimal accumulatedSoFar) {
    BigDecimal depreciableBase = cost.subtract(salvageValue);
    BigDecimal remaining = depreciableBase.subtract(accumulatedSoFar);
    if (remaining.signum() <= 0) {
      return BigDecimal.ZERO;
    }

    BigDecimal raw =
        switch (method) {
          case STRAIGHT_LINE ->
              depreciableBase.divide(BigDecimal.valueOf(usefulLifeMonths), 2, RoundingMode.HALF_UP);
          case DOUBLE_DECLINING_BALANCE -> {
            BigDecimal netBookValue = cost.subtract(accumulatedSoFar);
            BigDecimal rate =
                BigDecimal.valueOf(2)
                    .divide(BigDecimal.valueOf(usefulLifeMonths), 10, RoundingMode.HALF_UP);
            yield netBookValue.multiply(rate).setScale(2, RoundingMode.HALF_UP);
          }
        };

    return raw.min(remaining);
  }
}
