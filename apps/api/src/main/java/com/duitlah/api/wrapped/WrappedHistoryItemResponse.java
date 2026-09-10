package com.duitlah.api.wrapped;

/**
 * One row of Analytics -> Monthly Stories (spec section 28) — light enough to list many months
 * without deserializing every payload.
 */
public record WrappedHistoryItemResponse(
    int year, int month, String personaId, String personaName, boolean viewed) {}
