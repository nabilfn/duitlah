package com.duitlah.api.inventory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Weighted Average Cost (spec section 48), computed on read, never stored — the same discipline as
 * every other balance in this codebase ({@code bizbanking.BusinessAccountService.balanceOf}, {@code
 * finance.AccountService.balanceOf}). Since every historical movement's own {@code unitCost} was
 * already locked in using the valuation available *at the moment it was created* (see {@link
 * InventoryMovementService}), a plain sum over all movements — order doesn't matter for addition —
 * always reproduces the correct current quantity/value/average; nothing here recomputes or rewrites
 * a past movement's cost.
 */
@Service
public class InventoryValuationService {

  private final InventoryMovementRepository movements;

  public InventoryValuationService(InventoryMovementRepository movements) {
    this.movements = movements;
  }

  public InventoryValuation compute(UUID productId) {
    return compute(movements.findByProductIdOrderByOccurredOnAscCreatedAtAsc(productId));
  }

  InventoryValuation compute(List<InventoryMovement> movementsForProduct) {
    BigDecimal quantity =
        movementsForProduct.stream()
            .map(InventoryMovement::getQuantity)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal value =
        movementsForProduct.stream()
            .map(InventoryMovement::value)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal weightedAverageCost =
        quantity.signum() == 0 ? BigDecimal.ZERO : value.divide(quantity, 4, RoundingMode.HALF_UP);
    return new InventoryValuation(quantity, weightedAverageCost, value);
  }
}
