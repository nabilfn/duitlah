package com.duitlah.api.ai;

import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Small, shared JSON-schema builders every {@link AiToolProvider} uses for its {@link
 * AiToolDefinition#inputSchema()} — kept in one place so every tool's schema shape stays consistent
 * rather than each provider hand-rolling its own.
 */
final class AiSchemas {

  private AiSchemas() {}

  static ObjectNode emptyObject() {
    return JsonNodeFactory.instance.objectNode().put("type", "object");
  }

  static ObjectNode object() {
    return JsonNodeFactory.instance.objectNode().put("type", "object");
  }

  static ObjectNode intProperty(String description) {
    ObjectNode node = JsonNodeFactory.instance.objectNode();
    node.put("type", "integer");
    node.put("description", description);
    return node;
  }

  static ObjectNode stringProperty(String description) {
    ObjectNode node = JsonNodeFactory.instance.objectNode();
    node.put("type", "string");
    node.put("description", description);
    return node;
  }

  static ObjectNode yearMonthSchema() {
    ObjectNode schema = object();
    ObjectNode properties = schema.putObject("properties");
    properties.set("year", intProperty("e.g. 2026"));
    properties.set("month", intProperty("1-12"));
    return schema;
  }

  static AiToolDefinition definition(String name, String description, ObjectNode inputSchema) {
    return new AiToolDefinition(name, description, inputSchema);
  }
}
