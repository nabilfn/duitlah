package com.duitlah.api.auth;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.Duration;
import java.util.Arrays;
import java.util.Optional;
import org.springframework.http.ResponseCookie;
import org.springframework.stereotype.Component;

@Component
public class RefreshCookieService {

  private final AuthProperties properties;

  public RefreshCookieService(AuthProperties properties) {
    this.properties = properties;
  }

  public void set(HttpServletResponse response, String rawRefreshToken) {
    AuthProperties.Cookie cfg = properties.refreshCookie();
    ResponseCookie cookie =
        ResponseCookie.from(cfg.name(), rawRefreshToken)
            .httpOnly(true)
            .secure(cfg.secure())
            .sameSite(cfg.sameSite())
            .domain(cfg.domain() == null || cfg.domain().isBlank() ? null : cfg.domain())
            .path("/api/v1/auth")
            .maxAge(Duration.ofDays(properties.refreshTokenTtlDays()))
            .build();
    response.addHeader("Set-Cookie", cookie.toString());
  }

  public void clear(HttpServletResponse response) {
    AuthProperties.Cookie cfg = properties.refreshCookie();
    ResponseCookie cookie =
        ResponseCookie.from(cfg.name(), "")
            .httpOnly(true)
            .secure(cfg.secure())
            .sameSite(cfg.sameSite())
            .domain(cfg.domain() == null || cfg.domain().isBlank() ? null : cfg.domain())
            .path("/api/v1/auth")
            .maxAge(0)
            .build();
    response.addHeader("Set-Cookie", cookie.toString());
  }

  public Optional<String> read(HttpServletRequest request) {
    if (request.getCookies() == null) {
      return Optional.empty();
    }
    String name = properties.refreshCookie().name();
    return Arrays.stream(request.getCookies())
        .filter(cookie -> name.equals(cookie.getName()))
        .map(Cookie::getValue)
        .findFirst();
  }
}
