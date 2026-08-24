package com.duitlah.api.telemetry;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "duitlah.telemetry")
public record TelemetryProperties(String errorWebhookUrl, String analyticsWebhookUrl) {

  public boolean isErrorWebhookConfigured() {
    return errorWebhookUrl != null && !errorWebhookUrl.isBlank();
  }

  public boolean isAnalyticsWebhookConfigured() {
    return analyticsWebhookUrl != null && !analyticsWebhookUrl.isBlank();
  }
}
