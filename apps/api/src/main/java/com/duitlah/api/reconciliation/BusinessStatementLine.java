package com.duitlah.api.reconciliation;

import com.duitlah.api.common.jpa.AuditableEntity;
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
 * {@code amount} is signed exactly like {@code statements.ParsedStatementRow} — positive = money
 * in, negative = money out. Unlike that one-shot row, this entity's {@code status} genuinely
 * mutates across a reconciliation session's lifetime.
 */
@Entity
@Table(name = "business_statement_lines")
@Getter
@Setter
@NoArgsConstructor
public class BusinessStatementLine extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "business_statement_import_id", nullable = false)
  private UUID businessStatementImportId;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  private String description;

  @Column(nullable = false)
  private BigDecimal amount;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private StatementLineStatus status;

  public BusinessStatementLine(
      UUID businessStatementImportId, LocalDate occurredOn, String description, BigDecimal amount) {
    this.businessStatementImportId = businessStatementImportId;
    this.occurredOn = occurredOn;
    this.description = description;
    this.amount = amount;
    this.status = StatementLineStatus.UNMATCHED;
  }
}
