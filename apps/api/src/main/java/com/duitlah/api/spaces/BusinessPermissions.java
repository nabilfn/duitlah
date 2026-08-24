package com.duitlah.api.spaces;

import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Map;
import java.util.Set;

/**
 * The role-&gt;permission matrix, following the spec's own worked examples (section 33) literally:
 * ADMIN gets "most operational modules" but not {@link BusinessPermission#MANAGE_TEAM} (that stays
 * OWNER-only); FINANCE gets banking/payments/reports/books ("Banking, accounting, reports");
 * ACCOUNTANT gets books/reports ("Books, tax, reconciliation, reports" — tax/reconciliation
 * permissions arrive with later phases' own modules); SALES gets customers/products/sales
 * documents; STAFF can only record expenses; VIEWER gets nothing here — read access for every role
 * (including VIEWER) is just "is an active member," checked separately by {@link
 * SpaceService#requireMembership}.
 */
final class BusinessPermissions {

  private static final Map<SpaceRole, Set<BusinessPermission>> MATRIX =
      new EnumMap<>(SpaceRole.class);

  static {
    MATRIX.put(SpaceRole.OWNER, EnumSet.allOf(BusinessPermission.class));
    MATRIX.put(SpaceRole.ADMIN, EnumSet.complementOf(EnumSet.of(BusinessPermission.MANAGE_TEAM)));
    MATRIX.put(
        SpaceRole.FINANCE,
        EnumSet.of(
            BusinessPermission.MANAGE_SUPPLIERS,
            BusinessPermission.RECORD_EXPENSES,
            BusinessPermission.RECORD_PAYMENTS,
            BusinessPermission.MANAGE_BANKING,
            BusinessPermission.VIEW_REPORTS,
            BusinessPermission.MANAGE_BOOKS));
    MATRIX.put(
        SpaceRole.ACCOUNTANT,
        EnumSet.of(BusinessPermission.VIEW_REPORTS, BusinessPermission.MANAGE_BOOKS));
    MATRIX.put(
        SpaceRole.SALES,
        EnumSet.of(
            BusinessPermission.MANAGE_CUSTOMERS,
            BusinessPermission.MANAGE_PRODUCTS,
            BusinessPermission.MANAGE_SALES_DOCUMENTS));
    MATRIX.put(SpaceRole.STAFF, EnumSet.of(BusinessPermission.RECORD_EXPENSES));
    MATRIX.put(SpaceRole.VIEWER, EnumSet.noneOf(BusinessPermission.class));
  }

  private BusinessPermissions() {}

  static boolean allows(SpaceRole role, BusinessPermission permission) {
    return MATRIX.getOrDefault(role, Set.of()).contains(permission);
  }
}
