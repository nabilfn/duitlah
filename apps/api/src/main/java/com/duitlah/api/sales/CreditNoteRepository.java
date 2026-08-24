package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CreditNoteRepository extends JpaRepository<CreditNote, UUID> {

  Optional<CreditNote> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<CreditNote> findBySpaceIdOrderByIssueDateDesc(UUID spaceId);

  long countBySpaceId(UUID spaceId);

  @Query(
      """
            SELECT COALESCE(SUM(c.amount), 0) FROM CreditNote c
            WHERE c.invoiceId = :invoiceId AND c.status = com.duitlah.api.sales.CreditNoteStatus.ISSUED
            """)
  BigDecimal sumIssuedAmountByInvoiceId(@Param("invoiceId") UUID invoiceId);
}
