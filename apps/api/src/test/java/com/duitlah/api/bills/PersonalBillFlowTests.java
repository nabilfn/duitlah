package com.duitlah.api.bills;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.notifications.NotificationService;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.LocalDate;
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
class PersonalBillFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private PersonalBillScheduler scheduler;
  @Autowired private NotificationService notifications;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;
  private String accountId;
  private java.util.UUID userId;

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
                            new RegisterRequest("bills@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
    userId = java.util.UUID.fromString(json(registerResult).get("user").get("id").asText());

    var accountBody = objectMapper.createObjectNode().put("name", "Wallet").put("type", "CASH");
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
  void creatingABillDefaultsToUpcoming() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", "Astro")
            .put("provider", "Astro Malaysia")
            .put("dueDate", LocalDate.now().plusDays(20).toString())
            .put("expectedAmount", "99.90");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-bills"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("UPCOMING"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.recurrence").value("NONE"));
  }

  @Test
  void markingABillPaidCreatesARealLinkedTransaction() throws Exception {
    String billId = createBill("Astro", LocalDate.now().plusDays(5), "99.90", "NONE");

    var payBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("amount", "99.90")
            .put("paidOn", LocalDate.now().toString());

    var result =
        mockMvc
            .perform(
                as(
                        accessToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/personal-bills/" + billId + "/mark-paid"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(payBody.toString()))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.jsonPath("$.status").value("PAID"))
            .andReturn();
    String transactionId = json(result).get("linkedTransactionId").asText();

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/transactions/" + transactionId)))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.amount").value(99.90))
        .andExpect(MockMvcResultMatchers.jsonPath("$.type").value("EXPENSE"));
  }

  @Test
  void markingARecurringBillPaidCreatesTheNextOccurrence() throws Exception {
    LocalDate dueDate = LocalDate.now().plusDays(2);
    String billId = createBill("Netflix", dueDate, "55.00", "MONTHLY");

    var payBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("amount", "55.00")
            .put("paidOn", LocalDate.now().toString());
    mockMvc.perform(
        as(
                accessToken,
                MockMvcRequestBuilders.post("/api/v1/personal-bills/" + billId + "/mark-paid"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(payBody.toString()));

    var listResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-bills"))
                    .queryParam("status", "UPCOMING"))
            .andReturn();
    JsonNode upcoming = json(listResult);
    assertThat(upcoming.isArray()).isTrue();
    boolean foundNext =
        java.util.stream.StreamSupport.stream(upcoming.spliterator(), false)
            .anyMatch(b -> b.get("dueDate").asText().equals(dueDate.plusMonths(1).toString()));
    assertThat(foundNext).isTrue();
  }

  @Test
  void markingAnAlreadyPaidBillPaidAgainIsRejected() throws Exception {
    String billId = createBill("Astro", LocalDate.now().plusDays(5), "99.90", "NONE");
    var payBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("amount", "99.90")
            .put("paidOn", LocalDate.now().toString());
    mockMvc.perform(
        as(
                accessToken,
                MockMvcRequestBuilders.post("/api/v1/personal-bills/" + billId + "/mark-paid"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(payBody.toString()));

    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post("/api/v1/personal-bills/" + billId + "/mark-paid"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(payBody.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("BILL_ALREADY_RESOLVED"));
  }

  @Test
  void schedulerFlipsAnOverdueBillAndSendsANotification() throws Exception {
    createBill("Water bill", LocalDate.now().minusDays(1), "40.00", "NONE");

    scheduler.updateBillStatuses();

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-bills"))
                .queryParam("status", "OVERDUE"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));

    assertThat(notifications.unreadCount(userId)).isGreaterThan(0);
  }

  private String createBill(String name, LocalDate dueDate, String amount, String recurrence)
      throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("dueDate", dueDate.toString())
            .put("expectedAmount", amount)
            .put("recurrence", recurrence);
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-bills"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return json(result).get("id").asText();
  }
}
