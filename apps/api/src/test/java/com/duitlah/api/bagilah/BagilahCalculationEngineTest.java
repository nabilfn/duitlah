package com.duitlah.api.bagilah;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.bagilah.BagilahCalculationEngine.CalculationResult;
import com.duitlah.api.bagilah.BagilahCalculationEngine.ClaimInput;
import com.duitlah.api.bagilah.BagilahCalculationEngine.IssueType;
import com.duitlah.api.bagilah.BagilahCalculationEngine.ItemInput;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

/**
 * Covers the master prompt's own Bagilah test matrix (section 71): 1/2/10 participants, equal and
 * unequal splits, shared items/quantities, tax-only/service-only/tax+service, discounts/vouchers/
 * percentage discounts, rounding discrepancies, zero-price items, and the property that
 * SUM(participant final amounts) == bill total always holds exactly.
 */
class BagilahCalculationEngineTest {

  private static final BigDecimal ZERO = BigDecimal.ZERO.setScale(2);

  private static BigDecimal sumFinal(CalculationResult result) {
    return result.breakdowns().stream()
        .map(BagilahCalculationEngine.ParticipantBreakdown::finalAmount)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
  }

  @Test
  void wholeItemOnePersonReconcilesExactly() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("16.00"))),
            List.of(p1),
            List.of(new ClaimInput(item, p1, ClaimType.QUANTITY, BigDecimal.ONE)),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(result.breakdowns().get(0).finalAmount()).isEqualByComparingTo("16.00");
  }

  @Test
  void equalSplitAcrossTwoParticipants() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("15.01"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.PERCENTAGE, new BigDecimal("50.00")),
                new ClaimInput(item, p2, ClaimType.PERCENTAGE, new BigDecimal("50.00"))),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("15.01");
  }

  @Test
  void tenParticipantsSharedItemReconcilesExactly() {
    UUID item = UUID.randomUUID();
    List<UUID> participants = java.util.stream.Stream.generate(UUID::randomUUID).limit(10).toList();
    List<ClaimInput> claims =
        participants.stream()
            .map(p -> new ClaimInput(item, p, ClaimType.PERCENTAGE, new BigDecimal("10.00")))
            .toList();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("100.07"))),
            participants,
            claims,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("100.07");
  }

  @Test
  void unequalCustomAmountSplit() {
    // Pizza RM60 split unevenly by explicit RM amounts.
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("60.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.AMOUNT, new BigDecimal("45.00")),
                new ClaimInput(item, p2, ClaimType.AMOUNT, new BigDecimal("15.00"))),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(
            result.breakdowns().stream()
                .filter(b -> b.participantId().equals(p1))
                .findFirst()
                .get()
                .finalAmount())
        .isEqualByComparingTo("45.00");
  }

  @Test
  void sharedQuantityAllocatesProportionally() {
    // Fries x2, RM16 total (RM8/unit) — one participant takes 1 of 2.
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, new BigDecimal("2"), new BigDecimal("16.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.QUANTITY, BigDecimal.ONE),
                new ClaimInput(item, p2, ClaimType.QUANTITY, BigDecimal.ONE)),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("16.00");
    assertThat(result.breakdowns().get(0).finalAmount()).isEqualByComparingTo("8.00");
  }

  @Test
  void taxOnlyAllocatedProportionalToSubtotal() {
    UUID item1 = UUID.randomUUID();
    UUID item2 = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(
                new ItemInput(item1, BigDecimal.ONE, new BigDecimal("75.00")),
                new ItemInput(item2, BigDecimal.ONE, new BigDecimal("25.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item1, p1, ClaimType.QUANTITY, BigDecimal.ONE),
                new ClaimInput(item2, p2, ClaimType.QUANTITY, BigDecimal.ONE)),
            new BigDecimal("10.00"),
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    // p1 has 75% of subtotal -> 75% of the RM10 tax = RM7.50
    var p1Breakdown =
        result.breakdowns().stream().filter(b -> b.participantId().equals(p1)).findFirst().get();
    assertThat(p1Breakdown.taxShare()).isEqualByComparingTo("7.50");
    assertThat(p1Breakdown.finalAmount()).isEqualByComparingTo("82.50");
    assertThat(sumFinal(result)).isEqualByComparingTo("110.00");
  }

  @Test
  void serviceChargeOnlyAllocatedProportionalToSubtotal() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("50.00"))),
            List.of(p1),
            List.of(new ClaimInput(item, p1, ClaimType.QUANTITY, BigDecimal.ONE)),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            new BigDecimal("5.00"),
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("55.00");
  }

  @Test
  void taxPlusServiceChargeBothProportional() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("100.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.PERCENTAGE, new BigDecimal("30.00")),
                new ClaimInput(item, p2, ClaimType.PERCENTAGE, new BigDecimal("70.00"))),
            new BigDecimal("6.00"),
            AllocationStrategy.PROPORTIONAL,
            new BigDecimal("10.00"),
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("116.00");
  }

  @Test
  void equalTaxStrategySplitsTaxEquallyRegardlessOfSubtotalShare() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("100.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.PERCENTAGE, new BigDecimal("90.00")),
                new ClaimInput(item, p2, ClaimType.PERCENTAGE, new BigDecimal("10.00"))),
            new BigDecimal("10.00"),
            AllocationStrategy.EQUAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(
            result.breakdowns().stream()
                .filter(b -> b.participantId().equals(p2))
                .findFirst()
                .get()
                .taxShare())
        .isEqualByComparingTo("5.00");
  }

  @Test
  void receiptWideDiscountAllocatedProportionally() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("100.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.PERCENTAGE, new BigDecimal("50.00")),
                new ClaimInput(item, p2, ClaimType.PERCENTAGE, new BigDecimal("50.00"))),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            new BigDecimal("20.00"),
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("80.00");
  }

  @Test
  void itemSpecificDiscountIsBakedIntoThatItemsTotalPrice() {
    // A voucher/promo applied to one item is modeled as a lower totalPrice for that item
    // (see docs/database.md); no separate discount step is needed for it here.
    UUID discountedItem = UUID.randomUUID();
    UUID fullPriceItem = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(
                new ItemInput(discountedItem, BigDecimal.ONE, new BigDecimal("8.00")),
                new ItemInput(fullPriceItem, BigDecimal.ONE, new BigDecimal("10.00"))),
            List.of(p1),
            List.of(
                new ClaimInput(discountedItem, p1, ClaimType.QUANTITY, BigDecimal.ONE),
                new ClaimInput(fullPriceItem, p1, ClaimType.QUANTITY, BigDecimal.ONE)),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(result.breakdowns().get(0).finalAmount()).isEqualByComparingTo("18.00");
  }

  @Test
  void roundingDiscrepancyReconciledAgainstDeclaredReceiptTotal() {
    // The master prompt's own worked example: computed line items sum to RM111.35 but the
    // printed receipt says RM111.36 (real-world merchant rounding). Never silently emit
    // RM111.35 when the receipt says RM111.36 -- the difference must be recorded and allocated.
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("111.35"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.PERCENTAGE, new BigDecimal("50.00")),
                new ClaimInput(item, p2, ClaimType.PERCENTAGE, new BigDecimal("50.00"))),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            new BigDecimal("111.36"));
    assertThat(result.isValid()).isTrue();
    assertThat(result.roundingAdjustment()).isEqualByComparingTo("0.01");
    assertThat(sumFinal(result)).isEqualByComparingTo("111.36");
  }

  @Test
  void zeroPriceItemContributesNothingButMustStillBeClaimed() {
    UUID freeItem = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(freeItem, BigDecimal.ONE, ZERO)),
            List.of(p1),
            List.of(new ClaimInput(freeItem, p1, ClaimType.QUANTITY, BigDecimal.ONE)),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(result.breakdowns().get(0).finalAmount()).isEqualByComparingTo("0.00");
  }

  @Test
  void unclaimedItemIsFlaggedAndBlocksValidity() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("16.00"))),
            List.of(p1),
            List.of(),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isFalse();
    assertThat(result.issues())
        .containsExactly(new BagilahCalculationEngine.ItemIssue(item, IssueType.UNCLAIMED));
  }

  @Test
  void overallocatedQuantityIsFlagged() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("16.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.QUANTITY, BigDecimal.ONE),
                new ClaimInput(item, p2, ClaimType.QUANTITY, BigDecimal.ONE)),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isFalse();
    assertThat(result.issues().get(0).type()).isEqualTo(IssueType.OVERALLOCATED);
  }

  @Test
  void mixedClaimTypesOnSameItemAreFlagged() {
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("16.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.QUANTITY, BigDecimal.ONE),
                new ClaimInput(item, p2, ClaimType.PERCENTAGE, new BigDecimal("50.00"))),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isFalse();
    assertThat(result.issues().get(0).type()).isEqualTo(IssueType.MIXED_CLAIM_TYPES);
  }

  @Test
  void multiplePayersJustMeansMultipleSubtotalClaimsNotASpecialCaseForTheEngine() {
    // The engine only computes what each participant owes; who paid what is a BillPayment
    // concern layered on top (see BillService), not something this calculation needs to know.
    UUID item = UUID.randomUUID();
    UUID p1 = UUID.randomUUID();
    UUID p2 = UUID.randomUUID();
    CalculationResult result =
        BagilahCalculationEngine.calculate(
            List.of(new ItemInput(item, BigDecimal.ONE, new BigDecimal("100.00"))),
            List.of(p1, p2),
            List.of(
                new ClaimInput(item, p1, ClaimType.AMOUNT, new BigDecimal("50.00")),
                new ClaimInput(item, p2, ClaimType.AMOUNT, new BigDecimal("50.00"))),
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            AllocationStrategy.PROPORTIONAL,
            ZERO,
            null);
    assertThat(result.isValid()).isTrue();
    assertThat(sumFinal(result)).isEqualByComparingTo("100.00");
  }
}
