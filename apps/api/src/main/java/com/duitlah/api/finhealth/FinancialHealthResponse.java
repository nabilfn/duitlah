package com.duitlah.api.finhealth;

import java.math.BigDecimal;
import java.util.List;

/**
 * {@code score} is 0-100 (spec: never a credit score, never implied to be one). {@code components}
 * each carry their own weight/score/explanation so a client can render exactly why the number is
 * what it is, not just the number itself.
 */
public record FinancialHealthResponse(
    BigDecimal score, List<HealthComponent> components, List<String> recommendations) {}
