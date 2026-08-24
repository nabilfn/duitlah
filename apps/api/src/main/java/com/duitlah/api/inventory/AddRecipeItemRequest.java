package com.duitlah.api.inventory;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.UUID;

public record AddRecipeItemRequest(
    @NotNull UUID ingredientProductId,
    @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal quantityPerUnit) {}
