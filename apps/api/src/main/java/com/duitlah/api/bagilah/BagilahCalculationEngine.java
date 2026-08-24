package com.duitlah.api.bagilah;

import com.duitlah.api.common.money.EqualSplitter;
import com.duitlah.api.common.money.ProportionalAllocator;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * The Bagilah split engine, kept free of JPA/Spring so its arithmetic can be property-tested in
 * isolation. Every code path here must uphold one invariant: {@code sum(breakdown.finalAmount)}
 * always equals {@code computedTotal + roundingAdjustment} exactly — see {@link
 * com.duitlah.api.common.money.ProportionalAllocator} and {@link EqualSplitter}, which this engine
 * relies on for that guarantee instead of re-deriving rounding logic per allocation site.
 */
public final class BagilahCalculationEngine {

  private BagilahCalculationEngine() {}

  public record ItemInput(UUID itemId, BigDecimal quantity, BigDecimal totalPrice) {}

  public record ClaimInput(
      UUID itemId, UUID participantId, ClaimType claimType, BigDecimal value) {}

  public record ItemIssue(UUID itemId, IssueType type) {}

  public enum IssueType {
    UNCLAIMED,
    OVERALLOCATED,
    MIXED_CLAIM_TYPES
  }

  public record ParticipantBreakdown(
      UUID participantId,
      BigDecimal subtotal,
      BigDecimal taxShare,
      BigDecimal serviceShare,
      BigDecimal discountShare,
      BigDecimal roundingShare,
      BigDecimal finalAmount) {}

  public record CalculationResult(
      List<ItemIssue> issues,
      List<ParticipantBreakdown> breakdowns,
      BigDecimal subtotal,
      BigDecimal computedTotal,
      BigDecimal roundingAdjustment) {

    public boolean isValid() {
      return issues.isEmpty();
    }
  }

  public static CalculationResult calculate(
      List<ItemInput> items,
      List<UUID> participantIds,
      List<ClaimInput> claims,
      BigDecimal tax,
      AllocationStrategy taxStrategy,
      BigDecimal serviceCharge,
      AllocationStrategy serviceStrategy,
      BigDecimal discount,
      BigDecimal declaredTotal) {

    List<ItemIssue> issues = new ArrayList<>();
    Map<UUID, BigDecimal> participantSubtotals = new LinkedHashMap<>();
    for (UUID participantId : participantIds) {
      participantSubtotals.put(participantId, BigDecimal.ZERO.setScale(2));
    }

    BigDecimal subtotal = BigDecimal.ZERO.setScale(2);
    for (ItemInput item : items) {
      subtotal = subtotal.add(item.totalPrice());
      List<ClaimInput> itemClaims =
          claims.stream().filter(c -> c.itemId().equals(item.itemId())).toList();

      if (itemClaims.isEmpty()) {
        issues.add(new ItemIssue(item.itemId(), IssueType.UNCLAIMED));
        continue;
      }

      ClaimType claimType = itemClaims.get(0).claimType();
      boolean mixed = itemClaims.stream().anyMatch(c -> c.claimType() != claimType);
      if (mixed) {
        issues.add(new ItemIssue(item.itemId(), IssueType.MIXED_CLAIM_TYPES));
        continue;
      }

      BigDecimal expectedWeightTotal =
          switch (claimType) {
            case QUANTITY -> item.quantity();
            case PERCENTAGE -> new BigDecimal("100.00");
            case AMOUNT -> item.totalPrice();
          };
      BigDecimal actualWeightTotal =
          itemClaims.stream().map(ClaimInput::value).reduce(BigDecimal.ZERO, BigDecimal::add);

      int cmp = actualWeightTotal.compareTo(expectedWeightTotal);
      if (cmp > 0) {
        issues.add(new ItemIssue(item.itemId(), IssueType.OVERALLOCATED));
        continue;
      }
      if (cmp < 0) {
        issues.add(new ItemIssue(item.itemId(), IssueType.UNCLAIMED));
        continue;
      }

      List<BigDecimal> weights = itemClaims.stream().map(ClaimInput::value).toList();
      List<BigDecimal> amounts =
          item.totalPrice().signum() == 0
              ? weights.stream().map(w -> new BigDecimal("0.00")).toList()
              : ProportionalAllocator.allocate(item.totalPrice(), weights);

      for (int i = 0; i < itemClaims.size(); i++) {
        UUID participantId = itemClaims.get(i).participantId();
        participantSubtotals.merge(participantId, amounts.get(i), BigDecimal::add);
      }
    }

    List<UUID> orderedParticipantIds = new ArrayList<>(participantSubtotals.keySet());
    List<BigDecimal> subtotalWeights =
        orderedParticipantIds.stream().map(participantSubtotals::get).toList();

    List<BigDecimal> taxShares =
        allocateAcrossParticipants(tax, taxStrategy, subtotalWeights, orderedParticipantIds.size());
    List<BigDecimal> serviceShares =
        allocateAcrossParticipants(
            serviceCharge, serviceStrategy, subtotalWeights, orderedParticipantIds.size());
    List<BigDecimal> discountShares =
        allocateAcrossParticipants(
            discount,
            AllocationStrategy.PROPORTIONAL,
            subtotalWeights,
            orderedParticipantIds.size());

    BigDecimal computedTotal = subtotal.add(tax).add(serviceCharge).subtract(discount);
    BigDecimal roundingAdjustment =
        declaredTotal != null ? declaredTotal.subtract(computedTotal) : BigDecimal.ZERO.setScale(2);
    List<BigDecimal> roundingShares =
        roundingAdjustment.signum() == 0
            ? subtotalWeights.stream().map(w -> new BigDecimal("0.00")).toList()
            : allocateAcrossParticipants(
                roundingAdjustment,
                AllocationStrategy.PROPORTIONAL,
                subtotalWeights,
                orderedParticipantIds.size());

    List<ParticipantBreakdown> breakdowns = new ArrayList<>(orderedParticipantIds.size());
    for (int i = 0; i < orderedParticipantIds.size(); i++) {
      BigDecimal participantSubtotal = subtotalWeights.get(i);
      BigDecimal finalAmount =
          participantSubtotal
              .add(taxShares.get(i))
              .add(serviceShares.get(i))
              .subtract(discountShares.get(i))
              .add(roundingShares.get(i));
      breakdowns.add(
          new ParticipantBreakdown(
              orderedParticipantIds.get(i),
              participantSubtotal,
              taxShares.get(i),
              serviceShares.get(i),
              discountShares.get(i),
              roundingShares.get(i),
              finalAmount));
    }

    return new CalculationResult(issues, breakdowns, subtotal, computedTotal, roundingAdjustment);
  }

  private static List<BigDecimal> allocateAcrossParticipants(
      BigDecimal amount,
      AllocationStrategy strategy,
      List<BigDecimal> subtotalWeights,
      int participantCount) {
    if (amount.signum() == 0) {
      return subtotalWeights.stream().map(w -> new BigDecimal("0.00")).toList();
    }
    boolean allWeightsZero = subtotalWeights.stream().allMatch(w -> w.signum() == 0);
    if (strategy == AllocationStrategy.EQUAL || allWeightsZero) {
      int sign = amount.signum();
      List<BigDecimal> shares = EqualSplitter.split(amount.abs(), participantCount);
      return sign < 0 ? shares.stream().map(BigDecimal::negate).toList() : shares;
    }
    return ProportionalAllocator.allocate(amount, subtotalWeights);
  }
}
