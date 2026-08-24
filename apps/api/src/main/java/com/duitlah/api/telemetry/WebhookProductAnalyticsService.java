package com.duitlah.api.telemetry;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Posts a plain JSON event payload to a configured webhook URL ({@code
 * duitlah.telemetry.analytics-webhook-url}) -- same "generic JSON POST, no vendor lock-in, never
 * block or fail the caller" shape as {@link WebhookErrorReportingService}; see its Javadoc for why
 * this deliberately isn't a specific vendor SDK.
 */
public class WebhookProductAnalyticsService implements ProductAnalyticsService {

  private static final Logger log = LoggerFactory.getLogger(WebhookProductAnalyticsService.class);

  private final URI webhookUri;
  private final HttpClient httpClient;
  private final ObjectMapper objectMapper = new ObjectMapper();
  private final ProductAnalyticsService fallback = new LoggingProductAnalyticsService();

  public WebhookProductAnalyticsService(String webhookUrl) {
    this.webhookUri = URI.create(webhookUrl);
    this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();
  }

  @Override
  public void track(UUID userId, String event, Map<String, Object> properties) {
    fallback.track(userId, event, properties);
    try {
      ObjectNode payload = objectMapper.createObjectNode();
      payload.put("userId", userId.toString());
      payload.put("event", event);
      payload.put("timestamp", Instant.now().toString());
      payload.set("properties", objectMapper.valueToTree(properties));

      HttpRequest request =
          HttpRequest.newBuilder(webhookUri)
              .header("content-type", "application/json")
              .timeout(Duration.ofSeconds(5))
              .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(payload)))
              .build();
      httpClient
          .sendAsync(request, HttpResponse.BodyHandlers.discarding())
          .whenComplete(
              (response, throwable) -> {
                if (throwable != null) {
                  log.warn("Failed to post to analytics webhook", throwable);
                } else if (response.statusCode() >= 300) {
                  log.warn("Analytics webhook returned status {}", response.statusCode());
                }
              });
    } catch (Exception e) {
      log.warn("Failed to post to analytics webhook", e);
    }
  }
}
