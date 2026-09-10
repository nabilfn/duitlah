package com.duitlah.api.wrapped;

import java.time.Instant;
import java.util.List;

/**
 * The full computed Wrapped payload for one user's one month — everything the 5 story screens
 * render, and everything persisted to {@code monthly_wrapped.payload} verbatim (spec section 22).
 * {@code persona} is null whenever {@code sufficientData} is false (spec section 15) — never a
 * misleading guess from too little signal.
 */
public record WrappedResult(
    int year,
    int month,
    int version,
    Instant generatedAt,
    boolean sufficientData,
    WrappedOverview overview,
    WrappedPersona persona,
    List<WrappedInsight> insights,
    WrappedGoal recommendedGoal,
    WrappedStoryData story) {

  public static final int CURRENT_VERSION = 2;
}
