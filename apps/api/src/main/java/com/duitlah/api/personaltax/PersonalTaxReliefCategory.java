package com.duitlah.api.personaltax;

/**
 * A representative, not exhaustive, set of real LHDN individual relief categories — the self relief
 * every resident taxpayer gets automatically lives on {@link TaxYear#getResidentIndividualRelief()}
 * directly, not as a category here, since it's never something a user "claims."
 */
public enum PersonalTaxReliefCategory {
  SPOUSE,
  CHILD,
  DISABLED_INDIVIDUAL,
  PARENTS_MEDICAL_CARE,
  MEDICAL_SERIOUS_ILLNESS,
  EDUCATION_FEES,
  LIFESTYLE,
  LIFESTYLE_SPORTS,
  EPF_LIFE_INSURANCE,
  PRS,
  SSPN,
  EV_CHARGING,
  OTHER
}
