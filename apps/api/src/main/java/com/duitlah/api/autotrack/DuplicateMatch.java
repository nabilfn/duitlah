package com.duitlah.api.autotrack;

import java.math.BigDecimal;
import java.util.UUID;

/** A possible duplicate found for a not-yet-created candidate, with its own confidence. */
public record DuplicateMatch(UUID transactionId, BigDecimal confidence) {}
