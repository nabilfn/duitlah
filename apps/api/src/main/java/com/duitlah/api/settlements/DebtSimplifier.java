package com.duitlah.api.settlements;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.UUID;

/**
 * Reduces a set of net positions (some owed money, some owing money) to a minimal-ish set of
 * pairwise transfers that settles everyone up — the product spec's own example: instead of A→B RM50
 * and B→C RM50, prefer A→C RM50 (section 18). Uses the standard greedy approach (repeatedly match
 * the largest creditor with the largest debtor): not provably globally optimal in every adversarial
 * case, but deterministic, simple to reason about, and good in practice — exactly matching how
 * {@link com.duitlah.api.common.money.EqualSplitter}/{@code ProportionalAllocator} favor a simple,
 * well-understood algorithm over a more exotic optimum nothing here needs.
 *
 * <p>The one invariant that actually matters and is property-tested: every person's net position is
 * exactly reconstructed by summing the transfers they're party to — nobody's debt is
 * over-simplified away or left short.
 */
public final class DebtSimplifier {

  private DebtSimplifier() {}

  public record NetPosition(UUID personId, BigDecimal net) {}

  public record Transfer(UUID fromUserId, UUID toUserId, BigDecimal amount) {}

  public static List<Transfer> simplify(List<NetPosition> positions) {
    PriorityQueue<NetPosition> creditors =
        new PriorityQueue<>((a, b) -> b.net().compareTo(a.net()));
    PriorityQueue<NetPosition> debtors =
        new PriorityQueue<>((a, b) -> b.net().negate().compareTo(a.net().negate()));

    for (NetPosition position : positions) {
      if (position.net().signum() > 0) {
        creditors.add(position);
      } else if (position.net().signum() < 0) {
        debtors.add(position);
      }
    }

    List<Transfer> transfers = new ArrayList<>();
    while (!creditors.isEmpty() && !debtors.isEmpty()) {
      NetPosition creditor = creditors.poll();
      NetPosition debtor = debtors.poll();
      BigDecimal owed = debtor.net().negate();
      BigDecimal transferAmount = creditor.net().min(owed);

      transfers.add(new Transfer(debtor.personId(), creditor.personId(), transferAmount));

      BigDecimal remainingCredit = creditor.net().subtract(transferAmount);
      BigDecimal remainingDebt = owed.subtract(transferAmount);
      if (remainingCredit.signum() > 0) {
        creditors.add(new NetPosition(creditor.personId(), remainingCredit));
      }
      if (remainingDebt.signum() > 0) {
        debtors.add(new NetPosition(debtor.personId(), remainingDebt.negate()));
      }
    }
    return transfers;
  }
}
