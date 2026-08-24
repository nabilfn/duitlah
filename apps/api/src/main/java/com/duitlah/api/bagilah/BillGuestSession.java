package com.duitlah.api.bagilah;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One row per guest device that joined a bill via its invite link — see {@code
 * V7__bagilah_collaboration.sql}. Unlike {@code auth_sessions}, this isn't rotated per request; a
 * guest reuses the same token for their whole window and re-joins via the link once it expires.
 */
@Entity
@Table(name = "bill_guest_sessions")
@Getter
@Setter
@NoArgsConstructor
public class BillGuestSession {

  @Id @GeneratedValue private UUID id;

  @Column(name = "bill_id", nullable = false)
  private UUID billId;

  @Column(name = "participant_id", nullable = false)
  private UUID participantId;

  @Column(name = "token_hash", nullable = false, unique = true)
  private String tokenHash;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  @Column(name = "expires_at", nullable = false)
  private Instant expiresAt;

  public BillGuestSession(UUID billId, UUID participantId, String tokenHash, Instant expiresAt) {
    this.billId = billId;
    this.participantId = participantId;
    this.tokenHash = tokenHash;
    this.createdAt = Instant.now();
    this.expiresAt = expiresAt;
  }

  public boolean isUsable() {
    return expiresAt.isAfter(Instant.now());
  }
}
