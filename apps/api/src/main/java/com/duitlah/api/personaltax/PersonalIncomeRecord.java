package com.duitlah.api.personaltax;

import com.duitlah.api.common.jpa.AuditableEntity;
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
@Table(name = "personal_income_records")
@Getter
@Setter
@NoArgsConstructor
public class PersonalIncomeRecord extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "year_of_assessment", nullable = false)
  private int yearOfAssessment;

  @Enumerated(EnumType.STRING)
  @Column(name = "income_type", nullable = false)
  private IncomeType incomeType;

  @Column(nullable = false)
  private BigDecimal amount;

  private String description;

  public PersonalIncomeRecord(
      UUID userId, UUID spaceId, int yearOfAssessment, IncomeType incomeType, BigDecimal amount) {
    this.userId = userId;
    this.spaceId = spaceId;
    this.yearOfAssessment = yearOfAssessment;
    this.incomeType = incomeType;
    this.amount = amount;
  }
}
