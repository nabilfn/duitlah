package com.duitlah.api.reconciliation;

import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record MatchLineRequest(@NotNull UUID businessAccountEntryId) {}
