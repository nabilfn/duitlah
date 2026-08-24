package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record GeneralLedgerLineResponse(
    LocalDate entryDate,
    UUID journalEntryId,
    String description,
    JournalDirection direction,
    BigDecimal amount,
    BigDecimal runningBalance) {}
