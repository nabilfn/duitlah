package com.duitlah.api.auth;

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

/** One row per refresh token in circulation for a user — see V2__auth.sql. */
@Entity
@Table(name = "auth_sessions")
@Getter
@Setter
@NoArgsConstructor
public class AuthSession {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(name = "refresh_token_hash", nullable = false, unique = true)
  private String refreshTokenHash;

  @Column(name = "user_agent")
  private String userAgent;

  @Column(name = "ip_address")
  private String ipAddress;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  @Column(name = "last_used_at", nullable = false)
  private Instant lastUsedAt;

  @Column(name = "expires_at", nullable = false)
  private Instant expiresAt;

  @Column(name = "revoked_at")
  private Instant revokedAt;

  public AuthSession(
      UUID userId, String refreshTokenHash, String userAgent, String ipAddress, Instant expiresAt) {
    Instant now = Instant.now();
    this.userId = userId;
    this.refreshTokenHash = refreshTokenHash;
    this.userAgent = userAgent;
    this.ipAddress = ipAddress;
    this.createdAt = now;
    this.lastUsedAt = now;
    this.expiresAt = expiresAt;
  }

  public boolean isActive() {
    return revokedAt == null && expiresAt.isAfter(Instant.now());
  }
}
