package com.duitlah.api.spaces;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

public record UpdateBusinessProfileRequest(
    @NotBlank @Size(max = 180) String legalName,
    String tradeName,
    String registrationNumber,
    String tin,
    String businessType,
    String industry,
    String sstNumber,
    LocalDate financialYearStart,
    LocalDate financialYearEnd,
    String address,
    String phone,
    String email,
    String currency,
    @DecimalMin(value = "0", inclusive = true) BigDecimal annualRevenue) {}
