package com.duitlah.api.transactions;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * Account and type are immutable after creation — delete and recreate the transaction to change
 * either.
 */
public record UpdateTransactionRequest(
    UUID categoryId,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @Size(max = 120) String merchant,
    @Size(max = 255) String description,
    String notes,
    @NotNull LocalDate occurredOn) {}
