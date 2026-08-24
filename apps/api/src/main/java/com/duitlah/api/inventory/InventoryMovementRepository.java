package com.duitlah.api.inventory;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InventoryMovementRepository extends JpaRepository<InventoryMovement, UUID> {

  Optional<InventoryMovement> findByIdAndSpaceId(UUID id, UUID spaceId);

  /**
   * Chronological order (occurred date, then insertion order for same-day movements) — required for
   * a correct Weighted Average Cost replay.
   */
  List<InventoryMovement> findByProductIdOrderByOccurredOnAscCreatedAtAsc(UUID productId);

  /** Newest-first — for a human-facing movement history list. */
  List<InventoryMovement> findByProductIdOrderByOccurredOnDescCreatedAtDesc(UUID productId);

  List<InventoryMovement> findBySpaceIdAndTypeAndOccurredOnBetween(
      UUID spaceId, MovementType type, LocalDate from, LocalDate to);

  boolean existsBySourceInvoiceLineItemId(UUID sourceInvoiceLineItemId);
}
