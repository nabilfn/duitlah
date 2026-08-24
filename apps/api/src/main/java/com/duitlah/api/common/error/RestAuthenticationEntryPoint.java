package com.duitlah.api.common.error;

import com.duitlah.api.common.response.ApiError;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

/**
 * Makes an unauthenticated request to a protected endpoint return the same ApiError shape as
 * everything else.
 */
@Component
public class RestAuthenticationEntryPoint implements AuthenticationEntryPoint {

  // A fresh instance rather than the app's shared ObjectMapper bean — this
  // only ever serializes one fixed-shape record, so it doesn't need the
  // app's Jackson customizations.
  private final ObjectMapper objectMapper = new ObjectMapper();

  @Override
  public void commence(
      HttpServletRequest request,
      HttpServletResponse response,
      AuthenticationException authException)
      throws IOException {
    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    response.setContentType(MediaType.APPLICATION_JSON_VALUE);
    objectMapper.writeValue(
        response.getWriter(),
        new ApiError("UNAUTHENTICATED", "Authentication is required to access this resource."));
  }
}
