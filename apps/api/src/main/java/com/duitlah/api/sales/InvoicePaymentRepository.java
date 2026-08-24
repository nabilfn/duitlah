package com.duitlah.api.sales;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface InvoicePaymentRepository extends JpaRepository<InvoicePayment, UUID> {

  List<InvoicePayment> findByInvoiceIdOrderByPaidOnDesc(UUID invoiceId);

  @Query("SELECT COALESCE(SUM(p.amount), 0) FROM InvoicePayment p WHERE p.invoiceId = :invoiceId")
  BigDecimal sumAmountByInvoiceId(@Param("invoiceId") UUID invoiceId);
}
