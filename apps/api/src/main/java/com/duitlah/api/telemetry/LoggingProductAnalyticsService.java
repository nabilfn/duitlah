package com.duitlah.api.telemetry;

import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Default analytics sink: a structured server log entry. Used whenever no analytics webhook is
 * configured ({@code duitlah.telemetry.analytics-webhook-url} unset) -- same fallback posture as
 * {@link LoggingErrorReportingService}.
 */
public class LoggingProductAnalyticsService implements ProductAnalyticsService {

  private static final Logger log = LoggerFactory.getLogger(LoggingProductAnalyticsService.class);

  @Override
  public void track(UUID userId, String event, Map<String, Object> properties) {
    log.info("[analytics] userId={} event=\"{}\" properties={}", userId, event, properties);
  }
}
