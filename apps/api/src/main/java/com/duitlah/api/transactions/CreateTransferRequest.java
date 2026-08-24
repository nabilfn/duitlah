package com.duitlah.api.transactions;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateTransferRequest(
    @NotNull UUID fromAccountId,
    @NotNull UUID toAccountId,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @Size(max = 255) String description,
    String notes,
    @NotNull LocalDate occurredOn) {}
