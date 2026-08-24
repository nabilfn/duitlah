package com.duitlah.api.common.mail;

/**
 * Abstraction over the actual email provider, so auth/notifications code never depends on a
 * specific vendor. The only implementation today is {@link LoggingEmailSender}; swap in a real
 * provider (SES, Resend, etc.) behind this interface when one is wired up — nothing above this
 * layer should need to change.
 */
public interface EmailSender {

  void send(String toEmail, String subject, String body);
}
