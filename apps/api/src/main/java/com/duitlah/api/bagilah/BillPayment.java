package com.duitlah.api.bagilah;

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

@Entity
@Table(name = "bill_payments")
@Getter
@Setter
@NoArgsConstructor
public class BillPayment extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "bill_id", nullable = false)
  private UUID billId;

  @Column(name = "participant_id", nullable = false)
  private UUID participantId;

  @Column(name = "amount_paid", nullable = false)
  private BigDecimal amountPaid;

  public BillPayment(UUID billId, UUID participantId, BigDecimal amountPaid) {
    this.billId = billId;
    this.participantId = participantId;
    this.amountPaid = amountPaid;
  }
}
