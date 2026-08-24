package com.duitlah.api.common.idempotency;

import com.duitlah.api.common.response.ApiError;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Set;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingResponseWrapper;

/**
 * Closes a gap this codebase has carried (and documented in docs/api.md) since Phase 6: financial
 * write endpoints accept an {@code Idempotency-Key} header but nothing on the backend actually
 * deduplicated on it — a double-click or a mobile network retry could create two real records. This
 * is the product spec's own section 51 requirement ("same request must not accidentally create two
 * financial records").
 *
 * <p>Deliberately a blanket filter rather than per-endpoint wiring: it only ever activates when the
 * caller sends the header (every client already opts in exactly on the calls it considers
 * financially sensitive — see docs/api.md), so adding it here changes behavior for exactly the
 * requests that ask for it and nothing else. Scoped to POST/PUT/PATCH; DELETE endpoints in this API
 * are already naturally idempotent (deleting twice ends in the same state, a 404 the second time),
 * so nothing here needs the same protection.
 *
 * <p>Concurrency: a Redis {@code SET ... NX} claims the key atomically before the request is
 * processed. A second request arriving while the first is still in flight gets a 409 (telling the
 * client the original is still processing) rather than racing the handler a second time. Once the
 * first request finishes, its exact response (status/content-type/body) is cached and replayed
 * verbatim for any later request with the same key — except a 5xx, which releases the claim instead
 * of caching it, so a transient failure can actually be retried rather than being stuck replaying a
 * server error forever.
 */
public class IdempotencyFilter extends OncePerRequestFilter {

  private static final String HEADER = "Idempotency-Key";
  private static final String IN_PROGRESS_SENTINEL = "IN_PROGRESS";
  private static final Duration TTL = Duration.ofHours(24);
  private static final Set<String> COVERED_METHODS = Set.of("POST", "PUT", "PATCH");

  private final StringRedisTemplate redis;
  private final ObjectMapper objectMapper = new ObjectMapper();

  public IdempotencyFilter(StringRedisTemplate redis) {
    this.redis = redis;
  }

  @Override
  protected void doFilterInternal(
      HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {
    String idempotencyKey = request.getHeader(HEADER);
    String userId = currentUserId();

    if (!COVERED_METHODS.contains(request.getMethod())
        || idempotencyKey == null
        || idempotencyKey.isBlank()
        || userId == null) {
      filterChain.doFilter(request, response);
      return;
    }

    String redisKey = "idempotency:" + userId + ":" + idempotencyKey;
    boolean claimed =
        Boolean.TRUE.equals(redis.opsForValue().setIfAbsent(redisKey, IN_PROGRESS_SENTINEL, TTL));

    if (!claimed) {
      String existing = redis.opsForValue().get(redisKey);
      if (existing == null) {
        // Expired between the failed claim and this read -- vanishingly rare; treat as a fresh
        // request rather than blocking it forever.
        filterChain.doFilter(request, response);
        return;
      }
      if (IN_PROGRESS_SENTINEL.equals(existing)) {
        writeConflict(response);
        return;
      }
      replay(response, existing);
      return;
    }

    ContentCachingResponseWrapper wrappedResponse = new ContentCachingResponseWrapper(response);
    try {
      filterChain.doFilter(request, wrappedResponse);
    } finally {
      if (wrappedResponse.getStatus() >= 500) {
        redis.delete(redisKey);
      } else {
        redis.opsForValue().set(redisKey, encode(wrappedResponse), TTL);
      }
      wrappedResponse.copyBodyToResponse();
    }
  }

  private String currentUserId() {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    if (authentication == null || authentication.getPrincipal() == null) {
      return null;
    }
    return authentication.getPrincipal().toString();
  }

  private String encode(ContentCachingResponseWrapper wrappedResponse) {
    try {
      byte[] body = wrappedResponse.getContentAsByteArray();
      CachedResponse cached =
          new CachedResponse(
              wrappedResponse.getStatus(),
              wrappedResponse.getContentType(),
              new String(body, StandardCharsets.UTF_8));
      return objectMapper.writeValueAsString(cached);
    } catch (Exception e) {
      throw new IllegalStateException("Failed to cache idempotent response", e);
    }
  }

  private void replay(HttpServletResponse response, String encoded) throws IOException {
    CachedResponse cached = objectMapper.readValue(encoded, CachedResponse.class);
    response.setStatus(cached.status());
    if (cached.contentType() != null) {
      response.setContentType(cached.contentType());
    }
    response.getWriter().write(cached.body());
  }

  private void writeConflict(HttpServletResponse response) throws IOException {
    response.setStatus(HttpServletResponse.SC_CONFLICT);
    response.setContentType("application/json");
    response
        .getWriter()
        .write(
            objectMapper.writeValueAsString(
                new ApiError(
                    "DUPLICATE_REQUEST_IN_PROGRESS",
                    "The original request with this idempotency key is still being processed.")));
  }

  private record CachedResponse(int status, String contentType, String body) {}
}
