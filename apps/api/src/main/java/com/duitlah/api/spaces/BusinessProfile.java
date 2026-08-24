package com.duitlah.api.spaces;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One row per BUSINESS {@link FinancialSpace} (never created for PERSONAL spaces). Every field
 * beyond {@code legalName} is optional at creation time -- V2 spec section 84's onboarding
 * explicitly allows "skipping optional tax/business information initially"; {@code businessType}/
 * {@code industry} are plain strings rather than an invented enum, since no official fixed list was
 * specified and forcing one now would risk being wrong later.
 */
@Entity
@Table(name = "business_profiles")
@Getter
@Setter
@NoArgsConstructor
public class BusinessProfile extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false, unique = true)
  private UUID spaceId;

  @Column(name = "legal_name", nullable = false)
  private String legalName;

  @Column(name = "trade_name")
  private String tradeName;

  @Column(name = "registration_number")
  private String registrationNumber;

  private String tin;

  @Column(name = "business_type")
  private String businessType;

  private String industry;

  @Column(name = "sst_number")
  private String sstNumber;

  @Column(name = "financial_year_start")
  private LocalDate financialYearStart;

  @Column(name = "financial_year_end")
  private LocalDate financialYearEnd;

  private String address;
  private String phone;
  private String email;

  @Column(nullable = false)
  private String currency;

  /**
   * V2 Phase 10 -- the one field spec section 57's e-Invoice readiness checklist needs that wasn't
   * already here; drives {@code businesstax.EInvoiceReadinessService}'s mandate-threshold lookup.
   */
  @Column(name = "annual_revenue")
  private BigDecimal annualRevenue;

  public BusinessProfile(UUID spaceId, String legalName) {
    this.spaceId = spaceId;
    this.legalName = legalName;
    this.currency = "MYR";
  }
}
