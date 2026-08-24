package com.duitlah.api.ai;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Pure metadata for one tool the model may call — name/description/JSON input schema, in the shape
 * Claude's Messages API expects.
 */
public record AiToolDefinition(String name, String description, ObjectNode inputSchema) {}
