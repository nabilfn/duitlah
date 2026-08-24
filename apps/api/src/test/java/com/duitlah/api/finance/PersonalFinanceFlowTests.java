package com.duitlah.api.finance;

import static org.assertj.core.api.Assertions.assertThat;

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
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class PersonalFinanceFlowTests {

  @Autowired private MockMvc mockMvc;

  private final ObjectMapper objectMapper = new ObjectMapper();

  @Autowired private UserRepository userRepository;

  @Autowired private StringRedisTemplate redisTemplate;

  private String accessToken;

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
                                "finance@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken =
        objectMapper
            .readTree(result.getResponse().getContentAsString())
            .get("accessToken")
            .asText();
  }

  private org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder auth(
      org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + accessToken);
  }

  private JsonNode createAccount(String name, String type, String openingBalance) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", type)
            .put("openingBalance", openingBalance);
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void createdAccountStartsAtOpeningBalance() throws Exception {
    JsonNode account = createAccount("Maybank", "BANK", "100.00");
    assertThat(account.get("balance").asText()).isEqualTo("100.0");
    assertThat(account.get("archived").asBoolean()).isFalse();
  }

  @Test
  void incomeAndExpenseTransactionsAdjustAccountBalance() throws Exception {
    JsonNode account = createAccount("Wallet", "CASH", "0.00");
    String accountId = account.get("id").asText();

    postTransaction(accountId, "INCOME", "1000.00");
    postTransaction(accountId, "EXPENSE", "150.00");

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + accountId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(850.00));
  }

  @Test
  void transferMovesMoneyBetweenAccountsAndBothSidesAreLinked() throws Exception {
    JsonNode maybank = createAccount("Maybank", "BANK", "500.00");
    JsonNode cimb = createAccount("CIMB", "BANK", "0.00");

    var body =
        objectMapper
            .createObjectNode()
            .put("fromAccountId", maybank.get("id").asText())
            .put("toAccountId", cimb.get("id").asText())
            .put("amount", "200.00")
            .put("occurredOn", "2026-08-01");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/transactions/transfer"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andExpect(MockMvcResultMatchers.status().isCreated())
            .andReturn();
    JsonNode pair = objectMapper.readTree(result.getResponse().getContentAsString());
    assertThat(pair).hasSize(2);
    assertThat(pair.get(0).get("transferGroupId").asText())
        .isEqualTo(pair.get(1).get("transferGroupId").asText());

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + maybank.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(300.00));
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + cimb.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(200.00));
  }

  @Test
  void deletingATransferRemovesBothLinkedRowsAndRestoresBalances() throws Exception {
    JsonNode maybank = createAccount("Maybank", "BANK", "500.00");
    JsonNode cimb = createAccount("CIMB", "BANK", "0.00");

    var body =
        objectMapper
            .createObjectNode()
            .put("fromAccountId", maybank.get("id").asText())
            .put("toAccountId", cimb.get("id").asText())
            .put("amount", "200.00")
            .put("occurredOn", "2026-08-01");
    var result =
        mockMvc
            .perform(
                auth(MockMvcRequestBuilders.post("/api/v1/transactions/transfer"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String outgoingId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get(0).get("id").asText();

    mockMvc
        .perform(auth(MockMvcRequestBuilders.delete("/api/v1/transactions/" + outgoingId)))
        .andExpect(MockMvcResultMatchers.status().isNoContent());

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + maybank.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(500.00));
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/accounts/" + cimb.get("id").asText())))
        .andExpect(MockMvcResultMatchers.jsonPath("$.balance").value(0.00));
  }

  @Test
  void transferToSameAccountIsRejected() throws Exception {
    JsonNode account = createAccount("Maybank", "BANK", "500.00");
    var body =
        objectMapper
            .createObjectNode()
            .put("fromAccountId", account.get("id").asText())
            .put("toAccountId", account.get("id").asText())
            .put("amount", "50.00")
            .put("occurredOn", "2026-08-01");

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions/transfer"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isBadRequest())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("SAME_ACCOUNT_TRANSFER"));
  }

  @Test
  void systemDefaultCategoriesAreListedAndIncludeFoodAndIncome() throws Exception {
    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/categories")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$[?(@.name == 'Food')]").exists())
        .andExpect(MockMvcResultMatchers.jsonPath("$[?(@.name == 'Restaurants')]").exists())
        .andExpect(MockMvcResultMatchers.jsonPath("$[?(@.name == 'Income')]").exists());
  }

  @Test
  void expenseCategoryCannotBeUsedOnAnIncomeTransaction() throws Exception {
    JsonNode account = createAccount("Wallet", "CASH", "0.00");
    JsonNode categories =
        objectMapper.readTree(
            mockMvc
                .perform(auth(MockMvcRequestBuilders.get("/api/v1/categories")))
                .andReturn()
                .getResponse()
                .getContentAsString());
    String foodCategoryId = null;
    for (JsonNode c : categories) {
      if ("Restaurants".equals(c.get("name").asText())) {
        foodCategoryId = c.get("id").asText();
      }
    }
    assertThat(foodCategoryId).isNotNull();

    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", account.get("id").asText())
            .put("type", "INCOME")
            .put("categoryId", foodCategoryId)
            .put("amount", "100.00")
            .put("occurredOn", "2026-08-01");

    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("CATEGORY_TYPE_MISMATCH"));
  }

  @Test
  void dashboardSummarizesBalanceAndMonthTotals() throws Exception {
    JsonNode account = createAccount("Wallet", "CASH", "0.00");
    String accountId = account.get("id").asText();
    postTransaction(accountId, "INCOME", "1000.00");
    postTransaction(accountId, "EXPENSE", "200.00");

    mockMvc
        .perform(auth(MockMvcRequestBuilders.get("/api/v1/dashboard")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.availableBalance").value(800.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.monthIncome").value(1000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.monthExpense").value(200.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.recentTransactions.length()").value(2));
  }

  @Test
  void anotherUsersAccountIsNotFoundNotForbidden() throws Exception {
    JsonNode myAccount = createAccount("Wallet", "CASH", "0.00");

    // A second, independent user.
    var registerResult =
        mockMvc
            .perform(
                MockMvcRequestBuilders.post("/api/v1/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        objectMapper.writeValueAsString(
                            new RegisterRequest("other@example.com", "correct-horse-1", "Ameer"))))
            .andReturn();
    String otherToken =
        objectMapper
            .readTree(registerResult.getResponse().getContentAsString())
            .get("accessToken")
            .asText();

    mockMvc
        .perform(
            MockMvcRequestBuilders.get("/api/v1/accounts/" + myAccount.get("id").asText())
                .header("Authorization", "Bearer " + otherToken))
        .andExpect(MockMvcResultMatchers.status().isNotFound());
  }

  private void postTransaction(String accountId, String type, String amount) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", type)
            .put("amount", amount)
            .put("occurredOn", "2026-08-01");
    mockMvc
        .perform(
            auth(MockMvcRequestBuilders.post("/api/v1/transactions"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());
  }
}
