package com.duitlah.api.sales;

import com.duitlah.api.recurring.RecurrenceFrequency;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record RecurringInvoiceResponse(
    UUID id,
    UUID customerId,
    BigDecimal taxPercent,
    String notes,
    int paymentTermDays,
    RecurrenceFrequency frequency,
    int intervalCount,
    LocalDate startDate,
    LocalDate endDate,
    LocalDate nextOccurrenceDate,
    boolean active,
    List<RecurringInvoiceLineItemResponse> lineItems) {

  static RecurringInvoiceResponse of(
      RecurringInvoice rule, List<RecurringInvoiceLineItemResponse> lineItems) {
    return new RecurringInvoiceResponse(
        rule.getId(),
        rule.getCustomerId(),
        rule.getTaxPercent(),
        rule.getNotes(),
        rule.getPaymentTermDays(),
        rule.getFrequency(),
        rule.getIntervalCount(),
        rule.getStartDate(),
        rule.getEndDate(),
        rule.getNextOccurrenceDate(),
        rule.isActive(),
        lineItems);
  }
}
