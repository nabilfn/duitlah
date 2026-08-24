package com.duitlah.api.finance;

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

/**
 * A financial account (bank, e-wallet, cash, credit card, ...). Balance is deliberately NOT stored
 * on this entity — see {@link AccountService} for why: it's computed as openingBalance + the signed
 * sum of the account's transactions, so it can never drift out of sync with transaction history.
 */
@Entity
@Table(name = "accounts")
@Getter
@Setter
@NoArgsConstructor
public class Account extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(nullable = false)
  private String name;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private AccountType type;

  @Column(nullable = false)
  private String currency;

  @Column(name = "opening_balance", nullable = false)
  private BigDecimal openingBalance;

  @Column(name = "archived_at")
  private Instant archivedAt;

  public Account(
      UUID userId, String name, AccountType type, String currency, BigDecimal openingBalance) {
    this.userId = userId;
    this.name = name;
    this.type = type;
    this.currency = currency;
    this.openingBalance = openingBalance;
  }

  public boolean isArchived() {
    return archivedAt != null;
  }
}
