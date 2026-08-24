package com.duitlah.api.assets;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateFixedAssetRequest(
    @NotBlank String name,
    String category,
    @NotNull LocalDate acquisitionDate,
    @NotNull @Positive BigDecimal cost,
    @DecimalMin(value = "0", inclusive = true) BigDecimal salvageValue,
    @NotNull @Min(1) Integer usefulLifeMonths,
    @NotNull DepreciationMethod depreciationMethod,
    UUID businessAccountId) {

  public BigDecimal salvageValueOrZero() {
    return salvageValue != null ? salvageValue : BigDecimal.ZERO;
  }
}
