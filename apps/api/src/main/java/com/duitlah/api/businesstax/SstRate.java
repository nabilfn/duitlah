package com.duitlah.api.businesstax;

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
 * A global, versioned reference row — see package-info's honesty note. {@code effectiveTo} null =
 * still in effect.
 */
@Entity
@Table(name = "sst_rates")
@Getter
@Setter
@NoArgsConstructor
public class SstRate {

  @Id @GeneratedValue private UUID id;

  @Enumerated(EnumType.STRING)
  @Column(name = "tax_type", nullable = false)
  private SstTaxType taxType;

  @Column(name = "rate_percent", nullable = false)
  private BigDecimal ratePercent;

  @Column(name = "effective_from", nullable = false)
  private LocalDate effectiveFrom;

  @Column(name = "effective_to")
  private LocalDate effectiveTo;

  @Column(nullable = false)
  private String description;
}
