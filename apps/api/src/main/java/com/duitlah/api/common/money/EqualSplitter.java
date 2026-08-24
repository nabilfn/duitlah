package com.duitlah.api.common.money;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/**
 * Splits an amount N ways so the shares always sum back to the original exactly — dividing RM100.00
 * by 3 gives 33.33 repeating, and if each share is independently rounded to RM33.33 the total is
 * RM99.99, a cent short. Instead: take the floor share for everyone, then hand the leftover cents
 * (there are at most N-1 of them) to the first N participants in the caller's given order, one cent
 * each. Deterministic, and {@code sum(split(amount, n)) == amount} always holds — the same
 * reconciliation invariant the product spec requires of the Bagilah engine (see
 * docs/bagilah-engine.md), needed here first for group expense splitting.
 */
public final class EqualSplitter {

  private EqualSplitter() {}

  public static List<BigDecimal> split(BigDecimal amount, int participantCount) {
    if (participantCount <= 0) {
      throw new IllegalArgumentException("participantCount must be positive");
    }

    BigDecimal count = BigDecimal.valueOf(participantCount);
    BigDecimal baseShare = amount.divide(count, 2, RoundingMode.DOWN);
    BigDecimal distributed = baseShare.multiply(count);
    BigDecimal remainder = amount.subtract(distributed);
    int remainderCents = remainder.movePointRight(2).intValueExact();

    List<BigDecimal> shares = new ArrayList<>(participantCount);
    BigDecimal oneCent = new BigDecimal("0.01");
    for (int i = 0; i < participantCount; i++) {
      shares.add(i < remainderCents ? baseShare.add(oneCent) : baseShare);
    }
    return shares;
  }
}
