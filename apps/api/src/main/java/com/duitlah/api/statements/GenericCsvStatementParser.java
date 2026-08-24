package com.duitlah.api.statements;

import java.io.IOException;
import java.io.StringReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.stereotype.Component;

/**
 * Column-detection heuristic over an arbitrary CSV export, rather than one hardcoded column layout
 * — most bank/e-wallet CSV exports share this general shape (a date column, a description column,
 * and either one signed amount column or a debit/credit pair) even though the exact header names
 * vary by provider. A row that doesn't fit is skipped, not fatal (see {@link StatementParser}).
 */
@Component
public class GenericCsvStatementParser implements StatementParser {

  @Override
  public StatementProvider provider() {
    return StatementProvider.GENERIC_CSV;
  }

  @Override
  public List<ParsedStatementRow> parse(byte[] fileBytes) {
    List<ParsedStatementRow> rows = new ArrayList<>();
    try (CSVParser parser =
        CSVFormat.DEFAULT
            .builder()
            .setHeader()
            .setSkipHeaderRecord(true)
            .setIgnoreSurroundingSpaces(true)
            .setTrim(true)
            .build()
            .parse(new StringReader(new String(fileBytes, StandardCharsets.UTF_8)))) {

      Map<String, Integer> headerMap = parser.getHeaderMap();
      String dateCol = findColumn(headerMap, StatementParsingSupport.DATE_HEADERS);
      String descCol = findColumn(headerMap, StatementParsingSupport.DESCRIPTION_HEADERS);
      String amountCol = findColumn(headerMap, StatementParsingSupport.AMOUNT_HEADERS);
      String debitCol = findColumn(headerMap, StatementParsingSupport.DEBIT_HEADERS);
      String creditCol = findColumn(headerMap, StatementParsingSupport.CREDIT_HEADERS);

      if (dateCol == null || (amountCol == null && debitCol == null && creditCol == null)) {
        return rows;
      }

      for (CSVRecord record : parser) {
        LocalDate date = StatementParsingSupport.parseDate(record.get(dateCol));
        if (date == null) {
          continue;
        }
        BigDecimal amount =
            amountCol != null
                ? StatementParsingSupport.parseAmount(record.get(amountCol))
                : StatementParsingSupport.signedFromDebitCredit(
                    debitCol != null ? record.get(debitCol) : null,
                    creditCol != null ? record.get(creditCol) : null);
        if (amount == null) {
          continue;
        }
        String description = descCol != null ? record.get(descCol) : null;
        double confidence = description != null && !description.isBlank() ? 0.9 : 0.7;
        rows.add(new ParsedStatementRow(date, description, amount, confidence));
      }
    } catch (IOException e) {
      return rows;
    }
    return rows;
  }

  private static String findColumn(Map<String, Integer> headerMap, List<String> candidates) {
    for (String header : headerMap.keySet()) {
      if (candidates.contains(header.trim().toLowerCase())) {
        return header;
      }
    }
    return null;
  }
}
