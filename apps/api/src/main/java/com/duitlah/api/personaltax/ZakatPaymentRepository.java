package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ZakatPaymentRepository extends JpaRepository<ZakatPayment, UUID> {

  List<ZakatPayment> findByUserIdAndYearOfAssessmentOrderByPaidOnDesc(
      UUID userId, int yearOfAssessment);

  @Query(
      "SELECT COALESCE(SUM(z.amount), 0) FROM ZakatPayment z WHERE z.userId = :userId AND z.yearOfAssessment = :ya")
  BigDecimal sumByUserIdAndYearOfAssessment(
      @Param("userId") UUID userId, @Param("ya") int yearOfAssessment);
}
