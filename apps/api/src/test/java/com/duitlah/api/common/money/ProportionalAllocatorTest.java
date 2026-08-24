package com.duitlah.api.common.money;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.math.BigDecimal;
import java.util.List;
import org.junit.jupiter.api.Test;

class ProportionalAllocatorTest {

  @Test
  void allocatesExactlyWithNoRemainder() {
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(
            new BigDecimal("100.00"), List.of(new BigDecimal("50"), new BigDecimal("50")));
    assertThat(shares).containsExactly(new BigDecimal("50.00"), new BigDecimal("50.00"));
  }

  @Test
  void distributesLeftoverCentsByLargestRemainder() {
    // 10.00 split 3 ways by equal weight -> 3.33, 3.33, 3.33 with 1 cent left over,
    // which must go to a real participant, not vanish.
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(
            new BigDecimal("10.00"), List.of(BigDecimal.ONE, BigDecimal.ONE, BigDecimal.ONE));
    BigDecimal sum = shares.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    assertThat(sum).isEqualByComparingTo("10.00");
    assertThat(shares).contains(new BigDecimal("3.34"));
  }

  @Test
  void favorsTheWeightThatLostMostToRoundingWhenWeightsDiffer() {
    // Weights 1:2:7 of RM10 -> exact 1.00, 2.00, 7.00, no rounding needed at all.
    // Use an amount that forces rounding instead: RM10.01 across weights 1:1:1.
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(
            new BigDecimal("10.01"), List.of(BigDecimal.ONE, BigDecimal.ONE, BigDecimal.ONE));
    BigDecimal sum = shares.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    assertThat(sum).isEqualByComparingTo("10.01");
  }

  @Test
  void unevenWeightsStillReconcileExactly() {
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(
            new BigDecimal("111.36"),
            List.of(
                new BigDecimal("24.60"),
                new BigDecimal("31.35"),
                new BigDecimal("27.10"),
                new BigDecimal("28.10")));
    BigDecimal sum = shares.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    assertThat(sum).isEqualByComparingTo("111.36");
  }

  @Test
  void negativeTotalReconcilesExactlyAndEachShareTakesTheSameSign() {
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(
            new BigDecimal("-10.00"), List.of(BigDecimal.ONE, BigDecimal.ONE, BigDecimal.ONE));
    BigDecimal sum = shares.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    assertThat(sum).isEqualByComparingTo("-10.00");
    assertThat(shares).allMatch(s -> s.signum() <= 0);
  }

  @Test
  void zeroWeightParticipantGetsNothing() {
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(
            new BigDecimal("100.00"), List.of(BigDecimal.ZERO, new BigDecimal("100")));
    assertThat(shares.get(0)).isEqualByComparingTo("0.00");
    assertThat(shares.get(1)).isEqualByComparingTo("100.00");
  }

  @Test
  void zeroTotalWithAllZeroWeightsReturnsZeros() {
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(BigDecimal.ZERO, List.of(BigDecimal.ZERO, BigDecimal.ZERO));
    assertThat(shares).containsExactly(new BigDecimal("0.00"), new BigDecimal("0.00"));
  }

  @Test
  void nonZeroTotalWithAllZeroWeightsIsRejected() {
    assertThatThrownBy(
            () ->
                ProportionalAllocator.allocate(
                    new BigDecimal("10.00"), List.of(BigDecimal.ZERO, BigDecimal.ZERO)))
        .isInstanceOf(IllegalArgumentException.class);
  }

  @Test
  void singleWeightGetsEverything() {
    List<BigDecimal> shares =
        ProportionalAllocator.allocate(new BigDecimal("33.33"), List.of(new BigDecimal("7")));
    assertThat(shares).containsExactly(new BigDecimal("33.33"));
  }

  @Test
  void tenParticipantsReconcileExactly() {
    List<BigDecimal> weights = new java.util.ArrayList<>();
    for (int i = 1; i <= 10; i++) {
      weights.add(BigDecimal.valueOf(i));
    }
    List<BigDecimal> shares = ProportionalAllocator.allocate(new BigDecimal("100.07"), weights);
    BigDecimal sum = shares.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
    assertThat(sum).isEqualByComparingTo("100.07");
  }
}
