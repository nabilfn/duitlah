package com.duitlah.api.settlements;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SettlementPaymentRepository extends JpaRepository<SettlementPayment, UUID> {

  List<SettlementPayment> findBySettlementIdOrderByPaidAtAsc(UUID settlementId);

  @Query(
      "SELECT COALESCE(SUM(p.amount), 0) FROM SettlementPayment p WHERE p.settlementId = :settlementId")
  BigDecimal sumBySettlementId(@Param("settlementId") UUID settlementId);
}
