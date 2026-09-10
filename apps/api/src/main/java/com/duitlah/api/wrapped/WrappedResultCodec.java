package com.duitlah.api.wrapped;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

/**
 * {@link WrappedResult} to/from {@code monthly_wrapped.payload} (a TEXT column — same "hand the
 * whole computed artifact to a JSON blob" precedent as {@code receipts.parsed_result_json}). Unlike
 * that precedent, a plain whole-object round trip is safe here rather than needing a field-by-field
 * defensive codec: this is Wrapped's own internal, always-well-formed computed data, never a raw
 * external API response that might be malformed. {@link JavaTimeModule} is registered explicitly
 * since this codec's {@link ObjectMapper} is a fresh instance, not Spring's autoconfigured bean.
 */
final class WrappedResultCodec {

  private static final ObjectMapper MAPPER =
      new ObjectMapper()
          .registerModule(new JavaTimeModule())
          .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

  private WrappedResultCodec() {}

  static String toJson(WrappedResult result) {
    try {
      return MAPPER.writeValueAsString(result);
    } catch (Exception e) {
      throw new IllegalStateException("Failed to serialize WrappedResult", e);
    }
  }

  static WrappedResult fromJson(String json) {
    try {
      return MAPPER.readValue(json, WrappedResult.class);
    } catch (Exception e) {
      throw new IllegalStateException("Failed to deserialize WrappedResult", e);
    }
  }
}
