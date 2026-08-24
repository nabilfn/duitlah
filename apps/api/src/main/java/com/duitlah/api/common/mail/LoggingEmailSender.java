package com.duitlah.api.common.mail;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * Dev/test stand-in for a real email provider: writes the message to the application log instead of
 * sending it. Never log this at INFO in a shared environment once a real provider exists — message
 * bodies here can contain verification/reset links.
 */
@Component
public class LoggingEmailSender implements EmailSender {

  private static final Logger log = LoggerFactory.getLogger(LoggingEmailSender.class);

  @Override
  public void send(String toEmail, String subject, String body) {
    log.info("[email] to={} subject=\"{}\"\n{}", toEmail, subject, body);
  }
}
