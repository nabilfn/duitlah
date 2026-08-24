package com.duitlah.api.exports;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.springframework.stereotype.Component;

/**
 * A plain, PDFBox-drawn text table — see package-info for why this doesn't attempt a styled,
 * branded layout. Rows are joined with a fixed column separator rather than measured/aligned
 * columns; correct and readable, not a polished report.
 */
@Component
public class PdfExportWriter {

  private static final float MARGIN = 40f;
  private static final float LINE_HEIGHT = 16f;
  private static final PDType1Font TITLE_FONT =
      new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD);
  private static final PDType1Font BODY_FONT = new PDType1Font(Standard14Fonts.FontName.HELVETICA);

  public byte[] write(TabularData data) {
    try (PDDocument document = new PDDocument();
        ByteArrayOutputStream out = new ByteArrayOutputStream()) {
      PDPage page = new PDPage(PDRectangle.A4);
      document.addPage(page);
      PDPageContentStream stream = new PDPageContentStream(document, page);
      float y = page.getMediaBox().getHeight() - MARGIN;

      y = writeLine(stream, data.title(), TITLE_FONT, 14, MARGIN, y);
      y -= LINE_HEIGHT;
      y = writeLine(stream, String.join("  |  ", data.headers()), TITLE_FONT, 9, MARGIN, y);

      for (List<String> row : data.rows()) {
        if (y < MARGIN) {
          stream.close();
          page = new PDPage(PDRectangle.A4);
          document.addPage(page);
          stream = new PDPageContentStream(document, page);
          y = page.getMediaBox().getHeight() - MARGIN;
        }
        y = writeLine(stream, String.join("  |  ", row), BODY_FONT, 9, MARGIN, y);
      }
      stream.close();

      document.save(out);
      return out.toByteArray();
    } catch (IOException e) {
      throw new IllegalStateException("Failed to write PDF export", e);
    }
  }

  private static float writeLine(
      PDPageContentStream stream, String text, PDType1Font font, float size, float x, float y)
      throws IOException {
    stream.beginText();
    stream.setFont(font, size);
    stream.newLineAtOffset(x, y);
    stream.showText(text.isBlank() ? " " : text);
    stream.endText();
    return y - LINE_HEIGHT;
  }
}
