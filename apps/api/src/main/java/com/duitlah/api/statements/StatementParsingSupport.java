package com.duitlah.api.statements;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

/** Date/amount normalization shared by every {@link StatementParser} implementation. */
final class StatementParsingSupport {

  static final List<String> DATE_HEADERS =
      List.of("date", "transaction date", "posting date", "value date");
  static final List<String> DESCRIPTION_HEADERS =
      List.of("description", "narrative", "particulars", "details", "merchant", "remarks");
  static final List<String> AMOUNT_HEADERS = List.of("amount", "value");
  static final List<String> DEBIT_HEADERS = List.of("debit", "withdrawal", "money out");
  static final List<String> CREDIT_HEADERS = List.of("credit", "deposit", "money in");

  private static final List<DateTimeFormatter> DATE_FORMATS =
      List.of(
          DateTimeFormatter.ofPattern("yyyy-MM-dd"),
          DateTimeFormatter.ofPattern("dd/MM/yyyy"),
          DateTimeFormatter.ofPattern("MM/dd/yyyy"),
          DateTimeFormatter.ofPattern("dd-MM-yyyy"),
          DateTimeFormatter.ofPattern("d MMM yyyy"));

  private StatementParsingSupport() {}

  static LocalDate parseDate(String raw) {
    if (raw == null || raw.isBlank()) {
      return null;
    }
    for (DateTimeFormatter format : DATE_FORMATS) {
      try {
        return LocalDate.parse(raw.trim(), format);
      } catch (DateTimeParseException ignored) {
        // try the next format
      }
    }
    return null;
  }

  static BigDecimal parseAmount(String raw) {
    if (raw == null || raw.isBlank()) {
      return null;
    }
    String cleaned = raw.trim().replaceAll("[^0-9.,()-]", "");
    boolean negative = cleaned.startsWith("(") && cleaned.endsWith(")");
    if (negative) {
      cleaned = cleaned.substring(1, cleaned.length() - 1);
    }
    cleaned = cleaned.replace(",", "");
    if (cleaned.isBlank()) {
      return null;
    }
    try {
      BigDecimal value = new BigDecimal(cleaned);
      return negative ? value.negate() : value;
    } catch (NumberFormatException e) {
      return null;
    }
  }

  static BigDecimal signedFromDebitCredit(String debitRaw, String creditRaw) {
    BigDecimal debit = parseAmount(debitRaw);
    BigDecimal credit = parseAmount(creditRaw);
    if (credit != null && credit.compareTo(BigDecimal.ZERO) != 0) {
      return credit.abs();
    }
    if (debit != null && debit.compareTo(BigDecimal.ZERO) != 0) {
      return debit.abs().negate();
    }
    return null;
  }

  static int findColumnIndex(List<String> headers, List<String> candidates) {
    for (int i = 0; i < headers.size(); i++) {
      if (headers.get(i) != null && candidates.contains(headers.get(i).trim().toLowerCase())) {
        return i;
      }
    }
    return -1;
  }
}
