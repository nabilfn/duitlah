package com.duitlah.api.bagilah;

import com.duitlah.api.auth.JwtService;
import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

/**
 * The one public Bagilah endpoint: a visitor with no Duitlah account must still be able to join a
 * bill via its invite link (product spec section 12). Left off Spring Security's authenticated()
 * requirement (see SecurityConfig) rather than made to require a token, so identity here is
 * resolved manually -- if a valid Bearer JWT happens to be present the requester joins as that real
 * user, otherwise they must supply a guest name and get a guest session token back instead.
 */
@RestController
public class BagilahJoinController {

  private final BillService billService;
  private final JwtService jwtService;

  public BagilahJoinController(BillService billService, JwtService jwtService) {
    this.billService = billService;
    this.jwtService = jwtService;
  }

  @PostMapping("/api/v1/bagilah/join")
  public JoinBillResponse join(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody JoinBillRequest request) {
    UUID authenticatedUserId = resolveUserId(authorization);
    return billService.joinViaInvite(request.token(), request.guestName(), authenticatedUserId);
  }

  private UUID resolveUserId(String authorization) {
    if (authorization == null || !authorization.startsWith("Bearer ")) {
      return null;
    }
    return jwtService.validateAndGetUserId(authorization.substring(7)).orElse(null);
  }
}
