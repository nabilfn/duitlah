package com.duitlah.api.auth;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.UnauthorizedException;
import com.duitlah.api.common.mail.EmailSender;
import com.duitlah.api.common.security.SecureTokens;
import com.duitlah.api.groups.GroupRepository;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.telemetry.ProductAnalyticsService;
import com.duitlah.api.users.User;
import com.duitlah.api.users.UserRepository;
import com.duitlah.api.users.UserResponse;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

  private static final int VERIFICATION_TOKEN_TTL_HOURS = 24;
  private static final int RESET_TOKEN_TTL_MINUTES = 30;

  private final UserRepository users;
  private final EmailVerificationTokenRepository verificationTokens;
  private final PasswordResetTokenRepository resetTokens;
  private final SessionService sessions;
  private final JwtService jwt;
  private final PasswordEncoder passwordEncoder;
  private final EmailSender emailSender;
  private final String frontendUrl;
  private final AuditLogService auditLogService;
  private final ProductAnalyticsService productAnalyticsService;
  private final GroupRepository groups;
  private final SpaceService spaceService;

  public AuthService(
      UserRepository users,
      EmailVerificationTokenRepository verificationTokens,
      PasswordResetTokenRepository resetTokens,
      SessionService sessions,
      JwtService jwt,
      PasswordEncoder passwordEncoder,
      EmailSender emailSender,
      @Value("${duitlah.frontend-url}") String frontendUrl,
      AuditLogService auditLogService,
      ProductAnalyticsService productAnalyticsService,
      GroupRepository groups,
      SpaceService spaceService) {
    this.users = users;
    this.verificationTokens = verificationTokens;
    this.resetTokens = resetTokens;
    this.sessions = sessions;
    this.jwt = jwt;
    this.passwordEncoder = passwordEncoder;
    this.emailSender = emailSender;
    this.frontendUrl = frontendUrl;
    this.auditLogService = auditLogService;
    this.productAnalyticsService = productAnalyticsService;
    this.groups = groups;
    this.spaceService = spaceService;
  }

  public record AuthResult(String accessToken, String rawRefreshToken, UserResponse user) {}

  @Transactional
  public AuthResult register(RegisterRequest request, String userAgent, String ipAddress) {
    String email = request.email().trim().toLowerCase();
    if (users.existsByEmailIgnoreCase(email)) {
      throw new ConflictException(
          "EMAIL_ALREADY_REGISTERED", "An account with this email already exists.");
    }

    User user =
        new User(email, passwordEncoder.encode(request.password()), request.displayName().trim());
    users.save(user);
    spaceService.createPersonalSpaceForNewUser(user.getId());

    sendVerificationEmail(user);
    productAnalyticsService.track(user.getId(), "user_registered", Map.of());

    String rawRefreshToken = sessions.createSession(user.getId(), userAgent, ipAddress);
    return new AuthResult(
        jwt.generateAccessToken(user.getId()), rawRefreshToken, UserResponse.from(user));
  }

  @Transactional
  public AuthResult login(LoginRequest request, String userAgent, String ipAddress) {
    User user =
        users.findByEmailIgnoreCase(request.email().trim()).orElseThrow(this::invalidCredentials);
    if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
      throw invalidCredentials();
    }

    String rawRefreshToken = sessions.createSession(user.getId(), userAgent, ipAddress);
    return new AuthResult(
        jwt.generateAccessToken(user.getId()), rawRefreshToken, UserResponse.from(user));
  }

  private UnauthorizedException invalidCredentials() {
    return new UnauthorizedException("INVALID_CREDENTIALS", "Incorrect email or password.");
  }

  public record RefreshResult(String accessToken, String rawRefreshToken) {}

  @Transactional
  public RefreshResult refresh(String rawRefreshToken, String userAgent, String ipAddress) {
    SessionService.Rotated rotated =
        sessions
            .rotate(rawRefreshToken, userAgent, ipAddress)
            .orElseThrow(
                () ->
                    new UnauthorizedException(
                        "INVALID_REFRESH_TOKEN", "Your session has expired. Please log in again."));
    return new RefreshResult(jwt.generateAccessToken(rotated.userId()), rotated.rawRefreshToken());
  }

  @Transactional
  public void sendVerificationEmail(User user) {
    if (user.isEmailVerified()) {
      return;
    }
    String rawToken = SecureTokens.generate();
    verificationTokens.save(
        new EmailVerificationToken(
            user.getId(),
            SecureTokens.hash(rawToken),
            Instant.now().plus(VERIFICATION_TOKEN_TTL_HOURS, ChronoUnit.HOURS)));

    String link = frontendUrl + "/verify-email?token=" + rawToken;
    emailSender.send(
        user.getEmail(),
        "Confirm your Duitlah email",
        "Hi "
            + user.getDisplayName()
            + ",\n\nConfirm your email: "
            + link
            + "\n\nThis link expires in "
            + VERIFICATION_TOKEN_TTL_HOURS
            + " hours.");
  }

  @Transactional
  public void resendVerificationEmail(UUID userId) {
    users.findById(userId).ifPresent(this::sendVerificationEmail);
  }

  @Transactional
  public void verifyEmail(String rawToken) {
    EmailVerificationToken token =
        verificationTokens
            .findByTokenHash(SecureTokens.hash(rawToken))
            .filter(EmailVerificationToken::isUsable)
            .orElseThrow(
                () ->
                    new UnauthorizedException(
                        "INVALID_VERIFICATION_TOKEN",
                        "This verification link is invalid or has expired."));

    token.setConsumedAt(Instant.now());
    verificationTokens.save(token);

    User user = users.findById(token.getUserId()).orElseThrow();
    user.setEmailVerifiedAt(Instant.now());
    users.save(user);
  }

  /** Always succeeds from the caller's perspective — never discloses whether the email exists. */
  @Transactional
  public void requestPasswordReset(String email) {
    Optional<User> user = users.findByEmailIgnoreCase(email.trim());
    if (user.isEmpty()) {
      return;
    }

    String rawToken = SecureTokens.generate();
    resetTokens.save(
        new PasswordResetToken(
            user.get().getId(),
            SecureTokens.hash(rawToken),
            Instant.now().plus(RESET_TOKEN_TTL_MINUTES, ChronoUnit.MINUTES)));

    String link = frontendUrl + "/reset-password?token=" + rawToken;
    emailSender.send(
        user.get().getEmail(),
        "Reset your Duitlah password",
        "Reset your password: "
            + link
            + "\n\nThis link expires in "
            + RESET_TOKEN_TTL_MINUTES
            + " minutes. If you didn't request this, you can ignore this email.");
  }

  @Transactional
  public void confirmPasswordReset(String rawToken, String newPassword) {
    PasswordResetToken token =
        resetTokens
            .findByTokenHash(SecureTokens.hash(rawToken))
            .filter(PasswordResetToken::isUsable)
            .orElseThrow(
                () ->
                    new UnauthorizedException(
                        "INVALID_RESET_TOKEN",
                        "This password reset link is invalid or has expired."));

    token.setConsumedAt(Instant.now());
    resetTokens.save(token);

    User user = users.findById(token.getUserId()).orElseThrow();
    user.setPasswordHash(passwordEncoder.encode(newPassword));
    users.save(user);

    // Resetting via an emailed link means we can't assume the current
    // device is trusted — unlike an in-app password change, log out everywhere.
    sessions.revokeAllSessions(user.getId());
  }

  @Transactional
  public void changePassword(
      UUID userId, String currentPassword, String newPassword, String keepRawRefreshToken) {
    User user = users.findById(userId).orElseThrow();
    if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
      throw new UnauthorizedException("INVALID_CREDENTIALS", "Current password is incorrect.");
    }

    user.setPasswordHash(passwordEncoder.encode(newPassword));
    users.save(user);

    sessions.revokeAllSessionsExcept(userId, keepRawRefreshToken);
    auditLogService.record(
        userId,
        AuditAction.SECURITY_SETTINGS_CHANGED,
        "User",
        userId,
        Map.of("change", "password"));
  }

  /**
   * Permanent and self-service (product spec section 52: "Implement: Account deletion"). Deletes
   * the {@code users} row and lets the schema's own {@code ON DELETE CASCADE} FKs (see
   * docs/database.md) remove everything owned by this account -- accounts, transactions, budgets,
   * goals, group memberships, bills, receipts, sessions, and so on. There is no separate "soft
   * delete" flag anywhere in this schema to instead flip, and re-implementing that as a parallel
   * mechanism just for this one action would be exactly the kind of premature abstraction this
   * codebase avoids elsewhere.
   *
   * <p>One guard before that cascade is allowed to run: {@code groups.owner_user_id} is also {@code
   * ON DELETE CASCADE} (V5), so without this check, deleting your own account would take an entire
   * shared group down with it -- silently deleting every other member's history in a group you
   * happen to own, not just your own data. Owning zero active groups is required first; the user
   * has to archive or hand off ownership through the ordinary group-settings flow before deletion
   * is allowed, the same "the schema's cascade behavior has real consequences, and this endpoint
   * has to respect them" discipline as everywhere else this codebase touches cascades.
   */
  @Transactional
  public void deleteAccount(UUID userId, String password) {
    User user = users.findById(userId).orElseThrow();
    if (!passwordEncoder.matches(password, user.getPasswordHash())) {
      throw new UnauthorizedException("INVALID_CREDENTIALS", "Incorrect password.");
    }
    if (groups.countByOwnerUserIdAndArchivedAtIsNull(userId) > 0) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "OWNS_ACTIVE_GROUPS",
          "You still own an active group. Archive it or transfer ownership before deleting your "
              + "account -- deleting your account would otherwise delete that group for everyone "
              + "else in it too.");
    }
    users.delete(user);
  }
}
