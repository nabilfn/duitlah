package com.duitlah.api.auth;

import com.duitlah.api.common.error.TooManyRequestsException;
import com.duitlah.api.common.error.UnauthorizedException;
import com.duitlah.api.common.security.SecureTokens;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import java.time.Duration;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthController {

  private final AuthService authService;
  private final SessionService sessionService;
  private final RefreshCookieService refreshCookies;
  private final RateLimiter rateLimiter;

  public AuthController(
      AuthService authService,
      SessionService sessionService,
      RefreshCookieService refreshCookies,
      RateLimiter rateLimiter) {
    this.authService = authService;
    this.sessionService = sessionService;
    this.refreshCookies = refreshCookies;
    this.rateLimiter = rateLimiter;
  }

  @PostMapping("/api/v1/auth/register")
  @ResponseStatus(HttpStatus.CREATED)
  public AuthTokenResponse register(
      @Valid @RequestBody RegisterRequest request,
      HttpServletRequest req,
      HttpServletResponse res) {
    requireUnderLimit("register:" + clientIp(req), 5, Duration.ofHours(1));

    AuthService.AuthResult result = authService.register(request, userAgent(req), clientIp(req));
    refreshCookies.set(res, result.rawRefreshToken());
    return new AuthTokenResponse(result.accessToken(), result.user());
  }

  @PostMapping("/api/v1/auth/login")
  public AuthTokenResponse login(
      @Valid @RequestBody LoginRequest request, HttpServletRequest req, HttpServletResponse res) {
    requireUnderLimit("login-ip:" + clientIp(req), 20, Duration.ofMinutes(15));
    requireUnderLimit(
        "login-email:" + request.email().trim().toLowerCase(), 8, Duration.ofMinutes(15));

    AuthService.AuthResult result = authService.login(request, userAgent(req), clientIp(req));
    refreshCookies.set(res, result.rawRefreshToken());
    return new AuthTokenResponse(result.accessToken(), result.user());
  }

  @PostMapping("/api/v1/auth/refresh")
  public RefreshResponse refresh(HttpServletRequest req, HttpServletResponse res) {
    String rawToken =
        refreshCookies
            .read(req)
            .orElseThrow(
                () ->
                    new UnauthorizedException("MISSING_REFRESH_TOKEN", "No active session found."));

    AuthService.RefreshResult result = authService.refresh(rawToken, userAgent(req), clientIp(req));
    refreshCookies.set(res, result.rawRefreshToken());
    return new RefreshResponse(result.accessToken());
  }

  @PostMapping("/api/v1/auth/logout")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void logout(HttpServletRequest req, HttpServletResponse res) {
    refreshCookies.read(req).ifPresent(sessionService::revokeSession);
    refreshCookies.clear(res);
  }

  @PostMapping("/api/v1/auth/logout-all")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void logoutAll(@AuthenticationPrincipal UUID userId, HttpServletResponse res) {
    sessionService.revokeAllSessions(userId);
    refreshCookies.clear(res);
  }

  @GetMapping("/api/v1/auth/sessions")
  public List<SessionResponse> listSessions(
      @AuthenticationPrincipal UUID userId, HttpServletRequest req) {
    String currentRawToken = refreshCookies.read(req).orElse(null);
    String currentHash = currentRawToken == null ? null : SecureTokens.hash(currentRawToken);
    return sessionService.listActiveSessions(userId).stream()
        .map(
            session ->
                SessionResponse.from(session, session.getRefreshTokenHash().equals(currentHash)))
        .toList();
  }

  @DeleteMapping("/api/v1/auth/sessions/{sessionId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void revokeSession(@AuthenticationPrincipal UUID userId, @PathVariable UUID sessionId) {
    sessionService.revokeSessionById(userId, sessionId);
  }

  @PostMapping("/api/v1/auth/verify-email")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void verifyEmail(@Valid @RequestBody VerifyEmailRequest request) {
    authService.verifyEmail(request.token());
  }

  @PostMapping("/api/v1/auth/verify-email/resend")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void resendVerificationEmail(@AuthenticationPrincipal UUID userId) {
    requireUnderLimit("resend-verify:" + userId, 3, Duration.ofHours(1));
    authService.resendVerificationEmail(userId);
  }

  @PostMapping("/api/v1/auth/password-reset/request")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void requestPasswordReset(
      @Valid @RequestBody PasswordResetRequestRequest request, HttpServletRequest req) {
    requireUnderLimit("reset-ip:" + clientIp(req), 5, Duration.ofHours(1));
    requireUnderLimit(
        "reset-email:" + request.email().trim().toLowerCase(), 3, Duration.ofHours(1));
    authService.requestPasswordReset(request.email());
  }

  @PostMapping("/api/v1/auth/password-reset/confirm")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void confirmPasswordReset(@Valid @RequestBody PasswordResetConfirmRequest request) {
    authService.confirmPasswordReset(request.token(), request.newPassword());
  }

  private void requireUnderLimit(String key, int limit, Duration window) {
    if (!rateLimiter.allow(key, limit, window)) {
      throw new TooManyRequestsException("Too many attempts. Please try again later.");
    }
  }

  private String userAgent(HttpServletRequest request) {
    String value = request.getHeader("User-Agent");
    return value == null ? "unknown" : value.substring(0, Math.min(value.length(), 255));
  }

  private String clientIp(HttpServletRequest request) {
    return request.getRemoteAddr();
  }
}
