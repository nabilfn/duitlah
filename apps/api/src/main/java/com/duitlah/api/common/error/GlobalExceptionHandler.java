package com.duitlah.api.common.error;

import com.duitlah.api.common.response.ApiError;
import com.duitlah.api.telemetry.ErrorReportingService;
import jakarta.validation.ConstraintViolationException;
import java.util.LinkedHashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * Translates exceptions into the standard {@link ApiError} response shape. Unhandled exceptions are
 * logged with full detail server-side but never expose stack traces or internal messages to the
 * client. {@code handleUnexpected} is also the one place this codebase's "error monitoring" (Phase
 * 15) hooks in -- every genuinely unhandled 5xx passes through here, so it's the correct single
 * chokepoint rather than instrumenting every controller individually.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

  private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

  private final ErrorReportingService errorReportingService;

  public GlobalExceptionHandler(ErrorReportingService errorReportingService) {
    this.errorReportingService = errorReportingService;
  }

  @ExceptionHandler(ApiException.class)
  public ResponseEntity<ApiError> handleApiException(ApiException ex) {
    return ResponseEntity.status(ex.getStatus())
        .body(new ApiError(ex.getCode(), ex.getMessage(), ex.getDetails()));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException ex) {
    Map<String, Object> fieldErrors = new LinkedHashMap<>();
    ex.getBindingResult()
        .getFieldErrors()
        .forEach(fe -> fieldErrors.put(fe.getField(), fe.getDefaultMessage()));
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .body(
            new ApiError(
                "VALIDATION_FAILED",
                "One or more fields are invalid.",
                Map.of("fields", fieldErrors)));
  }

  @ExceptionHandler(ConstraintViolationException.class)
  public ResponseEntity<ApiError> handleConstraintViolation(ConstraintViolationException ex) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
        .body(new ApiError("VALIDATION_FAILED", "One or more fields are invalid.", Map.of()));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiError> handleUnexpected(Exception ex) {
    log.error("Unhandled exception", ex);
    errorReportingService.report("Unhandled exception in GlobalExceptionHandler", ex);
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(new ApiError("INTERNAL_ERROR", "Something went wrong. Please try again."));
  }
}
