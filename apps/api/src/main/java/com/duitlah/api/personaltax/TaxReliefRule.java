package com.duitlah.api.personaltax;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "tax_relief_rules")
@Getter
@Setter
@NoArgsConstructor
public class TaxReliefRule {

  @Id @GeneratedValue private UUID id;

  @Column(name = "tax_year_id", nullable = false)
  private UUID taxYearId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private PersonalTaxReliefCategory category;

  @Column(name = "max_amount", nullable = false)
  private BigDecimal maxAmount;

  private String description;
}
