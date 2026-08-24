package com.duitlah.api.crossspace;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Append-only — see package-info. Records that a Personal transaction produced a real Business
 * journal entry, without merging either ledger.
 */
@Entity
@Table(name = "cross_space_links")
@Getter
@Setter
@NoArgsConstructor
public class CrossSpaceLink {

  @Id @GeneratedValue private UUID id;

  @Column(name = "personal_user_id", nullable = false)
  private UUID personalUserId;

  @Column(name = "business_space_id", nullable = false)
  private UUID businessSpaceId;

  @Enumerated(EnumType.STRING)
  @Column(name = "link_type", nullable = false)
  private CrossSpaceLinkType linkType;

  @Column(name = "personal_transaction_id", nullable = false)
  private UUID personalTransactionId;

  @Column(name = "business_journal_entry_id")
  private UUID businessJournalEntryId;

  @Column(name = "related_link_id")
  private UUID relatedLinkId;

  @Column(nullable = false)
  private BigDecimal amount;

  private String description;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public CrossSpaceLink(
      UUID personalUserId,
      UUID businessSpaceId,
      CrossSpaceLinkType linkType,
      UUID personalTransactionId,
      UUID relatedLinkId,
      BigDecimal amount,
      String description,
      UUID createdByUserId) {
    this.personalUserId = personalUserId;
    this.businessSpaceId = businessSpaceId;
    this.linkType = linkType;
    this.personalTransactionId = personalTransactionId;
    this.relatedLinkId = relatedLinkId;
    this.amount = amount;
    this.description = description;
    this.createdByUserId = createdByUserId;
    this.createdAt = Instant.now();
  }
}
