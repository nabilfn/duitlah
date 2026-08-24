package com.duitlah.api.auth;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "duitlah.auth")
public record AuthProperties(
    String jwtSecret, int accessTokenTtlMinutes, int refreshTokenTtlDays, Cookie refreshCookie) {

  public record Cookie(String name, String sameSite, boolean secure, String domain) {}
}
