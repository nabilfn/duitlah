package com.duitlah.api.groups;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "group_expense_shares")
@Getter
@Setter
@NoArgsConstructor
public class GroupExpenseShare {

  @Id @GeneratedValue private UUID id;

  @Column(name = "group_expense_id", nullable = false)
  private UUID groupExpenseId;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(nullable = false)
  private BigDecimal amount;

  public GroupExpenseShare(UUID groupExpenseId, UUID userId, BigDecimal amount) {
    this.groupExpenseId = groupExpenseId;
    this.userId = userId;
    this.amount = amount;
  }
}
