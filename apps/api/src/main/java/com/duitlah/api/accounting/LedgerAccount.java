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
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * A row in a business space's Chart of Accounts (table {@code chart_of_accounts} — named {@code
 * LedgerAccount} here, not {@code Account}, to avoid colliding with {@code finance.Account} and
 * {@code bizbanking.BusinessAccount}, neither of which this is).
 */
@Entity
@Table(name = "chart_of_accounts")
@Getter
@Setter
@NoArgsConstructor
public class LedgerAccount extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private String code;

  @Column(nullable = false)
  private String name;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private AccountType type;

  @Column(name = "system_default", nullable = false)
  private boolean systemDefault;

  @Column(name = "cash_equivalent", nullable = false)
  private boolean cashEquivalent;

  @Column(name = "archived_at")
  private Instant archivedAt;

  public LedgerAccount(
      UUID spaceId,
      String code,
      String name,
      AccountType type,
      boolean systemDefault,
      boolean cashEquivalent) {
    this.spaceId = spaceId;
    this.code = code;
    this.name = name;
    this.type = type;
    this.systemDefault = systemDefault;
    this.cashEquivalent = cashEquivalent;
  }

  public boolean isArchived() {
    return archivedAt != null;
  }
}
