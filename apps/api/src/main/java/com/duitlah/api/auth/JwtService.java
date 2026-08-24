package com.duitlah.api.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;
import javax.crypto.SecretKey;
import org.springframework.stereotype.Service;

/**
 * Issues and verifies short-lived access tokens. The JWT is stateless and carries no revocation
 * state by design — that's what the refresh-token session (see {@link AuthSession}) is for. An
 * access token can't be revoked early; keep its TTL short (default 15 minutes,
 * duitlah.auth.access-token-ttl-minutes) so a compromised token has a bounded lifetime.
 */
@Service
public class JwtService {

  private final SecretKey signingKey;
  private final int accessTokenTtlMinutes;

  public JwtService(AuthProperties properties) {
    this.signingKey = Keys.hmacShaKeyFor(properties.jwtSecret().getBytes(StandardCharsets.UTF_8));
    this.accessTokenTtlMinutes = properties.accessTokenTtlMinutes();
  }

  public String generateAccessToken(UUID userId) {
    Instant now = Instant.now();
    return Jwts.builder()
        .subject(userId.toString())
        .issuedAt(Date.from(now))
        .expiration(Date.from(now.plus(accessTokenTtlMinutes, ChronoUnit.MINUTES)))
        .signWith(signingKey)
        .compact();
  }

  /** Returns empty rather than throwing on any invalid/expired/malformed token. */
  public Optional<UUID> validateAndGetUserId(String token) {
    try {
      Claims claims =
          Jwts.parser().verifyWith(signingKey).build().parseSignedClaims(token).getPayload();
      return Optional.of(UUID.fromString(claims.getSubject()));
    } catch (JwtException | IllegalArgumentException e) {
      return Optional.empty();
    }
  }
}
