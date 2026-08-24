package com.duitlah.api.inventory;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.notifications.NotificationService;
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

/**
 * Duitlah V2 Phase 8 — low-stock alerts. Invokes the scheduler's method directly rather than
 * waiting for its cron trigger, matching {@code bills.PersonalBillScheduler}'s testable-method
 * precedent.
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class LowStockAlertFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;
  @Autowired private LowStockAlertScheduler scheduler;
  @Autowired private NotificationService notifications;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private UUID ownerUserId;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("lowstock-owner@example.com", "Owner");
    ownerUserId =
        userRepository.findByEmailIgnoreCase("lowstock-owner@example.com").orElseThrow().getId();

    var body =
        objectMapper.createObjectNode().put("name", "AlertCo").put("legalName", "AlertCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private String createTrackedProduct(String name, String reorderPoint) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("name", name)
            .put("type", "GOODS")
            .put("unitPrice", "20.00")
            .put("trackInventory", true)
            .put("reorderPoint", reorderPoint);
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/products"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    return objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();
  }

  private void recordOpeningBalance(String productId, String quantity) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("type", "OPENING_BALANCE")
            .put("quantity", quantity)
            .put("unitCost", "5.00")
            .put("occurredOn", "2026-08-20");
    mockMvc.perform(
        as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/products/" + productId + "/movements"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));
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

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  @Test
  void aProductAtOrBelowItsReorderPointNotifiesOwnerOnce() throws Exception {
    String productId = createTrackedProduct("Cooking Oil", "10.000");
    recordOpeningBalance(productId, "5");

    long before = notifications.unreadCount(ownerUserId);
    scheduler.checkLowStock();
    assertThat(notifications.unreadCount(ownerUserId)).isGreaterThan(before);

    long afterFirstRun = notifications.unreadCount(ownerUserId);
    scheduler.checkLowStock();
    assertThat(notifications.unreadCount(ownerUserId)).isEqualTo(afterFirstRun);
  }

  @Test
  void aProductAboveItsReorderPointIsNotAlerted() throws Exception {
    String productId = createTrackedProduct("Fresh Milk", "10.000");
    recordOpeningBalance(productId, "50");

    long before = notifications.unreadCount(ownerUserId);
    scheduler.checkLowStock();
    assertThat(notifications.unreadCount(ownerUserId)).isEqualTo(before);
  }
}
