package com.duitlah.api.auth;

import java.time.Instant;
import java.util.UUID;

public record SessionResponse(
    UUID id,
    String userAgent,
    String ipAddress,
    Instant createdAt,
    Instant lastUsedAt,
    boolean current) {

  public static SessionResponse from(AuthSession session, boolean current) {
    return new SessionResponse(
        session.getId(),
        session.getUserAgent(),
        session.getIpAddress(),
        session.getCreatedAt(),
        session.getLastUsedAt(),
        current);
  }
}
