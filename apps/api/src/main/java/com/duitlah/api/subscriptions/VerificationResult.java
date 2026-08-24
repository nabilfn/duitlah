package com.duitlah.api.subscriptions;

import java.time.Instant;

/** {@code valid} false means the purchase could not be verified -- {@code message} explains why. */
public record VerificationResult(
    boolean valid, Instant expiresAt, String externalReference, String message) {

  public static VerificationResult unavailable(SubscriptionSource source) {
    return new VerificationResult(
        false,
        null,
        null,
        "Purchase verification for " + source.name() + " isn't configured on this server yet.");
  }
}
