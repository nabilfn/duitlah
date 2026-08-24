package com.duitlah.api.config;

import com.duitlah.api.auth.JwtAuthenticationFilter;
import com.duitlah.api.auth.JwtService;
import com.duitlah.api.common.error.RestAccessDeniedHandler;
import com.duitlah.api.common.error.RestAuthenticationEntryPoint;
import com.duitlah.api.common.idempotency.IdempotencyFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * The API is stateless and bearer-token based (see docs/security.md): no server-side HTTP session,
 * no CSRF token — the access token is a JWT validated per-request by {@link
 * JwtAuthenticationFilter}, and the long-lived refresh token lives in an httpOnly cookie scoped to
 * /api/v1/auth (see RefreshCookieService). CSRF protection is unnecessary here because the refresh
 * cookie alone can't authorize any state-changing request outside the auth endpoints, and every
 * other endpoint requires the Authorization header, which a cross-site form can't set.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  public SecurityFilterChain filterChain(
      HttpSecurity http,
      JwtService jwtService,
      RestAuthenticationEntryPoint entryPoint,
      RestAccessDeniedHandler accessDeniedHandler,
      StringRedisTemplate redisTemplate)
      throws Exception {
    http.csrf(csrf -> csrf.disable())
        .sessionManagement(
            session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .exceptionHandling(
            exceptions ->
                exceptions
                    .authenticationEntryPoint(entryPoint)
                    .accessDeniedHandler(accessDeniedHandler))
        .authorizeHttpRequests(
            auth ->
                auth
                    // A CORS preflight (OPTIONS) has no Authorization header by design -- the
                    // browser sends it before the real request even decides whether to attach
                    // one. Without this, `.anyRequest().authenticated()` below rejects the
                    // preflight itself with 401 on every protected endpoint, which the browser
                    // then reports as a CORS failure (no Access-Control-Allow-Origin on a 401),
                    // blocking the real request from ever being sent at all -- found live via
                    // Phase 15's own browser console verification (an unauthenticated fetch to
                    // GET /api/v1/dashboard from apps/web failed as a CORS error, not a plain
                    // 401). CorsFilter (see CorsConfig) still enforces the actual allowed-origin
                    // check on every request; this only stops Spring Security's auth check from
                    // shadowing it specifically for OPTIONS.
                    .requestMatchers(HttpMethod.OPTIONS, "/**")
                    .permitAll()
                    .requestMatchers("/actuator/health", "/actuator/info")
                    .permitAll()
                    .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html")
                    .permitAll()
                    .requestMatchers(
                        "/api/v1/auth/register",
                        "/api/v1/auth/login",
                        "/api/v1/auth/refresh",
                        "/api/v1/auth/logout",
                        "/api/v1/auth/verify-email",
                        "/api/v1/auth/password-reset/**")
                    .permitAll()
                    // Bagilah join/guest access: unlike Groups (accounts only), a bill's
                    // invite link must work for someone with no Duitlah account at all (product
                    // spec section 12). These stay public; identity is resolved manually inside
                    // BillService via either the (optional) JWT or a guest session token, never
                    // through Spring Security's Authentication -- see docs/security.md.
                    .requestMatchers("/api/v1/bagilah/join", "/api/v1/bagilah/guest/**")
                    .permitAll()
                    .requestMatchers("/api/v1")
                    .permitAll()
                    .anyRequest()
                    .authenticated())
        .addFilterBefore(
            new JwtAuthenticationFilter(jwtService), UsernamePasswordAuthenticationFilter.class)
        .addFilterAfter(new IdempotencyFilter(redisTemplate), JwtAuthenticationFilter.class);
    return http.build();
  }

  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }
}
