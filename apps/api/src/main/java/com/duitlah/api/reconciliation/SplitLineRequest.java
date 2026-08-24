package com.duitlah.api.reconciliation;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.List;

public record SplitLineRequest(@Valid @Size(min = 2) List<Portion> portions) {

  public record Portion(
      @NotBlank String description,
      @NotNull @DecimalMin(value = "0", inclusive = false) BigDecimal amount) {}
}
