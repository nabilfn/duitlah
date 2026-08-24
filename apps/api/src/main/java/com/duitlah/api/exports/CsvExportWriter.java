package com.duitlah.api.exports;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.springframework.stereotype.Component;

@Component
public class CsvExportWriter {

  public byte[] write(TabularData data) {
    ByteArrayOutputStream out = new ByteArrayOutputStream();
    try (CSVPrinter printer =
        new CSVPrinter(
            new OutputStreamWriter(out, StandardCharsets.UTF_8),
            CSVFormat.DEFAULT.builder().setHeader(data.headers().toArray(new String[0])).build())) {
      for (var row : data.rows()) {
        printer.printRecord(row);
      }
    } catch (IOException e) {
      throw new IllegalStateException("Failed to write CSV export", e);
    }
    return out.toByteArray();
  }
}
