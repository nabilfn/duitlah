package com.duitlah.api.crm;

import com.duitlah.api.common.jpa.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "suppliers")
@Getter
@Setter
@NoArgsConstructor
public class Supplier extends AuditableEntity {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(nullable = false)
  private String name;

  @Column(name = "contact_person")
  private String contactPerson;

  private String phone;
  private String email;

  @Column(name = "billing_address")
  private String billingAddress;

  @Column(name = "registration_number")
  private String registrationNumber;

  private String tin;

  @Column(name = "sst_number")
  private String sstNumber;

  @Column(name = "payment_terms_days", nullable = false)
  private int paymentTermsDays;

  private String notes;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ContactStatus status;

  public Supplier(UUID spaceId, String name) {
    this.spaceId = spaceId;
    this.name = name;
    this.paymentTermsDays = 30;
    this.status = ContactStatus.ACTIVE;
  }
}
