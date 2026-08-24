package com.duitlah.api.common.response;

import java.util.Map;

/**
 * Standard error body returned by the API. Matches the format documented in docs/api.md — {@code
 * code} is a stable machine-readable identifier, {@code message} is safe to show to end users, and
 * {@code details} carries optional structured context (never stack traces).
 */
public record ApiError(String code, String message, Map<String, Object> details) {

  public ApiError(String code, String message) {
    this(code, message, Map.of());
  }
}
