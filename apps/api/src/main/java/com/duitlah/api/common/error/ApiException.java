package com.duitlah.api.common.error;

import java.util.Map;
import org.springframework.http.HttpStatus;

/**
 * Base type for domain exceptions that should be translated into a stable {@code ApiError}
 * response. Prefer throwing a specific subclass (or this class directly with an explicit
 * status/code) over letting framework exceptions leak through as 500s.
 */
public class ApiException extends RuntimeException {

  private final HttpStatus status;
  private final String code;
  private final Map<String, Object> details;

  public ApiException(HttpStatus status, String code, String message) {
    this(status, code, message, Map.of());
  }

  public ApiException(HttpStatus status, String code, String message, Map<String, Object> details) {
    super(message);
    this.status = status;
    this.code = code;
    this.details = details;
  }

  public HttpStatus getStatus() {
    return status;
  }

  public String getCode() {
    return code;
  }

  public Map<String, Object> getDetails() {
    return details;
  }
}
