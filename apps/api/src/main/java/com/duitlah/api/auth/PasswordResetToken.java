package com.duitlah.api.auth;

import com.duitlah.api.common.jpa.OneTimeToken;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "password_reset_tokens")
@NoArgsConstructor
public class PasswordResetToken extends OneTimeToken {

  public PasswordResetToken(UUID userId, String tokenHash, Instant expiresAt) {
    super(userId, tokenHash, expiresAt);
  }
}
