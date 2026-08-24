package com.duitlah.api.accounting;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import java.util.List;

public record CreateJournalEntryRequest(
    @NotNull LocalDate entryDate,
    String description,
    @Valid @Size(min = 2) List<JournalLineRequest> lines) {}
