package com.duitlah.api.auth;

import com.duitlah.api.common.security.SecureTokens;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Split out from {@link SessionService} for one reason: {@code @Transactional} is proxy-based, so
 * it has no effect on a call from one method to another on the *same* bean (self-invocation
 * bypasses the proxy entirely). Revoking every session in response to detected refresh-token reuse
 * is a security action that must commit even though the caller's own transaction is about to roll
 * back (it's throwing the 401 that denies the request) — REQUIRES_NEW only actually applies here
 * because this is a genuinely separate bean, reached through Spring's proxy.
 */
@Component
public class SessionRevoker {

  private final AuthSessionRepository sessions;

  public SessionRevoker(AuthSessionRepository sessions) {
    this.sessions = sessions;
  }

  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void revokeAllExcept(UUID userId, String keepRawToken) {
    Instant now = Instant.now();
    String keepHash = keepRawToken == null ? null : SecureTokens.hash(keepRawToken);
    List<AuthSession> active =
        sessions.findByUserIdAndRevokedAtIsNullAndExpiresAtAfter(userId, now);
    active.stream()
        .filter(session -> !session.getRefreshTokenHash().equals(keepHash))
        .forEach(session -> session.setRevokedAt(now));
    sessions.saveAll(active);
  }
}
