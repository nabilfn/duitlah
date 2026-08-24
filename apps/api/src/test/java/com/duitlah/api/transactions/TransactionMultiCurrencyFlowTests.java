package com.duitlah.api.transactions;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
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

/**
 * V2 Phase 3 (spec section 22) — a display snapshot generalized from Trip mode's group_expenses
 * columns. {@code amount} always stays the real base-currency figure regardless of whether a
 * multi-currency snapshot was also sent.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class TransactionMultiCurrencyFlowTests {

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

    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "multicurrency@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();

    var accountBody = objectMapper.createObjectNode().put("name", "Bank").put("type", "BANK");
    var accountResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId = json(accountResult).get("id").asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void aTransactionWithNoCurrencySnapshotLeavesTheNewFieldsNull() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "50.00")
            .put("occurredOn", "2026-08-20");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.originalCurrency").doesNotExist());
  }

  @Test
  void aTransactionWithAForeignCurrencySnapshotStoresItAlongsideTheRealBaseAmount()
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "45.00")
            .put("occurredOn", "2026-08-20")
            .put("originalCurrency", "JPY")
            .put("originalAmount", "1500")
            .put("exchangeRate", "0.03");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.amount").value(45.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.originalCurrency").value("JPY"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.originalAmount").value(1500))
        .andExpect(MockMvcResultMatchers.jsonPath("$.convertedAt").exists());
  }

  @Test
  void anInvalidCurrencyCodeIsRejected() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "45.00")
            .put("occurredOn", "2026-08-20")
            .put("originalCurrency", "yen");
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest());
  }
}
