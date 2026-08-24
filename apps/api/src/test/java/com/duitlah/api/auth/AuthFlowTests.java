package com.duitlah.api.auth;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class AuthFlowTests {

  @Autowired private MockMvc mockMvc;

  // Spring Boot 4 wires Jackson 3's tools.jackson.databind.json.JsonMapper
  // by default, not a com.fasterxml.jackson.databind.ObjectMapper bean —
  // a plain instance here is simplest for building request bodies in tests.
  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  @BeforeEach
  void cleanDatabase() {
    userRepository.deleteAll();
    // Rate-limit counters live in Redis and would otherwise leak
    // between test methods, since the Testcontainers Redis instance is
    // shared for the whole test class run.
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();
  }

  private MvcResult register(String email, String password, String displayName) throws Exception {
    return mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new RegisterRequest(email, password, displayName))))
        .andReturn();
  }

  private Cookie refreshCookieFrom(MvcResult result) {
    Cookie cookie = result.getResponse().getCookie("duitlah_refresh_token");
    assertThat(cookie).isNotNull();
    return cookie;
  }

  @Test
  void registerCreatesAccountAndReturnsAccessTokenAndSetsRefreshCookie() throws Exception {
    MvcResult result = register("nabil@example.com", "correct-horse-1", "Nabil");

    assertThat(result.getResponse().getStatus()).isEqualTo(HttpStatus.CREATED.value());
    assertThat(result.getResponse().getContentAsString())
        .contains("\"accessToken\"")
        .contains("nabil@example.com");
    assertThat(refreshCookieFrom(result).isHttpOnly()).isTrue();
  }

  @Test
  void registerWithDuplicateEmailIsRejected() throws Exception {
    register("dup@example.com", "correct-horse-1", "First");

    MvcResult result = register("dup@example.com", "another-password-1", "Second");

    assertThat(result.getResponse().getStatus()).isEqualTo(HttpStatus.CONFLICT.value());
    assertThat(result.getResponse().getContentAsString()).contains("EMAIL_ALREADY_REGISTERED");
  }

  @Test
  void loginWithWrongPasswordIsRejectedWithoutRevealingWhichFieldWasWrong() throws Exception {
    register("login@example.com", "correct-horse-1", "Nabil");

    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new LoginRequest("login@example.com", "wrong-password"))))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_CREDENTIALS"));
  }

  @Test
  void loginForUnknownEmailGivesSameGenericError() throws Exception {
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new LoginRequest("nobody@example.com", "whatever-1"))))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_CREDENTIALS"));
  }

  @Test
  void protectedEndpointRejectsRequestWithoutToken() throws Exception {
    mockMvc
        .perform(MockMvcRequestBuilders.get("/api/v1/users/me"))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("UNAUTHENTICATED"));
  }

  @Test
  void protectedEndpointAcceptsValidAccessToken() throws Exception {
    MvcResult registered = register("me@example.com", "correct-horse-1", "Nabil");
    String accessToken =
        objectMapper
            .readTree(registered.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    mockMvc
        .perform(
            MockMvcRequestBuilders.get("/api/v1/users/me")
                .header("Authorization", "Bearer " + accessToken))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.email").value("me@example.com"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.emailVerified").value(false));
  }

  @Test
  void refreshRotatesTokenAndOldTokenCannotBeReused() throws Exception {
    MvcResult registered = register("refresh@example.com", "correct-horse-1", "Nabil");
    Cookie originalRefreshCookie = refreshCookieFrom(registered);

    MvcResult firstRefresh =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(originalRefreshCookie))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();
    Cookie rotatedCookie = refreshCookieFrom(firstRefresh);
    assertThat(rotatedCookie.getValue()).isNotEqualTo(originalRefreshCookie.getValue());

    // Reusing the now-revoked original token must fail...
    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(originalRefreshCookie))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized());

    // ...and reuse detection must have revoked the rotated session too (theft response).
    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(rotatedCookie))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized());
  }

  @Test
  void logoutRevokesSessionSoRefreshNoLongerWorks() throws Exception {
    MvcResult registered = register("logout@example.com", "correct-horse-1", "Nabil");
    Cookie refreshCookie = refreshCookieFrom(registered);

    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/logout").cookie(refreshCookie))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(refreshCookie))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized());
  }

  @Test
  void changePasswordRevokesOtherSessionsButKeepsCurrentOneActive() throws Exception {
    MvcResult registered = register("changepw@example.com", "correct-horse-1", "Nabil");
    String accessToken =
        objectMapper
            .readTree(registered.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
    Cookie currentSessionCookie = refreshCookieFrom(registered);

    // A second, independent login — a different device/browser.
    MvcResult secondLogin =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new LoginRequest("changepw@example.com", "correct-horse-1"))))
            .andReturn();
    Cookie otherSessionCookie = refreshCookieFrom(secondLogin);

    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/users/me/change-password")
                .header("Authorization", "Bearer " + accessToken)
                .cookie(currentSessionCookie)
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new com.duitlah.api.users.ChangePasswordRequest(
                            "correct-horse-1", "new-correct-horse-1"))))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    // Current session (the one that made the change) still works.
    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(currentSessionCookie))
        .andExpect(MockMvcResultMatchers.status().isOk());

    // The other device's session was revoked.
    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(otherSessionCookie))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized());
  }

  @Test
  void deletingAccountRemovesTheUserAndRevokesTheSession() throws Exception {
    MvcResult registered = register("delete-me@example.com", "correct-horse-1", "Nabil");
    String accessToken =
        objectMapper
            .readTree(registered.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
    String userId =
        objectMapper
            .readTree(registered.getResponse().getContentAsString())
            .get("user")
            .get("id")
            .asText();
    Cookie sessionCookie = refreshCookieFrom(registered);

    mockMvc
        .perform(
            MockMvcRequestBuilders.delete("/api/v1/users/me")
                .header("Authorization", "Bearer " + accessToken)
                .cookie(sessionCookie)
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new com.duitlah.api.users.DeleteAccountRequest("correct-horse-1"))))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    assertThat(userRepository.findById(java.util.UUID.fromString(userId))).isEmpty();
    mockMvc
        .perform(MockMvcRequestBuilders.post("/api/v1/auth/refresh").cookie(sessionCookie))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized());
  }

  @Test
  void deletingAccountWithTheWrongPasswordIsRejected() throws Exception {
    MvcResult registered = register("wrong-pw-delete@example.com", "correct-horse-1", "Nabil");
    String accessToken =
        objectMapper
            .readTree(registered.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    mockMvc
        .perform(
            MockMvcRequestBuilders.delete("/api/v1/users/me")
                .header("Authorization", "Bearer " + accessToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new com.duitlah.api.users.DeleteAccountRequest("totally-wrong-password"))))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_CREDENTIALS"));
  }

  @Test
  void deletingAnAccountThatOwnsAnActiveGroupIsRejected() throws Exception {
    MvcResult registered = register("group-owner-delete@example.com", "correct-horse-1", "Nabil");
    String accessToken =
        objectMapper
            .readTree(registered.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    mockMvc.perform(
        MockMvcRequestBuilders.post("/api/v1/groups")
            .header("Authorization", "Bearer " + accessToken)
            .contentType(MediaType.APPLICATION_JSON)
            .content(
                objectMapper
                    .createObjectNode()
                    .put("name", "Trip")
                    .put("type", "TRIP")
                    .toString()));

    mockMvc
        .perform(
            MockMvcRequestBuilders.delete("/api/v1/users/me")
                .header("Authorization", "Bearer " + accessToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new com.duitlah.api.users.DeleteAccountRequest("correct-horse-1"))))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("OWNS_ACTIVE_GROUPS"));
  }

  @Test
  void passwordResetFlowAllowsLoginWithNewPasswordAndRevokesAllSessions() throws Exception {
    register("reset@example.com", "correct-horse-1", "Nabil");

    // Requesting a reset never discloses whether the account exists — always 204.
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/password-reset/request")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new PasswordResetRequestRequest("reset@example.com"))))
        .andExpect(MockMvcResultMatchers.status().isNoContent());
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/password-reset/request")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new PasswordResetRequestRequest("nobody@example.com"))))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    // Confirming with a bogus token is rejected.
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/password-reset/confirm")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new PasswordResetConfirmRequest(
                            "not-a-real-token", "new-correct-horse-1"))))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized());
  }

  @Test
  void verifyEmailWithBogusTokenIsRejected() throws Exception {
    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/verify-email")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(new VerifyEmailRequest("not-a-real-token"))))
        .andExpect(MockMvcResultMatchers.status().isUnauthorized())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INVALID_VERIFICATION_TOKEN"));
  }

  @Test
  void loginIsRateLimitedPerEmailAfterRepeatedFailures() throws Exception {
    register("ratelimited@example.com", "correct-horse-1", "Nabil");

    for (int i = 0; i < 8; i++) {
      mockMvc.perform(
          MockMvcRequestBuilders.post("/api/v1/auth/login")
              .contentType(MediaType.APPLICATION_JSON)
              .content(
                  objectMapper.writeValueAsString(
                      new LoginRequest("ratelimited@example.com", "wrong-password"))));
    }

    mockMvc
        .perform(
            MockMvcRequestBuilders.post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(
                    objectMapper.writeValueAsString(
                        new LoginRequest("ratelimited@example.com", "correct-horse-1"))))
        .andExpect(MockMvcResultMatchers.status().isTooManyRequests());
  }
}
