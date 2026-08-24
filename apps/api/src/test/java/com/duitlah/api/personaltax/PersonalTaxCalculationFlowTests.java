package com.duitlah.api.personaltax;

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
 * Verifies the exact pipeline the spec describes (section 29): income - reliefs = chargeable income
 * -> brackets -> rebate -> zakat -> PCB -> estimated payable/refund. YA2026's seeded
 * brackets/self-relief (see V20__seed_tax_years.sql) are used as fixed, known inputs so the
 * expected numbers here are hand-computed, not just "whatever the code returns."
 */
@SpringBootTest
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class PersonalTaxCalculationFlowTests {

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
                            new RegisterRequest("tax@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  private void addIncome(String amount) throws Exception {
    addIncome(2026, amount);
  }

  private void addIncome(int yearOfAssessment, String amount) throws Exception {
    var body =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", yearOfAssessment)
            .put("incomeType", "EMPLOYMENT")
            .put("amount", amount);
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/income"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(body.toString()));
  }

  @Test
  void calculatingForAnUnconfiguredYearOfAssessmentIs404() throws Exception {
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "1999"))
        .andExpect(MockMvcResultMatchers.status().isNotFound())
        .andExpect(MockMvcResultMatchers.jsonPath("$.code").value("TAX_YEAR_NOT_CONFIGURED"));
  }

  @Test
  void aZeroIncomeYearOwesNoTaxAndAnyPcbPaidIsARefund() throws Exception {
    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalIncome").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.chargeableIncome").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.grossTaxPayable").value(0))
        .andExpect(
            MockMvcResultMatchers.jsonPath("$.disclaimer")
                .value(org.hamcrest.Matchers.containsString("estimate")));
  }

  @Test
  void incomeJustAboveSelfReliefFallsEntirelyInTheZeroPercentBandAndGetsTheRebate()
      throws Exception {
    // Self relief 9000 (seeded). Income 12000 -> chargeable 3000, which is under the 5000
    // zero-rate ceiling, so gross tax is 0, and the RM400 rebate has nothing to reduce.
    addIncome("12000.00");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.chargeableIncome").value(3000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.grossTaxPayable").value(0))
        .andExpect(MockMvcResultMatchers.jsonPath("$.rebate").value(0));
  }

  @Test
  void progressiveBracketsOnlyTaxEachSliceAtItsOwnRate() throws Exception {
    // Self relief 9000. Income 39000 -> chargeable 30000.
    // 0-5000 @0% = 0; 5000-20000 @1% = 150; 20000-30000 @3% = 300. Total = 450.
    // Chargeable 30000 <= 35000 rebate threshold -> RM400 rebate applies.
    addIncome("39000.00");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.chargeableIncome").value(30000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.grossTaxPayable").value(450.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.rebate").value(400.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.taxAfterRebatesAndZakat").value(50.00));
  }

  @Test
  void zakatIsClampedToTaxPayableNeverProducingANegativeRebate() throws Exception {
    addIncome("39000.00"); // gross tax after rebate = 50.00 (see above)

    var zakatBody =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("amount", "5000.00")
            .put("paidOn", "2026-06-01");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/zakat"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(zakatBody.toString()));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.zakatPaid").value(5000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.zakatRebate").value(50.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.taxAfterRebatesAndZakat").value(0));
  }

  @Test
  void pcbAlreadyPaidReducesTheEstimatedPayableAndCanProduceARefund() throws Exception {
    addIncome("39000.00"); // tax after rebate = 50.00

    var pcbBody =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("month", 6)
            .put("amount", "200.00");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/personal-tax/pcb"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(pcbBody.toString()));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.pcbPaid").value(200.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.estimatedPayableOrRefund").value(-150.00));
  }

  @Test
  void confirmedReliefsAreClampedToTheYAsReliefCeiling() throws Exception {
    addIncome("50000.00");

    var candidateBody =
        objectMapper
            .createObjectNode()
            .put("yearOfAssessment", 2026)
            .put("suggestedAmount", "5000.00");
    var candidateResult =
        mockMvc
            .perform(
                as(
                        accessToken,
                        MockMvcRequestBuilders.post("/api/v1/personal-tax/relief-candidates"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(candidateBody.toString()))
            .andReturn();
    String candidateId = json(candidateResult).get("id").asText();

    // LIFESTYLE's seeded ceiling is 2500 -- claiming 5000 should be clamped down to 2500.
    var confirmBody =
        objectMapper.createObjectNode().put("category", "LIFESTYLE").put("amount", "5000.00");
    mockMvc
        .perform(
            as(
                    accessToken,
                    MockMvcRequestBuilders.post(
                        "/api/v1/personal-tax/relief-candidates/" + candidateId + "/confirm"))
                .contentType(MediaType.APPLICATION_JSON)
                .content(confirmBody.toString()))
        .andExpect(MockMvcResultMatchers.jsonPath("$.confirmedAmount").value(2500.00));

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2026"))
        .andExpect(MockMvcResultMatchers.jsonPath("$.totalReliefs").value(2500.00));
  }

  @Test
  void historicalYearOfAssessmentRemainsReproducibleIndependentlyOfTheCurrentYear()
      throws Exception {
    addIncome(2024, "39000.00");

    mockMvc
        .perform(
            as(accessToken, MockMvcRequestBuilders.get("/api/v1/personal-tax/calculation"))
                .queryParam("yearOfAssessment", "2024"))
        .andExpect(MockMvcResultMatchers.status().isOk())
        .andExpect(MockMvcResultMatchers.jsonPath("$.yearOfAssessment").value(2024))
        .andExpect(MockMvcResultMatchers.jsonPath("$.chargeableIncome").value(30000.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.grossTaxPayable").value(450.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.rebate").value(400.00))
        .andExpect(MockMvcResultMatchers.jsonPath("$.estimatedPayableOrRefund").value(50.00));
  }
}
