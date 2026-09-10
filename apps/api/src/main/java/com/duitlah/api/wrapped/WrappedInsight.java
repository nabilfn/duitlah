package com.duitlah.api.wrapped;

/**
 * One ranked insight (spec sections 18-19) — rendered consistently by type on the mobile side; no
 * insight text is ever generated inside a widget, it's all produced here.
 */
public record WrappedInsight(
    String type, String title, String primaryValue, String secondaryValue, String comparison) {}
