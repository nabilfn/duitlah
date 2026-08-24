package com.duitlah.api.notifications;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

/** V2 Phase 3 (spec section 24) — replacing the Phase 9.5 placeholder screen's backend. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class NotificationFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private NotificationService notifications;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private UUID userId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest("notify@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
    userId = UUID.fromString(json(registerResult).get("user").get("id").asText());
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void notifyingAUserCreatesARealInAppNotification() throws Exception {
    notifications.notify(userId, "TEST", "Hello", "This is a test notification.");

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/notifications")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].title").value("Hello"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].read").value(false));

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/notifications/unread-count")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.count").value(1));
  }

  @Test
  void markingANotificationReadUpdatesTheUnreadCount() throws Exception {
    notifications.notify(userId, "TEST", "Hello", "Body");
    String notificationId =
        json(mockMvc
                .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/notifications")))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    mockMvc
        .perform(
            as(
                accessToken,
                MockMvcRequestBuilders.post("/api/v1/notifications/" + notificationId + "/read")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.read").value(true));

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/notifications/unread-count")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.count").value(0));
  }

  @Test
  void nonOwnerCannotMarkAnotherUsersNotificationRead() throws Exception {
    notifications.notify(userId, "TEST", "Hello", "Body");
    String notificationId =
        json(mockMvc
                .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/notifications")))
                .andReturn())
            .get(0)
            .get("id")
            .asText();

    var other =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "notify-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();

    mockMvc
        .perform(
            as(
                otherToken,
                MockMvcRequestBuilders.post("/api/v1/notifications/" + notificationId + "/read")))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
