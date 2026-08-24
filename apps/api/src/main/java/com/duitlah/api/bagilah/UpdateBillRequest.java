package com.duitlah.api.bagilah;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

public record UpdateBillRequest(
    @Size(max = 160) String merchant,
    @NotNull LocalDate receiptDate,
    @NotNull @DecimalMin(value = "0.00") BigDecimal tax,
    @NotNull AllocationStrategy taxStrategy,
    @NotNull @DecimalMin(value = "0.00") BigDecimal serviceCharge,
    @NotNull AllocationStrategy serviceStrategy,
    @NotNull @DecimalMin(value = "0.00") BigDecimal discount,
    @Size(max = 120) String discountLabel,
    BigDecimal declaredTotal) {}
