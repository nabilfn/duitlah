package com.duitlah.api.spaces;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

/**
 * Only {@code name} and {@code legalName} are required -- every other field may be filled in later
 * from Business Settings (V2 spec section 84: onboarding must allow skipping optional tax/business
 * information).
 */
public record CreateBusinessSpaceRequest(
    @NotBlank @Size(max = 120) String name,
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
    String currency) {}
