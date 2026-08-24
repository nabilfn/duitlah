package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PcbPaymentRepository extends JpaRepository<PcbPayment, UUID> {

  List<PcbPayment> findByUserIdAndYearOfAssessmentOrderByMonthAsc(
      UUID userId, int yearOfAssessment);

  Optional<PcbPayment> findByUserIdAndYearOfAssessmentAndMonth(
      UUID userId, int yearOfAssessment, int month);

  @Query(
      "SELECT COALESCE(SUM(p.amount), 0) FROM PcbPayment p WHERE p.userId = :userId AND p.yearOfAssessment = :ya")
  BigDecimal sumByUserIdAndYearOfAssessment(
      @Param("userId") UUID userId, @Param("ya") int yearOfAssessment);
}
