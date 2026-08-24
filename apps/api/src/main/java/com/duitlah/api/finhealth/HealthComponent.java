package com.duitlah.api.finhealth;

import java.math.BigDecimal;

public record HealthComponent(
    String key, String label, BigDecimal score, BigDecimal weight, String explanation) {}
