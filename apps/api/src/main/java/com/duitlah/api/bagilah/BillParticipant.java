package com.duitlah.api.bagilah;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "bill_participants")
@Getter
@Setter
@NoArgsConstructor
public class BillParticipant extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "bill_id", nullable = false)
  private UUID billId;

  @Column(name = "user_id")
  private UUID userId;

  @Column(name = "guest_name")
  private String guestName;

  public BillParticipant(UUID billId, UUID userId, String guestName) {
    this.billId = billId;
    this.userId = userId;
    this.guestName = guestName;
  }

  public boolean isGuest() {
    return userId == null;
  }
}
