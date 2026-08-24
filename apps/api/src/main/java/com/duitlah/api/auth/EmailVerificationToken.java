package com.duitlah.api.auth;

import com.duitlah.api.common.jpa.OneTimeToken;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "email_verification_tokens")
@NoArgsConstructor
public class EmailVerificationToken extends OneTimeToken {

  public EmailVerificationToken(UUID userId, String tokenHash, Instant expiresAt) {
    super(userId, tokenHash, expiresAt);
  }
}
