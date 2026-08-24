package com.duitlah.api.common.error;

import org.springframework.http.HttpStatus;

public class TooManyRequestsException extends ApiException {

  public TooManyRequestsException(String message) {
    super(HttpStatus.TOO_MANY_REQUESTS, "TOO_MANY_REQUESTS", message);
  }
}
