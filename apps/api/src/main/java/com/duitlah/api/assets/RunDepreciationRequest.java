package com.duitlah.api.assets;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

/**
 * {@code period} may be any date within the target month — the service normalizes it to the first
 * of that month before checking/posting.
 */
public record RunDepreciationRequest(@NotNull LocalDate period) {}
