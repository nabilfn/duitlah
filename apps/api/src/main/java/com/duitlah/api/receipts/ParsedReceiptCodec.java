package com.duitlah.api.receipts;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Converts {@link ParsedReceipt} to/from JSON by hand, field by field, rather than trusting generic
 * Jackson record (de)serialization for a type with a {@link LocalDate} field (which needs
 * jackson-datatype-jsr310 registered to round-trip correctly, and this codebase doesn't otherwise
 * depend on that module). This is also the single place that turns whatever a vision API/JSON blob
 * hands back into a {@link ParsedReceipt} defensively -- one bad field degrades to null/zero rather
 * than failing the whole scan (see {@link ClaudeVisionOcrService}, which uses {@link #fromJsonNode}
 * directly on the tool-call input, and {@link ReceiptScanService}, which uses {@link
 * #toJson}/{@link #fromJson} to persist/reload {@code receipt_scans.parsed_result_json}).
 */
public final class ParsedReceiptCodec {

  private static final ObjectMapper MAPPER = new ObjectMapper();

  private ParsedReceiptCodec() {}

  public static String toJson(ParsedReceipt receipt) {
    ObjectNode root = MAPPER.createObjectNode();
    putNullable(root, "merchant", receipt.merchant());
    root.put("merchantConfidence", receipt.merchantConfidence());
    putNullable(
        root,
        "receiptDate",
        receipt.receiptDate() == null ? null : receipt.receiptDate().toString());
    root.put("receiptDateConfidence", receipt.receiptDateConfidence());

    ArrayNode items = root.putArray("items");
    for (ParsedReceiptItem item : receipt.items()) {
      ObjectNode itemNode = items.addObject();
      putNullable(itemNode, "name", item.name());
      itemNode.put("quantity", item.quantity());
      itemNode.put("unitPrice", item.unitPrice());
      itemNode.put("totalPrice", item.totalPrice());
      itemNode.put("confidence", item.confidence());
    }

    putNullable(root, "tax", receipt.tax());
    root.put("taxConfidence", receipt.taxConfidence());
    putNullable(root, "serviceCharge", receipt.serviceCharge());
    root.put("serviceConfidence", receipt.serviceConfidence());
    putNullable(root, "discount", receipt.discount());
    root.put("discountConfidence", receipt.discountConfidence());
    putNullable(root, "total", receipt.total());
    root.put("totalConfidence", receipt.totalConfidence());
    root.put("overallConfidence", receipt.overallConfidence());
    return root.toString();
  }

  public static ParsedReceipt fromJson(String json) {
    try {
      return fromJsonNode(MAPPER.readTree(json));
    } catch (Exception e) {
      return ParsedReceipt.unavailable();
    }
  }

  public static ParsedReceipt fromJsonNode(JsonNode input) {
    List<ParsedReceiptItem> items = new ArrayList<>();
    JsonNode itemsNode = input.get("items");
    if (itemsNode != null && itemsNode.isArray()) {
      for (JsonNode itemNode : itemsNode) {
        BigDecimal quantity = decimalOrNull(itemNode, "quantity");
        BigDecimal unitPrice = decimalOrNull(itemNode, "unitPrice");
        BigDecimal totalPrice = decimalOrNull(itemNode, "totalPrice");
        if (quantity == null || unitPrice == null || totalPrice == null) {
          continue;
        }
        items.add(
            new ParsedReceiptItem(
                textOrNull(itemNode, "name"),
                quantity,
                unitPrice,
                totalPrice,
                doubleOr(itemNode, "confidence", 0.5)));
      }
    }

    return new ParsedReceipt(
        textOrNull(input, "merchant"),
        doubleOr(input, "merchantConfidence", 0),
        dateOrNull(input, "receiptDate"),
        doubleOr(input, "receiptDateConfidence", 0),
        items,
        decimalOrNull(input, "tax"),
        doubleOr(input, "taxConfidence", 0),
        decimalOrNull(input, "serviceCharge"),
        doubleOr(input, "serviceConfidence", 0),
        decimalOrNull(input, "discount"),
        doubleOr(input, "discountConfidence", 0),
        decimalOrNull(input, "total"),
        doubleOr(input, "totalConfidence", 0),
        doubleOr(input, "overallConfidence", 0));
  }

  private static void putNullable(ObjectNode node, String field, String value) {
    if (value == null) {
      node.putNull(field);
    } else {
      node.put(field, value);
    }
  }

  private static void putNullable(ObjectNode node, String field, BigDecimal value) {
    if (value == null) {
      node.putNull(field);
    } else {
      node.put(field, value);
    }
  }

  private static String textOrNull(JsonNode node, String field) {
    JsonNode value = node.get(field);
    return value == null || value.isNull() ? null : value.asText();
  }

  private static double doubleOr(JsonNode node, String field, double fallback) {
    JsonNode value = node.get(field);
    return value == null || !value.isNumber() ? fallback : value.asDouble();
  }

  private static BigDecimal decimalOrNull(JsonNode node, String field) {
    JsonNode value = node.get(field);
    if (value == null || !value.isNumber()) {
      return null;
    }
    try {
      return value.decimalValue().setScale(2, RoundingMode.HALF_UP);
    } catch (ArithmeticException e) {
      return null;
    }
  }

  private static LocalDate dateOrNull(JsonNode node, String field) {
    String text = textOrNull(node, field);
    if (text == null) {
      return null;
    }
    try {
      return LocalDate.parse(text);
    } catch (Exception e) {
      return null;
    }
  }
}
