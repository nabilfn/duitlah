package com.duitlah.api.notifications;

import com.duitlah.api.common.mail.EmailSender;
import com.duitlah.api.users.UserRepository;
import java.util.UUID;
import org.springframework.stereotype.Component;

/**
 * Always active, the same "optional external provider, honest fallback" shape as the rest of this
 * codebase — {@link EmailSender}'s own fallback ({@code LoggingEmailSender}) already handles "no
 * real SMTP/SES configured" for every other email in the app, so this needs no separate
 * unavailable-state of its own.
 */
@Component
public class EmailNotificationProvider implements NotificationProvider {

  private final UserRepository users;
  private final EmailSender emailSender;

  public EmailNotificationProvider(UserRepository users, EmailSender emailSender) {
    this.users = users;
    this.emailSender = emailSender;
  }

  @Override
  public void send(UUID userId, String type, String title, String body) {
    users.findById(userId).ifPresent(user -> emailSender.send(user.getEmail(), title, body));
  }
}
