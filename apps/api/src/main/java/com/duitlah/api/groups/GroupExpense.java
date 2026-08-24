package com.duitlah.api.groups;

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

@Entity
@Table(name = "group_expenses")
@Getter
@Setter
@NoArgsConstructor
public class GroupExpense extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "group_id", nullable = false)
  private UUID groupId;

  @Column(name = "paid_by_user_id", nullable = false)
  private UUID paidByUserId;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(nullable = false)
  private String description;

  @Column(nullable = false)
  private BigDecimal amount;

  @Column(name = "occurred_on", nullable = false)
  private LocalDate occurredOn;

  @Enumerated(EnumType.STRING)
  private GroupExpenseCategory category;

  /**
   * Trip mode's currency snapshot (see V11__special_group_modes.sql) -- display metadata only.
   * {@code amount} above is always the real MYR figure every balance/settlement computation uses.
   */
  @Column(name = "original_currency")
  private String originalCurrency;

  @Column(name = "original_amount")
  private BigDecimal originalAmount;

  @Column(name = "exchange_rate")
  private BigDecimal exchangeRate;

  public GroupExpense(
      UUID groupId,
      UUID paidByUserId,
      UUID createdByUserId,
      String description,
      BigDecimal amount,
      LocalDate occurredOn) {
    this.groupId = groupId;
    this.paidByUserId = paidByUserId;
    this.createdByUserId = createdByUserId;
    this.description = description;
    this.amount = amount;
    this.occurredOn = occurredOn;
  }
}
