package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PcbService {

  private final PcbPaymentRepository payments;

  public PcbService(PcbPaymentRepository payments) {
    this.payments = payments;
  }

  /**
   * Recording the same (YA, month) again updates it — a corrected payslip figure, not a duplicate.
   */
  @Transactional
  public PcbPaymentResponse record(UUID userId, RecordPcbPaymentRequest request) {
    PcbPayment payment =
        payments
            .findByUserIdAndYearOfAssessmentAndMonth(
                userId, request.yearOfAssessment(), request.month())
            .orElseGet(
                () ->
                    new PcbPayment(
                        userId, request.yearOfAssessment(), request.month(), request.amount()));
    payment.setAmount(request.amount());
    payment.setNotes(request.notes());
    payments.save(payment);
    return PcbPaymentResponse.from(payment);
  }

  public List<PcbPaymentResponse> list(UUID userId, int yearOfAssessment) {
    return payments
        .findByUserIdAndYearOfAssessmentOrderByMonthAsc(userId, yearOfAssessment)
        .stream()
        .map(PcbPaymentResponse::from)
        .toList();
  }

  public BigDecimal totalFor(UUID userId, int yearOfAssessment) {
    return payments.sumByUserIdAndYearOfAssessment(userId, yearOfAssessment);
  }
}
