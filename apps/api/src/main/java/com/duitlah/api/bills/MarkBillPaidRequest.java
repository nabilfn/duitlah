package com.duitlah.api.bills;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/** Creates the real expense transaction a paid bill links to. */
public record MarkBillPaidRequest(
    @NotNull UUID accountId,
    UUID categoryId,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @NotNull LocalDate paidOn) {}
