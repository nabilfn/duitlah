package com.duitlah.api.accounting;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record JournalEntryResponse(
    UUID id,
    LocalDate entryDate,
    String description,
    JournalSourceType sourceType,
    UUID sourceId,
    List<JournalLineResponse> lines) {}
