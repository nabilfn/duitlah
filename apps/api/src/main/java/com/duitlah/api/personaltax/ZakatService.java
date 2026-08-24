package com.duitlah.api.personaltax;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ZakatService {

  private final ZakatPaymentRepository payments;

  public ZakatService(ZakatPaymentRepository payments) {
    this.payments = payments;
  }

  @Transactional
  public ZakatPaymentResponse record(UUID userId, RecordZakatPaymentRequest request) {
    ZakatPayment payment =
        new ZakatPayment(
            userId,
            request.yearOfAssessment(),
            request.amount(),
            request.paidOn(),
            request.receiptId());
    payment.setNotes(request.notes());
    payments.save(payment);
    return ZakatPaymentResponse.from(payment);
  }

  public List<ZakatPaymentResponse> list(UUID userId, int yearOfAssessment) {
    return payments
        .findByUserIdAndYearOfAssessmentOrderByPaidOnDesc(userId, yearOfAssessment)
        .stream()
        .map(ZakatPaymentResponse::from)
        .toList();
  }

  public BigDecimal totalFor(UUID userId, int yearOfAssessment) {
    return payments.sumByUserIdAndYearOfAssessment(userId, yearOfAssessment);
  }
}
