package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public record GroupExpenseResponse(
    UUID id,
    String description,
    BigDecimal amount,
    LocalDate occurredOn,
    UUID paidByUserId,
    String paidByName,
    List<GroupExpenseShareResponse> shares,
    GroupExpenseCategory category,
    String originalCurrency,
    BigDecimal originalAmount,
    BigDecimal exchangeRate) {}
