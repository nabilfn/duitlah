package com.duitlah.api.wrapped;

/**
 * Drives the Home promo card (spec section 4) — cheap to poll on every Home load since it never
 * deserializes a full payload, and never generates one just to answer "is anything ready yet" (only
 * checks an existing row, or the schedule already having produced one).
 */
public record WrappedPromoResponse(
    boolean available, Integer year, Integer month, String personaName) {

  static WrappedPromoResponse none() {
    return new WrappedPromoResponse(false, null, null, null);
  }
}
