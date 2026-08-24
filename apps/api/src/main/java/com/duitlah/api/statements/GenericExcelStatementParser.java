package com.duitlah.api.statements;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Component;

/** Same column-detection heuristic as {@link GenericCsvStatementParser}, over the first sheet. */
@Component
public class GenericExcelStatementParser implements StatementParser {

  @Override
  public StatementProvider provider() {
    return StatementProvider.GENERIC_EXCEL;
  }

  @Override
  public List<ParsedStatementRow> parse(byte[] fileBytes) {
    List<ParsedStatementRow> rows = new ArrayList<>();
    try (Workbook workbook = WorkbookFactory.create(new ByteArrayInputStream(fileBytes))) {
      Sheet sheet = workbook.getSheetAt(0);
      if (sheet.getPhysicalNumberOfRows() == 0) {
        return rows;
      }

      Row headerRow = sheet.getRow(sheet.getFirstRowNum());
      List<String> headers = new ArrayList<>();
      for (Cell cell : headerRow) {
        headers.add(cellText(cell));
      }

      int dateCol =
          StatementParsingSupport.findColumnIndex(headers, StatementParsingSupport.DATE_HEADERS);
      int descCol =
          StatementParsingSupport.findColumnIndex(
              headers, StatementParsingSupport.DESCRIPTION_HEADERS);
      int amountCol =
          StatementParsingSupport.findColumnIndex(headers, StatementParsingSupport.AMOUNT_HEADERS);
      int debitCol =
          StatementParsingSupport.findColumnIndex(headers, StatementParsingSupport.DEBIT_HEADERS);
      int creditCol =
          StatementParsingSupport.findColumnIndex(headers, StatementParsingSupport.CREDIT_HEADERS);

      if (dateCol < 0 || (amountCol < 0 && debitCol < 0 && creditCol < 0)) {
        return rows;
      }

      for (int r = sheet.getFirstRowNum() + 1; r <= sheet.getLastRowNum(); r++) {
        Row row = sheet.getRow(r);
        if (row == null) {
          continue;
        }
        LocalDate date = cellDate(row.getCell(dateCol));
        if (date == null) {
          continue;
        }
        BigDecimal amount =
            amountCol >= 0
                ? cellAmount(row.getCell(amountCol))
                : StatementParsingSupport.signedFromDebitCredit(
                    debitCol >= 0 ? cellText(row.getCell(debitCol)) : null,
                    creditCol >= 0 ? cellText(row.getCell(creditCol)) : null);
        if (amount == null) {
          continue;
        }
        String description = descCol >= 0 ? cellText(row.getCell(descCol)) : null;
        double confidence = description != null && !description.isBlank() ? 0.9 : 0.7;
        rows.add(new ParsedStatementRow(date, description, amount, confidence));
      }
    } catch (IOException e) {
      return rows;
    }
    return rows;
  }

  private static String cellText(Cell cell) {
    if (cell == null) {
      return null;
    }
    return switch (cell.getCellType()) {
      case STRING -> cell.getStringCellValue();
      case NUMERIC -> String.valueOf(cell.getNumericCellValue());
      case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
      default -> null;
    };
  }

  private static LocalDate cellDate(Cell cell) {
    if (cell == null) {
      return null;
    }
    if (cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
      return cell.getLocalDateTimeCellValue().toLocalDate();
    }
    return StatementParsingSupport.parseDate(cellText(cell));
  }

  private static BigDecimal cellAmount(Cell cell) {
    if (cell == null) {
      return null;
    }
    if (cell.getCellType() == CellType.NUMERIC) {
      return BigDecimal.valueOf(cell.getNumericCellValue());
    }
    return StatementParsingSupport.parseAmount(cellText(cell));
  }
}
