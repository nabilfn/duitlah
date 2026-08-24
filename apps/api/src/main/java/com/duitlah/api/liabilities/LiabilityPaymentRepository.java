package com.duitlah.api.liabilities;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface LiabilityPaymentRepository extends JpaRepository<LiabilityPayment, UUID> {

  List<LiabilityPayment> findByLiabilityIdOrderByPaidOnDesc(UUID liabilityId);

  @Query(
      "SELECT COALESCE(SUM(p.principalPortion), 0) FROM LiabilityPayment p WHERE p.liabilityId = :liabilityId")
  BigDecimal sumPrincipalPortionByLiabilityId(@Param("liabilityId") UUID liabilityId);
}
