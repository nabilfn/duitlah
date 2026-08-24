package com.duitlah.api.sales;

import com.duitlah.api.common.jpa.AuditableEntity;
import com.duitlah.api.recurring.RecurrenceFrequency;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * A recurring invoice schedule — the {@code sales} mirror of {@code
 * recurring.RecurringTransaction}'s shape, reusing {@link RecurrenceFrequency}/{@code
 * recurring.RecurrenceCalculator} directly rather than duplicating them (both are already public
 * module surface with no personal-finance-specific coupling). See {@code
 * RecurringInvoiceService#materializeAllDue} for the scheduler that turns a due occurrence into a
 * real, {@code DRAFT} {@link Invoice} — never auto-sent, so a business always reviews before it
 * goes out.
 */
@Entity
@Table(name = "recurring_invoices")
@Getter
@Setter
@NoArgsConstructor
public class RecurringInvoice extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "customer_id", nullable = false)
  private UUID customerId;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "tax_percent", nullable = false)
  private BigDecimal taxPercent;

  private String notes;

  @Column(name = "payment_term_days", nullable = false)
  private int paymentTermDays;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private RecurrenceFrequency frequency;

  @Column(name = "interval_count", nullable = false)
  private int intervalCount;

  @Column(name = "start_date", nullable = false)
  private LocalDate startDate;

  @Column(name = "end_date")
  private LocalDate endDate;

  @Column(name = "next_occurrence_date", nullable = false)
  private LocalDate nextOccurrenceDate;

  @Column(nullable = false)
  private boolean active;

  public RecurringInvoice(
      UUID spaceId,
      UUID customerId,
      UUID createdByUserId,
      BigDecimal taxPercent,
      String notes,
      int paymentTermDays,
      RecurrenceFrequency frequency,
      int intervalCount,
      LocalDate startDate,
      LocalDate endDate) {
    this.spaceId = spaceId;
    this.customerId = customerId;
    this.createdByUserId = createdByUserId;
    this.taxPercent = taxPercent;
    this.notes = notes;
    this.paymentTermDays = paymentTermDays;
    this.frequency = frequency;
    this.intervalCount = intervalCount;
    this.startDate = startDate;
    this.endDate = endDate;
    this.nextOccurrenceDate = startDate;
    this.active = true;
  }
}
