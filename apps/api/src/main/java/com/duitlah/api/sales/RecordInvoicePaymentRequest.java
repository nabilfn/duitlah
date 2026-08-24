package com.duitlah.api.sales;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record RecordInvoicePaymentRequest(
    @NotNull UUID businessAccountId,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal amount,
    @NotNull LocalDate paidOn,
    String notes) {}
