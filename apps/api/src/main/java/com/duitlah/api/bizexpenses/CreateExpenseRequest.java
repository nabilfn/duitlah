package com.duitlah.api.bizexpenses;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateExpenseRequest(
    UUID supplierId,
    String category,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal amount,
    @NotNull LocalDate occurredOn,
    UUID receiptId,
    String notes) {}
