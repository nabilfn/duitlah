package com.duitlah.api.telemetry;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.Instant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Posts a plain JSON payload to a configured webhook URL ({@code
 * duitlah.telemetry.error-webhook-url}) -- any endpoint that accepts a JSON POST can sit behind
 * this (a Sentry-compatible ingestion relay, a custom collector, an alerting webhook), rather than
 * this codebase committing to one vendor's proprietary envelope protocol without ever being able to
 * verify it against a real account. The POST is fire-and-forget ({@code sendAsync}): this is called
 * from exception handling on the same thread that's about to return an already-erroring response to
 * the caller, so it must never add its own latency (or, worse, its own failure) to that response.
 * Any exception posting the report is caught and logged, never rethrown -- see {@link
 * LoggingErrorReportingService} for the always-on fallback this delegates to unconditionally.
 */
public class WebhookErrorReportingService implements ErrorReportingService {

  private static final Logger log = LoggerFactory.getLogger(WebhookErrorReportingService.class);

  private final URI webhookUri;
  private final HttpClient httpClient;
  private final ObjectMapper objectMapper = new ObjectMapper();
  private final ErrorReportingService fallback = new LoggingErrorReportingService();

  public WebhookErrorReportingService(String webhookUrl) {
    this.webhookUri = URI.create(webhookUrl);
    this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();
  }

  @Override
  public void report(String context, Throwable error) {
    fallback.report(context, error);
    try {
      ObjectNode payload = objectMapper.createObjectNode();
      payload.put("context", context);
      payload.put("message", String.valueOf(error.getMessage()));
      payload.put("exceptionType", error.getClass().getName());
      payload.put("timestamp", Instant.now().toString());

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
                  log.warn("Failed to post to error-reporting webhook", throwable);
                } else if (response.statusCode() >= 300) {
                  log.warn("Error-reporting webhook returned status {}", response.statusCode());
                }
              });
    } catch (Exception e) {
      log.warn("Failed to post to error-reporting webhook", e);
    }
  }
}
