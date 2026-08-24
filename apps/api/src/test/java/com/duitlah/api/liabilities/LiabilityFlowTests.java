package com.duitlah.api.liabilities;

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

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class LiabilityFlowTests {

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
                                "liabilities@example.com", "correct-horse-1", "Nabil"))))
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

  private String createLoan() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "CAR_LOAN")
            .put("name", "Myvi loan")
            .put("lender", "Maybank")
            .put("originalAmount", "30000.00");
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/liabilities"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return json(result).get("id").asText();
  }

  @Test
  void creatingALiabilityStartsWithFullOutstandingPrincipal() throws Exception {
    String liabilityId = createLoan();
    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/liabilities/" + liabilityId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.outstandingPrincipal").value(30000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("ACTIVE"));
  }

  @Test
  void recordingAPaymentReducesOutstandingPrincipalAndCreatesALinkedTransaction() throws Exception {
    String liabilityId = createLoan();
    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("amount", "600.00")
            .put("principalPortion", "500.00")
            .put("interestPortion", "100.00")
            .put("paidOn", "2026-08-01")
            .put("accountId", accountId);

    var result =
        mockMvc
            .perform(
                as(
                        accessToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/liabilities/" + liabilityId + "/payments"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(paymentBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    String transactionId = json(result).get("linkedTransactionId").asText();

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/liabilities/" + liabilityId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.outstandingPrincipal").value(29500.00));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/transactions/" + transactionId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.amount").value(600.00));
  }

  @Test
  void payingOffTheFullPrincipalMarksTheLiabilityPaidOff() throws Exception {
    String liabilityId = createLoan();
    var paymentBody =
        objectMapper
            .createObjectNode()
            .put("amount", "30000.00")
            .put("principalPortion", "30000.00")
            .put("paidOn", "2026-08-01");

    mockMvc.perform(
        as(
                accessToken,
                MockMvcRequestBuilders.post("/api/v1/liabilities/" + liabilityId + "/payments"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(paymentBody.toString()));

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/liabilities/" + liabilityId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PAID_OFF"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.outstandingPrincipal").value(0));
  }

  @Test
  void nonOwnerCannotSeeAnotherUsersLiability() throws Exception {
    String liabilityId = createLoan();
    var other =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(
                                "liabilities-other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken = json(other).get("accessToken").asText();

    mockMvc
        .perform(as(otherToken, MockMvcRequestBuilders.get("/api/v1/liabilities/" + liabilityId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
