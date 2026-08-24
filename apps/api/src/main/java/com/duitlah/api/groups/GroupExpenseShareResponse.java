package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.util.UUID;

public record GroupExpenseShareResponse(UUID userId, String displayName, BigDecimal amount) {}
