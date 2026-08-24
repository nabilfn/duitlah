package com.duitlah.api.exports;

import static org.assertj.core.api.Assertions.assertThat;

import com.duitlah.api.TestcontainersConfiguration;
import com.duitlah.api.auth.RegisterRequest;
import com.duitlah.api.users.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.ByteArrayInputStream;
import java.util.zip.ZipInputStream;
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
class ExportFlowTests {

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
                                "exports@example.com", "correct-horse-1", "Nabil"))))
            .andReturn();
    accessToken = json(registerResult).get("accessToken").asText();

    var accountBody = objectMapper.createObjectNode().put("name", "Wallet").put("type", "CASH");
    var accountResult =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.post("/api/v1/accounts"))
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(accountBody.toString()))
            .andReturn();
    accountId = json(accountResult).get("id").asText();

    var transactionBody =
        objectMapper
            .createObjectNode()
            .put("accountId", accountId)
            .put("type", "EXPENSE")
            .put("amount", "20.00")
            .put("merchant", "Kopitiam")
            .put("occurredOn", "2026-08-20");
    mockMvc.perform(
        as(accessToken, MockMvcRequestBuilders.post("/api/v1/transactions"))
            .contentType(MediaType.APPLICATION_JSON)
            .content(transactionBody.toString()));
  }

  private MockHttpServletRequestBuilder as(String token, MockHttpServletRequestBuilder builder) {
    return builder.header("Authorization", "Bearer " + token);
  }

  private JsonNode json(MvcResult result) throws Exception {
    return objectMapper.readTree(result.getResponse().getContentAsString());
  }

  @Test
  void exportingTransactionsAsCsvIncludesTheRealTransaction() throws Exception {
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/exports/transactions"))
                    .queryParam("from", "2026-01-01")
                    .queryParam("to", "2026-12-31")
                    .queryParam("format", "CSV"))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andExpect(MockMvcResultMatchers.header().string("Content-Type", "text/csv"))
            .andReturn();

    String csv = result.getResponse().getContentAsString();
    assertThat(csv).contains("Kopitiam").contains("20.00");
  }

  @Test
  void exportingTransactionsAsXlsxProducesARealWorkbook() throws Exception {
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/exports/transactions"))
                    .queryParam("from", "2026-01-01")
                    .queryParam("to", "2026-12-31")
                    .queryParam("format", "XLSX"))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

    byte[] content = result.getResponse().getContentAsByteArray();
    try (org.apache.poi.xssf.usermodel.XSSFWorkbook workbook =
        new org.apache.poi.xssf.usermodel.XSSFWorkbook(new ByteArrayInputStream(content))) {
      var sheet = workbook.getSheetAt(0);
      assertThat(sheet.getRow(1).getCell(3).getStringCellValue()).isEqualTo("Kopitiam");
    }
  }

  @Test
  void exportingTransactionsAsPdfProducesARealPdfDocument() throws Exception {
    var result =
        mockMvc
            .perform(
                as(accessToken, MockMvcRequestBuilders.get("/api/v1/exports/transactions"))
                    .queryParam("from", "2026-01-01")
                    .queryParam("to", "2026-12-31")
                    .queryParam("format", "PDF"))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

    byte[] content = result.getResponse().getContentAsByteArray();
    assertThat(new String(content, 0, 5, java.nio.charset.StandardCharsets.US_ASCII))
        .isEqualTo("%PDF-");
  }

  @Test
  void fullArchiveIsARealZipContainingEveryExport() throws Exception {
    var result =
        mockMvc
            .perform(as(accessToken, MockMvcRequestBuilders.get("/api/v1/exports/archive")))
            .andExpect(MockMvcResultMatchers.status().isOk())
            .andReturn();

    java.util.List<String> entryNames = new java.util.ArrayList<>();
    try (ZipInputStream zip =
        new ZipInputStream(
            new ByteArrayInputStream(result.getResponse().getContentAsByteArray()))) {
      var entry = zip.getNextEntry();
      while (entry != null) {
        entryNames.add(entry.getName());
        entry = zip.getNextEntry();
      }
    }
    assertThat(entryNames)
        .containsExactlyInAnyOrder(
            "transactions.csv", "bills.csv", "loans.csv", "net-worth.csv", "budgets.csv");
  }
}
