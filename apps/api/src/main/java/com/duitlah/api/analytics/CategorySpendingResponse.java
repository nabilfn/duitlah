package com.duitlah.api.analytics;

import java.math.BigDecimal;
import java.util.UUID;

public record CategorySpendingResponse(UUID categoryId, String categoryName, BigDecimal amount) {}
