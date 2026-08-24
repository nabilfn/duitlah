package com.duitlah.api.receipts;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ReceiptTransactionMatchSuggestion(
    UUID transactionId,
    LocalDate occurredOn,
    String merchant,
    BigDecimal amount,
    ReceiptMatchConfidence confidence) {}
