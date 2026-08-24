package com.duitlah.api.common.idempotency;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
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

/**
 * Exercises the actual HTTP filter chain (not just {@link IdempotencyFilter} in isolation) against
 * a real transaction-creation endpoint, since the behavior that matters is "does a real financial
 * write get deduplicated end-to-end," not the filter's internals in the abstract.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class IdempotencyFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String accountId;

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
                            new RegisterRequest("idem@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
            .readTree(result.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Wallet")
            .put("type", "CASH")
            .put("openingBalance", "0.00");
    var accountResult =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId =
        objectMapper.readTree(accountResult.getResponse().getContentAsString()).get("id").asText();
  }

  private MockHttpServletRequestBuilder auth(MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private String transactionBody() {
    return objectMapper
        .createObjectNode()
        .put("accountId", accountId)
        .put("type", "EXPENSE")
        .put("amount", "42.00")
        .put("occurredOn", "2026-08-01")
        .toString();
  }

  @Test
  void repeatingTheSameIdempotencyKeyReplaysTheOriginalResponseInsteadOfCreatingADuplicate()
      throws Exception {
    var first =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                    .header("Idempotency-Key", "test-key-1")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(transactionBody()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    String firstId =
        objectMapper.readTree(first.getResponse().getContentAsString()).get("id").asText();

    var second =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                    .header("Idempotency-Key", "test-key-1")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(transactionBody()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    String secondId =
        objectMapper.readTree(second.getResponse().getContentAsString()).get("id").asText();

    assertThat(secondId).isEqualTo(firstId);

    JsonNode list =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/transactions")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    assertThat(list.get("content")).hasSize(1);
  }

  @Test
  void differentIdempotencyKeysCreateSeparateTransactions() throws Exception {
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .header("Idempotency-Key", "key-a")
                .contentType(MediaType.APPLICATION_JSON)
                .content(transactionBody()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .header("Idempotency-Key", "key-b")
                .contentType(MediaType.APPLICATION_JSON)
                .content(transactionBody()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    JsonNode list =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/transactions")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    assertThat(list.get("content")).hasSize(2);
  }

  @Test
  void requestsWithNoIdempotencyKeyAreUnaffected() throws Exception {
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(transactionBody()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(transactionBody()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    JsonNode list =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/transactions")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    assertThat(list.get("content")).hasSize(2);
  }

  @Test
  void concurrentRequestsWithTheSameKeyNeverBothSucceedAsDistinctRecords() throws Exception {
    int threadCount = 5;
    ExecutorService pool = Executors.newFixedThreadPool(threadCount);
    CountDownLatch ready = new CountDownLatch(threadCount);
    CountDownLatch go = new CountDownLatch(1);
    AtomicInteger created = new AtomicInteger();
    AtomicInteger conflicted = new AtomicInteger();

    for (int i = 0; i < threadCount; i++) {
      pool.submit(
          () -> {
            try {
              ready.countDown();
              go.await();
              int status =
                  mockMvc
                      .perform(
                          auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                              .header("Idempotency-Key", "concurrent-key")
                              .contentType(MediaType.APPLICATION_JSON)
                              .content(transactionBody()))
                      .andReturn()
                      .getResponse()
                      .getStatus();
              if (status == 201) {
                created.incrementAndGet();
              } else if (status == 409) {
                conflicted.incrementAndGet();
              }
            } catch (Exception ignored) {
              // A thread failing to even issue the request doesn't invalidate the assertion below.
            }
          });
    }
    ready.await();
    go.countDown();
    pool.shutdown();
    pool.awaitTermination(30, TimeUnit.SECONDS);

    // Every 201 response must be the *same* underlying transaction -- verified by the row count,
    // not the response count, since a slower thread might land on the cached-replay path (also
    // 201) rather than the in-progress 409 depending on timing.
    assertThat(created.get() + conflicted.get()).isEqualTo(threadCount);
    JsonNode list =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/transactions")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    assertThat(list.get("content")).hasSize(1);
  }
}
