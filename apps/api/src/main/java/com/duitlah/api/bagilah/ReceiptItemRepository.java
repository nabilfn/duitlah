package com.duitlah.api.bagilah;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReceiptItemRepository extends JpaRepository<ReceiptItem, UUID> {

  List<ReceiptItem> findByBillIdOrderByCreatedAtAsc(UUID billId);

  Optional<ReceiptItem> findByIdAndBillId(UUID id, UUID billId);
}
