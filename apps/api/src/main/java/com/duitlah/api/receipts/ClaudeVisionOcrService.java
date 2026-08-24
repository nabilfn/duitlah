package com.duitlah.api.receipts;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Real OCR provider: sends the receipt photo to Claude's vision API and forces a structured
 * response via tool use (a JSON-schema-constrained tool call) rather than asking for JSON in prose
 * and hoping it parses — tool input is guaranteed to match the schema, so there's no
 * markdown-fence-stripping or "the model added a sentence before the JSON" fragility to guard
 * against.
 *
 * <p>The response is still walked defensively field-by-field (not deserialized straight into {@link
 * ParsedReceipt} in one shot): a single malformed field (an unparseable date, a missing price)
 * should degrade that one field to null/zero, not fail the entire scan. "Never trust OCR
 * completely" (product spec section 10) applies as much to the shape of the response as to its
 * accuracy.
 */
public class ClaudeVisionOcrService implements ReceiptOcrService {

  private static final Logger log = LoggerFactory.getLogger(ClaudeVisionOcrService.class);
  private static final URI ANTHROPIC_MESSAGES_URI =
      URI.create("https://api.anthropic.com/v1/messages");
  private static final String ANTHROPIC_VERSION = "2023-06-01";
  private static final String TOOL_NAME = "record_receipt";

  private final String apiKey;
  private final String model;
  private final HttpClient httpClient;
  private final ObjectMapper objectMapper = new ObjectMapper();

  public ClaudeVisionOcrService(String apiKey, String model) {
    this.apiKey = apiKey;
    this.model = model;
    this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(15)).build();
  }

  @Override
  public ParsedReceipt parse(byte[] imageBytes, String contentType) {
    try {
      String requestBody = buildRequestBody(imageBytes, contentType);
      HttpRequest request =
          HttpRequest.newBuilder(ANTHROPIC_MESSAGES_URI)
              .header("x-api-key", apiKey)
              .header("anthropic-version", ANTHROPIC_VERSION)
              .header("content-type", "application/json")
              .timeout(Duration.ofSeconds(60))
              .POST(HttpRequest.BodyPublishers.ofString(requestBody))
              .build();

      HttpResponse<String> response =
          httpClient.send(request, HttpResponse.BodyHandlers.ofString());
      if (response.statusCode() != 200) {
        log.warn(
            "Anthropic API returned status {} for a receipt scan: {}",
            response.statusCode(),
            response.body());
        return ParsedReceipt.unavailable();
      }

      JsonNode toolInput = extractToolInput(objectMapper.readTree(response.body()));
      if (toolInput == null) {
        log.warn(
            "Anthropic response had no {} tool_use block; treating scan as unreadable.", TOOL_NAME);
        return ParsedReceipt.unavailable();
      }
      return ParsedReceiptCodec.fromJsonNode(toolInput);
    } catch (IOException | InterruptedException e) {
      if (e instanceof InterruptedException) {
        Thread.currentThread().interrupt();
      }
      log.warn("Receipt OCR call failed; falling back to a blank parse.", e);
      return ParsedReceipt.unavailable();
    }
  }

  private String buildRequestBody(byte[] imageBytes, String contentType) throws IOException {
    ObjectNode root = objectMapper.createObjectNode();
    root.put("model", model);
    root.put("max_tokens", 2048);

    ArrayNode messages = root.putArray("messages");
    ObjectNode userMessage = messages.addObject();
    userMessage.put("role", "user");
    ArrayNode content = userMessage.putArray("content");

    ObjectNode imageBlock = content.addObject();
    imageBlock.put("type", "image");
    ObjectNode imageSource = imageBlock.putObject("source");
    imageSource.put("type", "base64");
    imageSource.put("media_type", contentType);
    imageSource.put("data", Base64.getEncoder().encodeToString(imageBytes));

    ObjectNode textBlock = content.addObject();
    textBlock.put("type", "text");
    textBlock.put(
        "text",
        "This is a photo of a retail receipt. Extract it into structured data using the "
            + TOOL_NAME
            + " tool. For every field, include your own confidence (0.0 to 1.0) that you read it "
            + "correctly -- low confidence for anything blurry, cut off, or ambiguous. If a field "
            + "genuinely isn't on the receipt or isn't legible, omit it rather than guessing.");

    ArrayNode tools = root.putArray("tools");
    ObjectNode tool = tools.addObject();
    tool.put("name", TOOL_NAME);
    tool.put(
        "description",
        "Records structured data extracted from a photo of a retail receipt, with a per-field "
            + "confidence score.");
    tool.set("input_schema", buildInputSchema());

    ObjectNode toolChoice = root.putObject("tool_choice");
    toolChoice.put("type", "tool");
    toolChoice.put("name", TOOL_NAME);

    return objectMapper.writeValueAsString(root);
  }

  private ObjectNode buildInputSchema() {
    ObjectNode schema = objectMapper.createObjectNode();
    schema.put("type", "object");
    ObjectNode properties = schema.putObject("properties");

    properties.set("merchant", stringProperty());
    properties.set("merchantConfidence", numberProperty());
    properties.set("receiptDate", stringProperty("The receipt's date, as YYYY-MM-DD."));
    properties.set("receiptDateConfidence", numberProperty());

    ObjectNode itemsSchema = properties.putObject("items");
    itemsSchema.put("type", "array");
    ObjectNode itemSchema = itemsSchema.putObject("items");
    itemSchema.put("type", "object");
    ObjectNode itemProperties = itemSchema.putObject("properties");
    itemProperties.set("name", stringProperty());
    itemProperties.set("quantity", numberProperty());
    itemProperties.set("unitPrice", numberProperty());
    itemProperties.set("totalPrice", numberProperty());
    itemProperties.set("confidence", numberProperty());
    itemSchema.putArray("required").add("name").add("quantity").add("unitPrice").add("totalPrice");

    properties.set("tax", numberProperty());
    properties.set("taxConfidence", numberProperty());
    properties.set("serviceCharge", numberProperty());
    properties.set("serviceConfidence", numberProperty());
    properties.set("discount", numberProperty());
    properties.set("discountConfidence", numberProperty());
    properties.set("total", numberProperty());
    properties.set("totalConfidence", numberProperty());
    properties.set("overallConfidence", numberProperty());

    schema.putArray("required").add("items");
    return schema;
  }

  private ObjectNode stringProperty() {
    ObjectNode node = objectMapper.createObjectNode();
    node.put("type", "string");
    return node;
  }

  private ObjectNode stringProperty(String description) {
    ObjectNode node = stringProperty();
    node.put("description", description);
    return node;
  }

  private ObjectNode numberProperty() {
    ObjectNode node = objectMapper.createObjectNode();
    node.put("type", "number");
    return node;
  }

  private JsonNode extractToolInput(JsonNode response) {
    JsonNode content = response.get("content");
    if (content == null || !content.isArray()) {
      return null;
    }
    for (JsonNode block : content) {
      if ("tool_use".equals(textOrNull(block, "type"))
          && TOOL_NAME.equals(textOrNull(block, "name"))) {
        return block.get("input");
      }
    }
    return null;
  }

  private static String textOrNull(JsonNode node, String field) {
    JsonNode value = node.get(field);
    return value == null || value.isNull() ? null : value.asText();
  }
}
