package com.duitlah.api.reconciliation;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record MatchSuggestionResponse(
    UUID businessAccountEntryId,
    LocalDate occurredOn,
    String description,
    BigDecimal signedAmount,
    MatchConfidence confidence) {}
