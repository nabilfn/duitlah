package com.duitlah.api.bizexpenses;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ExpensePaymentRepository extends JpaRepository<ExpensePayment, UUID> {

  List<ExpensePayment> findByBusinessExpenseIdOrderByPaidOnDesc(UUID businessExpenseId);

  @Query(
      "SELECT COALESCE(SUM(p.amount), 0) FROM ExpensePayment p WHERE p.businessExpenseId = :businessExpenseId")
  BigDecimal sumAmountByBusinessExpenseId(@Param("businessExpenseId") UUID businessExpenseId);
}
