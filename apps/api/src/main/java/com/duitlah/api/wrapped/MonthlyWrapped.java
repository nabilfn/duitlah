package com.duitlah.api.wrapped;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * One persisted, stable Wrapped result (spec section 22) — generated once for a completed month,
 * never silently regenerated just because the user later edits an old transaction (spec section 22
 * is explicit about this). {@code payload} is the full {@link WrappedResult}, serialized via {@link
 * WrappedResultCodec}; {@code personaId} is denormalized purely so the history list ({@code
 * WrappedController#history}) can render "August - Cafe Hunter" without deserializing the payload
 * for every row.
 */
@Entity
@Table(name = "monthly_wrapped")
@Getter
@Setter
@NoArgsConstructor
public class MonthlyWrapped {

  @Id @GeneratedValue private UUID id;

  @Column(name = "user_id", nullable = false)
  private UUID userId;

  @Column(nullable = false)
  private int year;

  @Column(nullable = false)
  private int month;

  @Column(name = "persona_id")
  private String personaId;

  @Column(name = "sufficient_data", nullable = false)
  private boolean sufficientData;

  @Column(nullable = false, columnDefinition = "TEXT")
  private String payload;

  @Column(name = "wrapped_version", nullable = false)
  private int wrappedVersion;

  @Column(name = "generated_at", nullable = false)
  private Instant generatedAt;

  @Column(name = "viewed_at")
  private Instant viewedAt;

  public MonthlyWrapped(UUID userId, int year, int month, WrappedResult result) {
    this.userId = userId;
    this.year = year;
    this.month = month;
    this.personaId = result.persona() == null ? null : result.persona().id();
    this.sufficientData = result.sufficientData();
    this.payload = WrappedResultCodec.toJson(result);
    this.wrappedVersion = result.version();
    this.generatedAt = result.generatedAt();
  }

  public WrappedResult toResult() {
    return WrappedResultCodec.fromJson(payload);
  }
}
