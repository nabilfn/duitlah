package com.duitlah.api.catalog;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, UUID> {

  Optional<Product> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<Product> findBySpaceIdOrderByNameAsc(UUID spaceId);

  long countBySpaceId(UUID spaceId);

  /** Candidates for low-stock evaluation — see {@code inventory.LowStockAlertScheduler}. */
  List<Product> findBySpaceIdAndTrackInventoryTrueAndReorderPointIsNotNull(UUID spaceId);

  List<Product> findBySpaceIdAndTrackInventoryTrueOrderByNameAsc(UUID spaceId);
}
