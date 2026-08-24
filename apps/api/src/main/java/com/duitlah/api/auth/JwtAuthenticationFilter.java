package com.duitlah.api.auth;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Populates the security context from a `Authorization: Bearer <jwt>` header. Leaves the context
 * untouched (rather than rejecting the request) when the header is missing or invalid — {@link
 * SecurityConfig}'s authorization rules are what actually reject unauthenticated requests to
 * protected endpoints, keeping "is this token well-formed" and "is this endpoint allowed to be
 * anonymous" as separate concerns.
 */
public class JwtAuthenticationFilter extends OncePerRequestFilter {

  private final JwtService jwtService;

  public JwtAuthenticationFilter(JwtService jwtService) {
    this.jwtService = jwtService;
  }

  @Override
  protected void doFilterInternal(
      HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {
    extractToken(request).flatMap(jwtService::validateAndGetUserId).ifPresent(this::authenticate);
    filterChain.doFilter(request, response);
  }

  private void authenticate(UUID userId) {
    var authentication = new UsernamePasswordAuthenticationToken(userId, null, List.of());
    SecurityContextHolder.getContext().setAuthentication(authentication);
  }

  private Optional<String> extractToken(HttpServletRequest request) {
    String header = request.getHeader("Authorization");
    if (header != null && header.startsWith("Bearer ")) {
      return Optional.of(header.substring(7));
    }
    return Optional.empty();
  }
}
