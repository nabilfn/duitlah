package com.duitlah.api.common.jpa;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Shared shape for single-use, expiring, hash-stored tokens (email verification, password reset,
 * and future variants like invite links). The raw token is never persisted — see {@link
 * com.duitlah.api.common.security.SecureTokens}.
 */
@Getter
@Setter
@NoArgsConstructor
@MappedSuperclass
public abstract class OneTimeToken {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "token_hash", nullable = false, unique = true)
  private String tokenHash;

  @Column(name = "expires_at", nullable = false)
  private Instant expiresAt;

  @Column(name = "consumed_at")
  private Instant consumedAt;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  protected OneTimeToken(UUID userId, String tokenHash, Instant expiresAt) {
    this.userId = userId;
    this.tokenHash = tokenHash;
    this.expiresAt = expiresAt;
    this.createdAt = Instant.now();
  }

  public boolean isUsable() {
    return consumedAt == null && expiresAt.isAfter(Instant.now());
  }
}
