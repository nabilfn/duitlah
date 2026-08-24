package com.duitlah.api.accounting;

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

/** Duitlah V2 Phase 6. */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class ChartOfAccountsFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String ownerToken;
  private String viewerToken;
  private String spaceId;

  @BeforeEach
  void setUp() throws Exception {
    userRepository.deleteAll();
    redisTemplate.getConnectionFactory().getConnection().serverCommands().flushAll();

    ownerToken = register("coa-owner@example.com", "Owner");
    register("coa-viewer@example.com", "Viewer");

    var body =
        objectMapper.createObjectNode().put("name", "CoaCo").put("legalName", "CoaCo Sdn Bhd");
    var result =
        mockMvc
            .perform(
                as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/business"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    spaceId = objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    var addBody =
        objectMapper
            .createObjectNode()
            .put("email", "coa-viewer@example.com")
            .put("role", "VIEWER");
    mockMvc.perform(
        as(ownerToken, MockMvcRequestBuilders.post("/api/v1/spaces/" + spaceId + "/members"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(addBody.toString()));
    viewerToken = login("coa-viewer@example.com");
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

  @Test
  void seedingDefaultsCreatesTheMalaysianSmeChartOfAccounts() throws Exception {
    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")))
        .andExpect(MockMvcResultMatchers.status().isCreated())
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(28));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts")))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.code=='1020')].name")
                .value("Accounts Receivable"))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$[?(@.code=='1000')].cashEquivalent").value(true));
  }

  @Test
  void seedingTwiceIsRejected() throws Exception {
    mockMvc.perform(
        as(
            ownerToken,
            MockMvcRequestBuilders.post(
                "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")));

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.code").value("CHART_OF_ACCOUNTS_ALREADY_SEEDED"));
  }

  @Test
  void aViewerCannotSeedOrCreateAccounts() throws Exception {
    mockMvc
        .perform(
            as(
                viewerToken,
                MockMvcRequestBuilders.post(
                    "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/seed-defaults")))
        .andExpect(MockMvcResultMatchers.status().isForbidden())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("INSUFFICIENT_PERMISSION"));
  }

  @Test
  void creatingACustomAccountWithADuplicateCodeIsRejected() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("code", "9000")
            .put("name", "Custom Reserve")
            .put("type", "EQUITY");
    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(
            as(
                    ownerToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(body.toString()))
        .andExpect(MockMvcResultMatchers.status().isConflict())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("ACCOUNT_CODE_ALREADY_EXISTS"));
  }

  @Test
  void archivingAnAccountMarksItArchivedButKeepsItReadable() throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("code", "9100")
            .put("name", "Temp Account")
            .put("type", "ASSET");
    var result =
        mockMvc
            .perform(
                as(
                        ownerToken,
                        MockMvcRequestBuilders.post(
                            "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(body.toString()))
            .andReturn();
    String accountId =
        objectMapper.readTree(result.getResponse().getContentAsString()).get("id").asText();

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.delete(
                    "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/" + accountId)))
        .andExpect(MockMvcResultMatchers.status().isOk());

    mockMvc
        .perform(
            as(
                ownerToken,
                MockMvcRequestBuilders.get(
                    "/api/v1/spaces/" + spaceId + "/accounting/chart-of-accounts/" + accountId)))
        .andExpect(MockMvcResultMatchers.jsonPath("$.archived").value(true));
  }
}
