package com.duitlah.api.personaltax;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Reference data, not user-owned — one row per Year of Assessment (spec section 26). */
@Entity
@Table(name = "tax_years")
@Getter
@Setter
@NoArgsConstructor
public class TaxYear {

  @Id @GeneratedValue private UUID id;

  @Column(name = "year_of_assessment", nullable = false, unique = true)
  private int yearOfAssessment;

  @Column(name = "resident_individual_relief", nullable = false)
  private BigDecimal residentIndividualRelief;

  private String notes;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  @jakarta.persistence.PrePersist
  void onCreate() {
    createdAt = Instant.now();
  }
}
