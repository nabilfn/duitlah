package com.duitlah.api.auth;

import com.duitlah.api.common.security.SecureTokens;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class SessionService {

  private final AuthSessionRepository sessions;
  private final AuthProperties properties;
  private final SessionRevoker revoker;

  public SessionService(
      AuthSessionRepository sessions, AuthProperties properties, SessionRevoker revoker) {
    this.sessions = sessions;
    this.properties = properties;
    this.revoker = revoker;
  }

  /**
   * Returns the raw refresh token — the only place it ever exists outside a client's cookie jar.
   */
  public String createSession(UUID userId, String userAgent, String ipAddress) {
    String rawToken = SecureTokens.generate();
    Instant expiresAt = Instant.now().plus(properties.refreshTokenTtlDays(), ChronoUnit.DAYS);
    sessions.save(
        new AuthSession(userId, SecureTokens.hash(rawToken), userAgent, ipAddress, expiresAt));
    return rawToken;
  }

  public record Rotated(UUID userId, String rawRefreshToken) {}

  /**
   * Rotates a refresh token: the presented token is revoked and a new one issued in its place. If
   * the presented token was already revoked (i.e. reused after rotation — a signal the token was
   * stolen and used by two parties), every other active session for that user is revoked too, and
   * this call is denied. Returns empty for any unrecognized, expired, or reused token.
   */
  public Optional<Rotated> rotate(String rawRefreshToken, String userAgent, String ipAddress) {
    String hash = SecureTokens.hash(rawRefreshToken);
    Optional<AuthSession> found = sessions.findByRefreshTokenHash(hash);
    if (found.isEmpty()) {
      return Optional.empty();
    }

    AuthSession session = found.get();
    if (session.getRevokedAt() != null) {
      revoker.revokeAllExcept(session.getUserId(), null);
      return Optional.empty();
    }
    if (session.getExpiresAt().isBefore(Instant.now())) {
      return Optional.empty();
    }

    session.setRevokedAt(Instant.now());
    sessions.save(session);

    String newRawToken = createSession(session.getUserId(), userAgent, ipAddress);
    return Optional.of(new Rotated(session.getUserId(), newRawToken));
  }

  public void revokeSession(String rawRefreshToken) {
    sessions
        .findByRefreshTokenHash(SecureTokens.hash(rawRefreshToken))
        .ifPresent(
            session -> {
              session.setRevokedAt(Instant.now());
              sessions.save(session);
            });
  }

  public void revokeSessionById(UUID userId, UUID sessionId) {
    sessions
        .findById(sessionId)
        .filter(session -> session.getUserId().equals(userId))
        .ifPresent(
            session -> {
              session.setRevokedAt(Instant.now());
              sessions.save(session);
            });
  }

  public void revokeAllSessions(UUID userId) {
    revoker.revokeAllExcept(userId, null);
  }

  /**
   * Revokes every active session for the user except the one matching {@code keepRawToken}, if any.
   */
  public void revokeAllSessionsExcept(UUID userId, String keepRawToken) {
    revoker.revokeAllExcept(userId, keepRawToken);
  }

  public List<AuthSession> listActiveSessions(UUID userId) {
    return sessions.findByUserIdAndRevokedAtIsNullAndExpiresAtAfter(userId, Instant.now());
  }
}
