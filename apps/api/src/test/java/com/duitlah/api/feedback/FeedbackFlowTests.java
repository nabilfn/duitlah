package com.duitlah.api.feedback;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
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
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class FeedbackFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private FeedbackRepository feedbackRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private UUID userId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "feedback@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    var body = objectMapper.readTree(result.getResponse().getContentAsString());
    accessToken = body.get("accessToken").asText();
    userId = UUID.fromString(body.get("user").get("id").asText());
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  @Test
  void submittingFeedbackPersistsItAgainstTheAuthenticatedUser() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("category", "BUG")
            .put("message", "The Bagilah split screen crashes on rotate.");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/feedback"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.category").value("BUG"))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.message")
                .value("The Bagilah split screen crashes on rotate."));

    var stored = feedbackRepository.findByUserIdOrderByCreatedAtDesc(userId);
    assertThat(stored).hasSize(1);
    assertThat(stored.get(0).getCategory()).isEqualTo(FeedbackCategory.BUG);
  }

  @Test
  void blankMessageIsRejected() throws Exception {
    var body = objectMapper.createObjectNode().put("category", "GENERAL").put("message", "   ");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/feedback"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest());
  }

  @Test
  void listMineOnlyReturnsTheCallersOwnFeedbackInNewestFirstOrder() throws Exception {
    submit(accessToken, "GENERAL", "First note.");
    submit(accessToken, "FEATURE_REQUEST", "Please add dark mode charts.");

    var otherResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "other-feedback@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken =
        objectMapper
            .readTree(otherResult.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
    submit(otherToken, "COMPLAINT", "Someone else's complaint.");

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/feedback/me")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[0].message").value("Please add dark mode charts."))
        .andExpect(MockMvcResultMatchers.jsonPath("$[1].message").value("First note."));
  }

  private void submit(String token, String category, String message) throws Exception {
    var body = objectMapper.createObjectNode().put("category", category).put("message", message);
    mockMvc.perform(
        as(token, MockMvcRequestBuilders.post("/api/v1/feedback"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));
  }
}
