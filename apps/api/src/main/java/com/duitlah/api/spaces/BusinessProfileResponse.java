package com.duitlah.api.spaces;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record BusinessProfileResponse(
    UUID spaceId,
    String legalName,
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
    BigDecimal annualRevenue) {

  static BusinessProfileResponse of(BusinessProfile profile) {
    return new BusinessProfileResponse(
        profile.getSpaceId(),
        profile.getLegalName(),
        profile.getTradeName(),
        profile.getRegistrationNumber(),
        profile.getTin(),
        profile.getBusinessType(),
        profile.getIndustry(),
        profile.getSstNumber(),
        profile.getFinancialYearStart(),
        profile.getFinancialYearEnd(),
        profile.getAddress(),
        profile.getPhone(),
        profile.getEmail(),
        profile.getCurrency(),
        profile.getAnnualRevenue());
  }
}
