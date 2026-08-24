package com.duitlah.api.settlements;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.settlements.DebtSimplifier.NetPosition;
import com.duitlah.api.settlements.DebtSimplifier.Transfer;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import org.junit.jupiter.api.Test;

class DebtSimplifierTest {

  private static Map<UUID, BigDecimal> netTransferred(List<Transfer> transfers) {
    Map<UUID, BigDecimal> net = new java.util.HashMap<>();
    for (Transfer t : transfers) {
      net.merge(t.toUserId(), t.amount(), BigDecimal::add);
      net.merge(t.fromUserId(), t.amount().negate(), BigDecimal::add);
    }
    return net;
  }

  private static void assertReconciles(List<NetPosition> positions, List<Transfer> transfers) {
    Map<UUID, BigDecimal> net = netTransferred(transfers);
    for (NetPosition p : positions) {
      BigDecimal actual = net.getOrDefault(p.personId(), BigDecimal.ZERO);
      assertThat(actual).isEqualByComparingTo(p.net());
    }
  }

  @Test
  void twoPeopleOneOwesTheOtherOneTransfer() {
    UUID a = UUID.randomUUID();
    UUID b = UUID.randomUUID();
    List<NetPosition> positions =
        List.of(
            new NetPosition(a, new BigDecimal("50.00")),
            new NetPosition(b, new BigDecimal("-50.00")));
    List<Transfer> transfers = DebtSimplifier.simplify(positions);
    assertThat(transfers).containsExactly(new Transfer(b, a, new BigDecimal("50.00")));
  }

  @Test
  void chainOfThreeCollapsesIntoOneDirectTransfer() {
    // A owes B RM50, B owes C RM50 -- net positions: A = -50, B = 0, C = +50.
    // The product spec's own example: prefer A -> C RM50 directly.
    UUID a = UUID.randomUUID();
    UUID b = UUID.randomUUID();
    UUID c = UUID.randomUUID();
    List<NetPosition> positions =
        List.of(
            new NetPosition(a, new BigDecimal("-50.00")),
            new NetPosition(b, BigDecimal.ZERO),
            new NetPosition(c, new BigDecimal("50.00")));
    List<Transfer> transfers = DebtSimplifier.simplify(positions);
    assertThat(transfers).containsExactly(new Transfer(a, c, new BigDecimal("50.00")));
  }

  @Test
  void everyoneAlreadySettledProducesNoTransfers() {
    UUID a = UUID.randomUUID();
    UUID b = UUID.randomUUID();
    List<Transfer> transfers =
        DebtSimplifier.simplify(
            List.of(new NetPosition(a, BigDecimal.ZERO), new NetPosition(b, BigDecimal.ZERO)));
    assertThat(transfers).isEmpty();
  }

  @Test
  void multipleCreditorsAndDebtorsReconcileExactly() {
    UUID a = UUID.randomUUID(); // owes 30
    UUID b = UUID.randomUUID(); // owes 20
    UUID c = UUID.randomUUID(); // owed 35
    UUID d = UUID.randomUUID(); // owed 15
    List<NetPosition> positions =
        List.of(
            new NetPosition(a, new BigDecimal("-30.00")),
            new NetPosition(b, new BigDecimal("-20.00")),
            new NetPosition(c, new BigDecimal("35.00")),
            new NetPosition(d, new BigDecimal("15.00")));
    List<Transfer> transfers = DebtSimplifier.simplify(positions);
    assertReconciles(positions, transfers);
    // Fewer transfers than the naive "everyone pays everyone" (6 possible pairs) --
    // the simplification is doing real work, not just relabeling the input.
    assertThat(transfers.size()).isLessThanOrEqualTo(3);
  }

  @Test
  void unevenCentsAcrossManyParticipantsStillReconcilesExactly() {
    List<UUID> ids = java.util.stream.Stream.generate(UUID::randomUUID).limit(7).toList();
    Function<Integer, BigDecimal> amt = BigDecimal::valueOf;
    List<NetPosition> positions =
        List.of(
            new NetPosition(ids.get(0), new BigDecimal("-10.33")),
            new NetPosition(ids.get(1), new BigDecimal("-5.01")),
            new NetPosition(ids.get(2), new BigDecimal("-2.99")),
            new NetPosition(ids.get(3), amt.apply(0).setScale(2)),
            new NetPosition(ids.get(4), new BigDecimal("7.77")),
            new NetPosition(ids.get(5), new BigDecimal("6.11")),
            new NetPosition(ids.get(6), new BigDecimal("4.45")));
    List<Transfer> transfers = DebtSimplifier.simplify(positions);
    assertReconciles(positions, transfers);
  }

  @Test
  void everyTransferAmountIsPositive() {
    UUID a = UUID.randomUUID();
    UUID b = UUID.randomUUID();
    UUID c = UUID.randomUUID();
    List<NetPosition> positions =
        List.of(
            new NetPosition(a, new BigDecimal("-12.50")),
            new NetPosition(b, new BigDecimal("-7.50")),
            new NetPosition(c, new BigDecimal("20.00")));
    List<Transfer> transfers = DebtSimplifier.simplify(positions);
    assertThat(transfers).allMatch(t -> t.amount().signum() > 0);
    assertReconciles(positions, transfers);
  }
}
