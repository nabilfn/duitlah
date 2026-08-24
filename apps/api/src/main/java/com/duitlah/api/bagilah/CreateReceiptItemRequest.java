package com.duitlah.api.bagilah;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public record CreateReceiptItemRequest(
    @NotBlank @Size(max = 160) String name,
    @NotNull @DecimalMin(value = "0.01") BigDecimal quantity,
    @NotNull @DecimalMin(value = "0.00") BigDecimal unitPrice,
    @DecimalMin(value = "0.00") BigDecimal itemDiscount) {}
