package com.duitlah.api.telemetry;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TelemetryConfig {

  @Bean
  public ErrorReportingService errorReportingService(TelemetryProperties properties) {
    if (properties.isErrorWebhookConfigured()) {
      return new WebhookErrorReportingService(properties.errorWebhookUrl());
    }
    return new LoggingErrorReportingService();
  }

  @Bean
  public ProductAnalyticsService productAnalyticsService(TelemetryProperties properties) {
    if (properties.isAnalyticsWebhookConfigured()) {
      return new WebhookProductAnalyticsService(properties.analyticsWebhookUrl());
    }
    return new LoggingProductAnalyticsService();
  }
}
