package com.duitlah.api.networth;

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
class NetWorthFlowTests {

  @Autowired private MockMvc mockMvc;
  @Autowired private UserRepository userRepository;
  @Autowired private StringRedisTemplate redisTemplate;

  private final ObjectMapper objectMapper = new ObjectMapper();
  private String accessToken;

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
                                "networth@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void combinesAccountBalancesOtherAssetsAndLiabilitiesIntoOneNetWorthNumber() throws Exception {
    var accountBody =
        objectMapper
            .createObjectNode()
            .put("name", "Bank")
            .put("type", "BANK")
            .put("openingBalance", "10000.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(accountBody.toString()));

    var assetBody =
        objectMapper
            .createObjectNode()
            .put("type", "VEHICLE")
            .put("name", "Myvi")
            .put("estimatedValue", "25000.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/net-worth/other-assets"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(assetBody.toString()));

    var liabilityBody =
        objectMapper
            .createObjectNode()
            .put("type", "CAR_LOAN")
            .put("name", "Myvi loan")
            .put("originalAmount", "15000.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/liabilities"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(liabilityBody.toString()));

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/net-worth")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalAssets").value(35000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalLiabilities").value(15000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.netWorth").value(20000.00));
  }

  @Test
  void takingASnapshotPersistsItInHistory() throws Exception {
    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.post("/api/v1/net-worth/snapshots")))
        .andExpect(MockMvcResultMatchers.status().isCreated());

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/net-worth/snapshots")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(1));
  }

  @Test
  void deletingAnOtherAssetRemovesItFromNetWorth() throws Exception {
    var assetBody =
        objectMapper
            .createObjectNode()
            .put("type", "PROPERTY")
            .put("name", "Condo")
            .put("estimatedValue", "300000.00");
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/net-worth/other-assets"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(assetBody.toString()))
            .andReturn();
    String assetId = json(result).get("id").asText();

    mockMvc.perform(
        as(
            accessToken,
            MockMvcRequestBuilders.delete("/api/v1/net-worth/other-assets/" + assetId)));

    mockMvc
        .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/net-worth")))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalAssets").value(0));
  }
}
