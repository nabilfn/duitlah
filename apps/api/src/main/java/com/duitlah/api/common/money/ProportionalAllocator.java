package com.duitlah.api.common.money;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Splits an amount across weighted shares (e.g. "proportional to each participant's subtotal") so
 * the shares always sum back to the original amount exactly. Unlike {@link EqualSplitter}, shares
 * aren't equal — each is proportional to its own weight — so leftover cents can't just go to the
 * first N participants without skewing fairness toward whoever happens to be first; instead they go
 * to whichever weights lost the most to rounding (the largest-remainder method).
 */
public final class ProportionalAllocator {

  private ProportionalAllocator() {}

  /**
   * @param total the amount to allocate; may be negative (e.g. a rounding correction), in which
   *     case every share takes the same sign
   * @param weights non-negative weights, one per share; if every weight is zero, {@code total} must
   *     also be zero (there is no fair way to allocate a non-zero amount with no weights to go by)
   *     and every share is zero
   */
  public static List<BigDecimal> allocate(BigDecimal total, List<BigDecimal> weights) {
    int n = weights.size();
    if (n == 0) {
      throw new IllegalArgumentException("weights must not be empty");
    }
    BigDecimal totalWeight = weights.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    if (totalWeight.signum() == 0) {
      if (total.signum() != 0) {
        throw new IllegalArgumentException(
            "cannot allocate a non-zero total across all-zero weights");
      }
      List<BigDecimal> zeros = new ArrayList<>(n);
      for (int i = 0; i < n; i++) {
        zeros.add(new BigDecimal("0.00"));
      }
      return zeros;
    }

    int sign = total.signum();
    BigDecimal absTotal = total.abs();

    BigDecimal[] floor = new BigDecimal[n];
    BigDecimal[] remainder = new BigDecimal[n];
    BigDecimal allocatedSoFar = BigDecimal.ZERO;
    for (int i = 0; i < n; i++) {
      BigDecimal exact =
          absTotal.multiply(weights.get(i)).divide(totalWeight, 10, RoundingMode.HALF_UP);
      floor[i] = exact.setScale(2, RoundingMode.DOWN);
      remainder[i] = exact.subtract(floor[i]);
      allocatedSoFar = allocatedSoFar.add(floor[i]);
    }

    int leftoverCents =
        absTotal
            .subtract(allocatedSoFar)
            .movePointRight(2)
            .setScale(0, RoundingMode.HALF_UP)
            .intValueExact();

    Integer[] order = new Integer[n];
    for (int i = 0; i < n; i++) {
      order[i] = i;
    }
    Arrays.sort(
        order,
        (a, b) -> {
          int cmp = remainder[b].compareTo(remainder[a]);
          return cmp != 0 ? cmp : Integer.compare(a, b);
        });

    BigDecimal oneCent = new BigDecimal("0.01");
    List<BigDecimal> result = new ArrayList<>(Arrays.asList(floor));
    for (int i = 0; i < leftoverCents; i++) {
      int idx = order[i];
      result.set(idx, result.get(idx).add(oneCent));
    }

    if (sign < 0) {
      for (int i = 0; i < n; i++) {
        result.set(i, result.get(i).negate());
      }
    }
    return result;
  }
}
