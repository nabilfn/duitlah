package com.duitlah.api.accounting;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "accounting_periods")
@Getter
@Setter
@NoArgsConstructor
public class AccountingPeriod extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "period_start", nullable = false)
  private LocalDate periodStart;

  @Column(name = "period_end", nullable = false)
  private LocalDate periodEnd;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private PeriodStatus status;

  @Column(name = "closed_at")
  private Instant closedAt;

  public AccountingPeriod(UUID spaceId, LocalDate periodStart, LocalDate periodEnd) {
    this.spaceId = spaceId;
    this.periodStart = periodStart;
    this.periodEnd = periodEnd;
    this.status = PeriodStatus.OPEN;
  }

  public boolean covers(LocalDate date) {
    return !date.isBefore(periodStart) && !date.isAfter(periodEnd);
  }
}
