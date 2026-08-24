package com.duitlah.api.businesstax;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
 * One row per phase of the e-Invoice mandate rollout — {@code revenueThreshold} is the minimum
 * annual revenue, as of {@code effectiveDate}, above which e-Invoicing is mandatory. See
 * package-info's honesty note; spec section 57 explicitly warns against a single hardcoded
 * threshold.
 */
@Entity
@Table(name = "einvoice_mandate_rules")
@Getter
@Setter
@NoArgsConstructor
public class EInvoiceMandateRule {

  @Id @GeneratedValue private UUID id;

  @Column(name = "effective_date", nullable = false)
  private LocalDate effectiveDate;

  @Column(name = "revenue_threshold", nullable = false)
  private BigDecimal revenueThreshold;

  @Column(nullable = false)
  private String description;
}
