package com.duitlah.api.notifications;

import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * Unimplemented, honestly: real push delivery needs a device-token registration endpoint (none
 * exists yet — Phase 9.5's own notes-to-self said as much) and real Firebase Cloud Messaging
 * project credentials this repository doesn't have. The same "don't fabricate a working
 * integration" posture as {@code subscriptions.UnavailableSubscriptionVerifier}/{@code
 * settlements.PaymentHandoffService} — this logs rather than silently doing nothing, so the gap is
 * visible rather than invisible.
 */
@Component
public class PushNotificationProvider implements NotificationProvider {

  private static final Logger log = LoggerFactory.getLogger(PushNotificationProvider.class);

  @Override
  public void send(UUID userId, String type, String title, String body) {
    log.info("[push] not configured -- would have sent to userId={} title=\"{}\"", userId, title);
  }
}
