package com.duitlah.api.telemetry;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

/**
 * These hit a real local HTTP server (JDK's {@code com.sun.net.httpserver.HttpServer}, no mocking
 * framework needed) rather than trusting that the webhook classes build the right request just
 * because the code reads that way -- the same "don't fabricate a verified integration" discipline
 * as {@code ReceiptScanFlowTests} using a real MinIO container instead of a mocked {@code
 * ObjectStorage}.
 */
class WebhookTelemetryTests {

  private HttpServer server;

  @AfterEach
  void tearDown() {
    if (server != null) {
      server.stop(0);
    }
  }

  @Test
  void errorReportingServicePostsTheExpectedJsonPayload() throws Exception {
    CountDownLatch received = new CountDownLatch(1);
    AtomicReference<String> capturedBody = new AtomicReference<>();
    server = startServer(received, capturedBody);

    ErrorReportingService service =
        new WebhookErrorReportingService(
            "http://localhost:" + server.getAddress().getPort() + "/hook");
    service.report("test-context", new IllegalStateException("boom"));

    assertThat(received.await(5, TimeUnit.SECONDS)).isTrue();
    JsonNode json = new ObjectMapper().readTree(capturedBody.get());
    assertThat(json.get("context").asText()).isEqualTo("test-context");
    assertThat(json.get("message").asText()).isEqualTo("boom");
    assertThat(json.get("exceptionType").asText()).isEqualTo("java.lang.IllegalStateException");
  }

  @Test
  void productAnalyticsServicePostsTheExpectedJsonPayload() throws Exception {
    CountDownLatch received = new CountDownLatch(1);
    AtomicReference<String> capturedBody = new AtomicReference<>();
    server = startServer(received, capturedBody);

    ProductAnalyticsService service =
        new WebhookProductAnalyticsService(
            "http://localhost:" + server.getAddress().getPort() + "/hook");
    var userId = java.util.UUID.randomUUID();
    service.track(userId, "user_registered", Map.of("plan", "FREE"));

    assertThat(received.await(5, TimeUnit.SECONDS)).isTrue();
    JsonNode json = new ObjectMapper().readTree(capturedBody.get());
    assertThat(json.get("userId").asText()).isEqualTo(userId.toString());
    assertThat(json.get("event").asText()).isEqualTo("user_registered");
    assertThat(json.get("properties").get("plan").asText()).isEqualTo("FREE");
  }

  @Test
  void aFailedPostNeverThrowsBackToTheCaller() {
    // No server listening on this port at all -- the caller must never see the failure.
    ErrorReportingService service = new WebhookErrorReportingService("http://localhost:1/hook");
    service.report("unreachable", new RuntimeException("irrelevant"));
  }

  private HttpServer startServer(CountDownLatch received, AtomicReference<String> capturedBody)
      throws IOException {
    HttpServer server = HttpServer.create(new InetSocketAddress("localhost", 0), 0);
    server.createContext(
        "/hook",
        exchange -> {
          capturedBody.set(new String(exchange.getRequestBody().readAllBytes()));
          exchange.sendResponseHeaders(200, -1);
          exchange.close();
          received.countDown();
        });
    server.start();
    return server;
  }
}
