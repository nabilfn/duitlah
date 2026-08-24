package com.duitlah.api.bizbanking;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record UpdateBusinessAccountRequest(
    @NotBlank String name,
    @NotNull BusinessAccountType type,
    BigDecimal openingBalance,
    boolean archived) {}
