package com.duitlah.api.crossspace;

import java.math.BigDecimal;
import java.util.List;

/**
 * Section 61: "Combined Personal View" — purely informational; never merges the underlying
 * Personal/Business bookkeeping.
 */
public record CombinedNetWorthResponse(
    BigDecimal personalNetWorth,
    List<BusinessOwnershipLine> businessOwnership,
    BigDecimal totalBusinessOwnershipValue,
    BigDecimal estimatedTotalNetWorth) {}
