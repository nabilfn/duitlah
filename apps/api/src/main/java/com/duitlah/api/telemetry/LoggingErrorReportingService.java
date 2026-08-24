package com.duitlah.api.telemetry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Default error-reporting sink: a structured server log entry with the full stack trace. Used
 * whenever no error-monitoring webhook is configured ({@code duitlah.telemetry.error-webhook-url}
 * unset) -- the same "honest, working fallback, never a fake integration" posture as {@code
 * common.mail.LoggingEmailSender}.
 */
public class LoggingErrorReportingService implements ErrorReportingService {

  private static final Logger log = LoggerFactory.getLogger(LoggingErrorReportingService.class);

  @Override
  public void report(String context, Throwable error) {
    log.error("[error-report] context=\"{}\"", context, error);
  }
}
