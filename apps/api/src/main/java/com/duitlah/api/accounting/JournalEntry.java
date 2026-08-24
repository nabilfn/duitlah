package com.duitlah.api.accounting;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Append-only — see package-info. Never updated or deleted once posted. */
@Entity
@Table(name = "journal_entries")
@Getter
@Setter
@NoArgsConstructor
public class JournalEntry {

  @Id @GeneratedValue private UUID id;

  @Column(name = "space_id", nullable = false)
  private UUID spaceId;

  @Column(name = "entry_date", nullable = false)
  private LocalDate entryDate;

  private String description;

  @Enumerated(EnumType.STRING)
  @Column(name = "source_type", nullable = false)
  private JournalSourceType sourceType;

  @Column(name = "source_id")
  private UUID sourceId;

  @Column(name = "created_by_user_id", nullable = false)
  private UUID createdByUserId;

  @Column(name = "created_at", nullable = false)
  private Instant createdAt;

  public JournalEntry(
      UUID spaceId,
      LocalDate entryDate,
      String description,
      JournalSourceType sourceType,
      UUID sourceId,
      UUID createdByUserId) {
    this.spaceId = spaceId;
    this.entryDate = entryDate;
    this.description = description;
    this.sourceType = sourceType;
    this.sourceId = sourceId;
    this.createdByUserId = createdByUserId;
    this.createdAt = Instant.now();
  }
}
