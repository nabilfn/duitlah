package com.duitlah.api.subscriptions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Used for every {@link SubscriptionSource} until a real verifier (Apple App Store Server API,
 * Google Play Developer API, or a web/Stripe checkout) is configured — see {@link
 * SubscriptionVerifier}. Never fabricates a successful verification.
 */
public class UnavailableSubscriptionVerifier implements SubscriptionVerifier {

  private static final Logger log = LoggerFactory.getLogger(UnavailableSubscriptionVerifier.class);

  @Override
  public VerificationResult verify(SubscriptionSource source, String receiptData) {
    log.info(
        "Subscription verification for {} is not configured -- rejecting the purchase.", source);
    return VerificationResult.unavailable(source);
  }
}
