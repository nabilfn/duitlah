package com.duitlah.api.sales;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.UUID;

/** Shared input shape for a quotation or invoice line item. */
public record LineItemRequest(
    UUID productId,
    @NotBlank String description,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal quantity,
    @NotNull @DecimalMin(value = "0", inclusive = true) BigDecimal unitPrice) {}
