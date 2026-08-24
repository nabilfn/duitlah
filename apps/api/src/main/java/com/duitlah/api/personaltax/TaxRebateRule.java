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

@Entity
@Table(name = "tax_rebate_rules")
@Getter
@Setter
@NoArgsConstructor
public class TaxRebateRule {

  @Id @GeneratedValue private UUID id;

  @Column(name = "tax_year_id", nullable = false)
  private UUID taxYearId;

  @Column(name = "chargeable_income_threshold", nullable = false)
  private BigDecimal chargeableIncomeThreshold;

  @Column(name = "rebate_amount", nullable = false)
  private BigDecimal rebateAmount;

  private String description;
}
