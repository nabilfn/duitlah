package com.duitlah.api.exports;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;

@Component
public class XlsxExportWriter {

  public byte[] write(TabularData data) {
    try (XSSFWorkbook workbook = new XSSFWorkbook();
        ByteArrayOutputStream out = new ByteArrayOutputStream()) {
      Sheet sheet = workbook.createSheet(data.title());

      Row headerRow = sheet.createRow(0);
      for (int col = 0; col < data.headers().size(); col++) {
        headerRow.createCell(col).setCellValue(data.headers().get(col));
      }

      int rowIndex = 1;
      for (var rowValues : data.rows()) {
        Row row = sheet.createRow(rowIndex++);
        for (int col = 0; col < rowValues.size(); col++) {
          row.createCell(col).setCellValue(rowValues.get(col));
        }
      }

      workbook.write(out);
      return out.toByteArray();
    } catch (IOException e) {
      throw new IllegalStateException("Failed to write XLSX export", e);
    }
  }
}
