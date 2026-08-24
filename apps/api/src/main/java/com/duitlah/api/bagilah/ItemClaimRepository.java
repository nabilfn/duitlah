package com.duitlah.api.bagilah;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ItemClaimRepository extends JpaRepository<ItemClaim, UUID> {

  List<ItemClaim> findByReceiptItemId(UUID receiptItemId);

  Optional<ItemClaim> findByIdAndReceiptItemId(UUID id, UUID receiptItemId);

  Optional<ItemClaim> findByReceiptItemIdAndParticipantId(UUID receiptItemId, UUID participantId);

  @Query(
      """
      SELECT c FROM ItemClaim c
      WHERE c.receiptItemId IN (SELECT i.id FROM ReceiptItem i WHERE i.billId = :billId)
      """)
  List<ItemClaim> findAllByBillId(@Param("billId") UUID billId);
}
