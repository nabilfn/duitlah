package com.duitlah.api.telemetry;

/**
 * Abstraction over "somewhere a real production error gets surfaced to a human," so {@code
 * common.error.GlobalExceptionHandler} never depends on a specific vendor. The only implementation
 * active without configuration is {@link LoggingErrorReportingService} -- structured server logs, a
 * real and complete answer to "error monitoring" at this project's current scale, not a
 * placeholder. {@link WebhookErrorReportingService} additionally posts to a configured URL (a
 * Sentry-compatible ingestion relay, an alerting webhook, or anything else that accepts a JSON
 * POST) when one is set, without this codebase locking itself to one vendor's proprietary wire
 * format.
 */
public interface ErrorReportingService {

  void report(String context, Throwable error);
}
