package com.duitlah.api.sales;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateCreditNoteRequest(
    @NotNull UUID customerId,
    UUID invoiceId,
    @NotNull LocalDate issueDate,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal amount,
    String reason) {}
