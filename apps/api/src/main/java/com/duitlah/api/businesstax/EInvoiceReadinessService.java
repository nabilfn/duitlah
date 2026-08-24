package com.duitlah.api.businesstax;

import com.duitlah.api.spaces.BusinessProfile;
import com.duitlah.api.spaces.SpaceService;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Spec section 57 — "Business onboarding should collect the information required to evaluate
 * readiness." Almost every field it names already exists on {@code spaces.BusinessProfile}; this
 * service only adds the mandate-threshold computation on top.
 */
@Service
public class EInvoiceReadinessService {

  private final SpaceService spaceService;
  private final EInvoiceMandateRuleRepository mandateRules;

  public EInvoiceReadinessService(
      SpaceService spaceService, EInvoiceMandateRuleRepository mandateRules) {
    this.spaceService = spaceService;
    this.mandateRules = mandateRules;
  }

  public EInvoiceReadinessResponse evaluate(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    BusinessProfile profile = spaceService.requireBusinessProfile(spaceId);

    var currentRule = mandateRules.findCurrentRule(java.time.LocalDate.now());
    boolean mandated =
        profile.getAnnualRevenue() != null
            && currentRule.isPresent()
            && profile.getAnnualRevenue().compareTo(currentRule.get().getRevenueThreshold()) >= 0;

    List<String> missingFields = new ArrayList<>();
    if (isBlank(profile.getRegistrationNumber())) {
      missingFields.add("registrationNumber");
    }
    if (isBlank(profile.getTin())) {
      missingFields.add("tin");
    }
    if (isBlank(profile.getBusinessType())) {
      missingFields.add("businessType");
    }
    if (profile.getAnnualRevenue() == null) {
      missingFields.add("annualRevenue");
    }
    if (isBlank(profile.getIndustry())) {
      missingFields.add("industry");
    }
    if (profile.getFinancialYearStart() == null || profile.getFinancialYearEnd() == null) {
      missingFields.add("financialYear");
    }

    return new EInvoiceReadinessResponse(
        mandated,
        currentRule.map(EInvoiceMandateRule::getEffectiveDate).orElse(null),
        currentRule.map(EInvoiceMandateRule::getRevenueThreshold).orElse(null),
        missingFields,
        missingFields.isEmpty());
  }

  private boolean isBlank(String value) {
    return value == null || value.isBlank();
  }
}
