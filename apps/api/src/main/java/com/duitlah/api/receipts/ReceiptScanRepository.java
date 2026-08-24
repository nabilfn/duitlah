package com.duitlah.api.receipts;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReceiptScanRepository extends JpaRepository<ReceiptScan, UUID> {

  List<ReceiptScan> findByOwnerUserIdOrderByCreatedAtDesc(UUID ownerUserId);

  Optional<ReceiptScan> findByIdAndOwnerUserId(UUID id, UUID ownerUserId);

  long countByOwnerUserIdAndCreatedAtBetween(UUID ownerUserId, Instant from, Instant to);
}
