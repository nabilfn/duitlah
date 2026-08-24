package com.duitlah.api.transactionrules;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * A merchant-to-category suggestion rule — either hand-authored by the user or auto-learned (see
 * {@link #learned}) from confirming an AutoTrack candidate. Never applied automatically; only ever
 * consulted by {@code autotrack.CategorySuggestionService} as a suggestion a human still confirms.
 */
@Entity
@Table(name = "transaction_rules")
@Getter
@Setter
@NoArgsConstructor
public class TransactionRule extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Enumerated(EnumType.STRING)
  @Column(name = "match_type", nullable = false)
  private TransactionRuleMatchType matchType;

  @Column(name = "match_value", nullable = false)
  private String matchValue;

  @Column(name = "category_id", nullable = false)
  private UUID categoryId;

  @Column(nullable = false)
  private int priority;

  @Column(nullable = false)
  private boolean active;

  @Column(nullable = false)
  private boolean learned;

  public TransactionRule(
      UUID userId,
      TransactionRuleMatchType matchType,
      String matchValue,
      UUID categoryId,
      int priority,
      boolean learned) {
    this.userId = userId;
    this.matchType = matchType;
    this.matchValue = matchValue;
    this.categoryId = categoryId;
    this.priority = priority;
    this.active = true;
    this.learned = learned;
  }

  public boolean matches(String merchant) {
    if (merchant == null || matchValue == null) {
      return false;
    }
    String a = merchant.trim().toLowerCase();
    String b = matchValue.trim().toLowerCase();
    return matchType == TransactionRuleMatchType.MERCHANT_EQUALS ? a.equals(b) : a.contains(b);
  }
}
