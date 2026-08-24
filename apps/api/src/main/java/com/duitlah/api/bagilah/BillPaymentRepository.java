package com.duitlah.api.bagilah;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BillPaymentRepository extends JpaRepository<BillPayment, UUID> {

  List<BillPayment> findByBillId(UUID billId);

  Optional<BillPayment> findByBillIdAndParticipantId(UUID billId, UUID participantId);
}
