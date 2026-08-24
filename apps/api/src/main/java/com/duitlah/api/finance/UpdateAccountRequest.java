package com.duitlah.api.finance;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public record UpdateAccountRequest(
    @NotBlank @Size(max = 120) String name,
    @NotNull AccountType type,
    @NotNull BigDecimal openingBalance,
    boolean archived) {}
