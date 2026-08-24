package com.duitlah.api.bagilah;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BillParticipantRepository extends JpaRepository<BillParticipant, UUID> {

  List<BillParticipant> findByBillIdOrderByCreatedAtAsc(UUID billId);

  Optional<BillParticipant> findByIdAndBillId(UUID id, UUID billId);

  boolean existsByBillIdAndUserId(UUID billId, UUID userId);

  Optional<BillParticipant> findByBillIdAndUserId(UUID billId, UUID userId);
}
