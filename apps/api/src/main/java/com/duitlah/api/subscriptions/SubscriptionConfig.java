package com.duitlah.api.subscriptions;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Unconditionally wires {@link UnavailableSubscriptionVerifier} — unlike {@code receipts.OcrConfig}
 * or {@code ai.AiConfig}, there's no "real implementation, toggled by an API key" branch yet, since
 * a real verifier needs actual Apple/Google/Stripe developer accounts this repository doesn't have.
 * Swapping in a real {@link SubscriptionVerifier} bean here is the intended extension point once
 * those credentials exist.
 */
@Configuration
public class SubscriptionConfig {

  @Bean
  public SubscriptionVerifier subscriptionVerifier() {
    return new UnavailableSubscriptionVerifier();
  }
}
