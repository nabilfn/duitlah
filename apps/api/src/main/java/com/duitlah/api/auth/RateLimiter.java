package com.duitlah.api.auth;

import java.time.Duration;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

/**
 * Fixed-window counter backed by Redis. Deliberately simple (no sliding-window/token-bucket
 * precision) — good enough to blunt credential-stuffing and reset-spam against a handful of auth
 * endpoints, which is all this needs to do. Redis is the right home for this per
 * docs/architecture.md: ephemeral, not a source of truth.
 */
@Component
public class RateLimiter {

  private final StringRedisTemplate redis;

  public RateLimiter(StringRedisTemplate redis) {
    this.redis = redis;
  }

  /**
   * Returns true if the action identified by {@code key} is allowed under the given limit/window.
   */
  public boolean allow(String key, int limit, Duration window) {
    String redisKey = "ratelimit:" + key;
    Long count = redis.opsForValue().increment(redisKey);
    if (count != null && count == 1L) {
      redis.expire(redisKey, window);
    }
    return count != null && count <= limit;
  }
}
