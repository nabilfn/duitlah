package com.duitlah.api.networth;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public record CreateOtherAssetRequest(
    @NotNull AssetType type,
    @NotBlank @Size(max = 120) String name,
    @NotNull @DecimalMin(value = "0") BigDecimal estimatedValue,
    String notes) {}
