package com.duitlah.api.statements;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Component;

/**
 * Best-effort, line-based extraction — a PDF bank statement has no real column structure once text
 * is pulled out of it, unlike CSV/XLSX. Each line is scanned for a leading date and a trailing
 * amount; whatever sits between them becomes the description. This is deliberately lower confidence
 * than the structured parsers (spec section 13's own "when unsupported, provide a review experience
 * instead of failing completely" — every row still goes through AutoTrack's normal
 * human-confirmation step, so a wrong guess here is corrected there, never acted on silently).
 */
@Component
public class PdfStatementParser implements StatementParser {

  private static final Pattern LEADING_DATE =
      Pattern.compile("^\\s*(\\d{1,2}[/-]\\d{1,2}[/-]\\d{2,4}|\\d{4}-\\d{1,2}-\\d{1,2})\\s+(.*)$");
  private static final Pattern TRAILING_AMOUNT =
      Pattern.compile("^(.*?)\\s+\\(?-?\\s*(?:RM)?\\s*([\\d,]+\\.\\d{2})\\)?\\s*$");

  @Override
  public StatementProvider provider() {
    return StatementProvider.PDF;
  }

  @Override
  public List<ParsedStatementRow> parse(byte[] fileBytes) {
    List<ParsedStatementRow> rows = new ArrayList<>();
    try (PDDocument document = Loader.loadPDF(fileBytes)) {
      String text = new PDFTextStripper().getText(document);
      for (String line : text.split("\\R")) {
        parseLine(line).ifPresent(rows::add);
      }
    } catch (IOException e) {
      return rows;
    }
    return rows;
  }

  private static java.util.Optional<ParsedStatementRow> parseLine(String line) {
    Matcher dateMatcher = LEADING_DATE.matcher(line);
    if (!dateMatcher.matches()) {
      return java.util.Optional.empty();
    }
    LocalDate date = StatementParsingSupport.parseDate(dateMatcher.group(1));
    if (date == null) {
      return java.util.Optional.empty();
    }
    String rest = dateMatcher.group(2);

    Matcher amountMatcher = TRAILING_AMOUNT.matcher(rest);
    if (!amountMatcher.matches()) {
      return java.util.Optional.empty();
    }
    String description = amountMatcher.group(1).trim();
    boolean negative = rest.trim().contains("(") || rest.trim().startsWith("-");
    BigDecimal magnitude = StatementParsingSupport.parseAmount(amountMatcher.group(2));
    if (magnitude == null) {
      return java.util.Optional.empty();
    }
    BigDecimal amount = negative ? magnitude.negate() : magnitude;

    return java.util.Optional.of(new ParsedStatementRow(date, description, amount, 0.6));
  }
}
