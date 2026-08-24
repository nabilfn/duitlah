package com.duitlah.api.liabilities;

import com.duitlah.api.common.jpa.AuditableEntity;
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

/**
 * One-to-one with a {@code finance.Account} of type {@code CREDIT_CARD}. Statement balance, current
 * outstanding, available credit, and utilization are all computed on read (see {@link
 * CreditCardService}) — nothing here duplicates state {@code AccountService#balanceOf} already
 * derives from the account's own transaction history.
 */
@Entity
@Table(name = "credit_card_details")
@Getter
@Setter
@NoArgsConstructor
public class CreditCardDetails extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "account_id", nullable = false, unique = true)
  private UUID accountId;

  @Column(name = "credit_limit", nullable = false)
  private BigDecimal creditLimit;

  @Column(name = "statement_day", nullable = false)
  private short statementDay;

  @Column(name = "payment_due_day", nullable = false)
  private short paymentDueDay;

  @Column(name = "minimum_payment_percent", nullable = false)
  private BigDecimal minimumPaymentPercent;

  public CreditCardDetails(
      UUID accountId,
      BigDecimal creditLimit,
      int statementDay,
      int paymentDueDay,
      BigDecimal minimumPaymentPercent) {
    this.accountId = accountId;
    this.creditLimit = creditLimit;
    this.statementDay = (short) statementDay;
    this.paymentDueDay = (short) paymentDueDay;
    this.minimumPaymentPercent = minimumPaymentPercent;
  }
}
