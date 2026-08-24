package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.util.UUID;

public record JournalLineResponse(
    UUID id,
    UUID accountId,
    String accountCode,
    String accountName,
    JournalDirection direction,
    BigDecimal amount,
    String description) {}
