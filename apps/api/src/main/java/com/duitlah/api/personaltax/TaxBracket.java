package com.duitlah.api.personaltax;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** {@code upperBound} null = the top, unbounded bracket. */
@Entity
@Table(name = "tax_brackets")
@Getter
@Setter
@NoArgsConstructor
public class TaxBracket {

  @Id @GeneratedValue private UUID id;

  @Column(name = "tax_year_id", nullable = false)
  private UUID taxYearId;

  @Column(name = "lower_bound", nullable = false)
  private BigDecimal lowerBound;

  @Column(name = "upper_bound")
  private BigDecimal upperBound;

  @Column(name = "rate_percent", nullable = false)
  private BigDecimal ratePercent;
}
