package com.duitlah.api.users;

import com.duitlah.api.auth.AuthService;
import com.duitlah.api.auth.RefreshCookieService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

  private final UserService userService;
  private final AuthService authService;
  private final RefreshCookieService refreshCookies;

  public UserController(
      UserService userService, AuthService authService, RefreshCookieService refreshCookies) {
    this.userService = userService;
    this.authService = authService;
    this.refreshCookies = refreshCookies;
  }

  @GetMapping("/api/v1/users/me")
  public UserResponse me(@AuthenticationPrincipal UUID userId) {
    return UserResponse.from(userService.getById(userId));
  }

  @PatchMapping("/api/v1/users/me")
  public UserResponse updateProfile(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody UpdateProfileRequest request) {
    return UserResponse.from(userService.updateProfile(userId, request));
  }

  @PostMapping("/api/v1/users/me/change-password")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void changePassword(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody ChangePasswordRequest request,
      HttpServletRequest req) {
    String keepRawToken = refreshCookies.read(req).orElse(null);
    authService.changePassword(
        userId, request.currentPassword(), request.newPassword(), keepRawToken);
  }

  @DeleteMapping("/api/v1/users/me")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void deleteAccount(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody DeleteAccountRequest request,
      HttpServletResponse res) {
    authService.deleteAccount(userId, request.password());
    refreshCookies.clear(res);
  }
}
