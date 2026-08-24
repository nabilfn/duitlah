package com.duitlah.api.bizbanking;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "business_accounts")
@Getter
@Setter
@NoArgsConstructor
public class BusinessAccount extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private String name;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private BusinessAccountType type;

  @Column(nullable = false)
  private String currency;

  @Column(name = "opening_balance", nullable = false)
  private BigDecimal openingBalance;

  /**
   * Optional link into the space's Chart of Accounts (V2 Phase 6) — set via {@code
   * BusinessAccountService.mapToChartOfAccounts}; null until a space has set up its books.
   */
  @Column(name = "chart_of_accounts_id")
  private UUID chartOfAccountsId;

  @Column(name = "archived_at")
  private Instant archivedAt;

  public BusinessAccount(
      UUID spaceId,
      String name,
      BusinessAccountType type,
      String currency,
      BigDecimal openingBalance) {
    this.spaceId = spaceId;
    this.name = name;
    this.type = type;
    this.currency = currency;
    this.openingBalance = openingBalance;
  }

  public boolean isArchived() {
    return archivedAt != null;
  }
}
