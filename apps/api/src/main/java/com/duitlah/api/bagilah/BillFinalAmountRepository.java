package com.duitlah.api.bagilah;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BillFinalAmountRepository extends JpaRepository<BillFinalAmount, UUID> {

  List<BillFinalAmount> findByBillId(UUID billId);
}
