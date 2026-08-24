package com.duitlah.api.bizbanking;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
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
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

/**
 * Duitlah V2 Phase 5. Balance is always computed, never stored — see {@code
 * BusinessAccountService}.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class BusinessAccountFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String staffToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("bank-owner@example.com", "Owner");
    register("bank-staff@example.com", "Staff");

    var body =
        objectMapper.createObjectNode().put("name", "BankCo").put("legalName", "BankCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper.createObjectNode().put("email", "bank-staff@example.com").put("role", "STAFF");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    staffToken = login("bank-staff@example.com");
  }

  private String register(String email, String name) throws Exception {
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest(email, "correct-horse-1", name))))
            .andReturn();
    return objectMapper
        .readTree(result.getResponse().getContentAsString())
        .get("accessToken")
        .asText();
  }

  private String login(String email) throws Exception {
    var body =
        objectMapper.createObjectNode().put("email", email).put("password", "correct-horse-1");
    var result =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/login")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper
        .readTree(result.getResponse().getContentAsString())
        .get("accessToken")
        .asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private String createAccount(String name, String type, String openingBalance) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", type)
            .put("openingBalance", openingBalance);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/business-accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  @Test
  void creatingAnAccountDefaultsToMyrAndReturnsOpeningBalance() throws Exception {
    createAccount("Maybank Current", "BANK", "1000.00");

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get("/api/v1/spaces/" + spaceId + "/business-accounts")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].currency").value("MYR"))
        .andExpect(MockMvcResultMatchers.jsonPath("$[0].balance").value(1000.00));
  }

  @Test
  void aStaffMemberWithoutManageBankingCannotCreateAnAccount() throws Exception {
    var body = objectMapper.createObjectNode().put("name", "Blocked").put("type", "CASH");
    mockMvc
        .perform(
            as(
                    staffToken,
                    MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/business-accounts"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void manualEntriesChangeTheComputedBalance() throws Exception {
    String accountId = createAccount("Cash Drawer", "CASH", "0.00");

    var inflow =
        objectMapper
            .createObjectNode()
            .put("direction", "IN")
            .put("amount", "500.00")
            .put("occurredOn", "2026-08-01")
            .put("description", "Owner top-up");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/business-accounts/"
                            + accountId
                            + "/entries"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(inflow.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    var outflow =
        objectMapper
            .createObjectNode()
            .put("direction", "OUT")
            .put("amount", "120.00")
            .put("occurredOn", "2026-08-02")
            .put("description", "Petty cash");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/business-accounts/"
                            + accountId
                            + "/entries"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(outflow.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + accountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(380.00));
  }

  @Test
  void transferringBetweenTwoAccountsMovesTheBalanceCorrectly() throws Exception {
    String fromAccount = createAccount("Main Bank", "BANK", "2000.00");
    String toAccount = createAccount("Payroll Reserve", "BANK", "0.00");

    var transfer =
        objectMapper
            .createObjectNode()
            .put("toBusinessAccountId", toAccount)
            .put("amount", "800.00")
            .put("occurredOn", "2026-08-05")
            .put("description", "Payroll funding");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/"
                            + spaceId
                            + "/business-accounts/"
                            + fromAccount
                            + "/transfer"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(transfer.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + fromAccount)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(1200.00));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/business-accounts/" + toAccount)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(800.00));
  }

  @Test
  void gettingAnAccountFromAnotherSpaceIsNotFound() throws Exception {
    String otherOwnerToken = register("bank-other-owner@example.com", "Other Owner");
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "OtherBankCo")
            .put("legalName", "OtherBankCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(otherOwnerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String otherSpaceId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
    String accountId = createAccount("Isolated Account", "CASH", "0.00");

    mockMvc
        .perform(
            as(
                otherOwnerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + otherSpaceId + "/business-accounts/" + accountId)))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }
}
