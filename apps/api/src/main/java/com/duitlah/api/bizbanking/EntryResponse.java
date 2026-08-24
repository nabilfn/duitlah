package com.duitlah.api.bizbanking;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record EntryResponse(
    UUID id,
    EntryDirection direction,
    BigDecimal amount,
    LocalDate occurredOn,
    String description,
    UUID transferGroupId) {

  static EntryResponse of(BusinessAccountEntry e) {
    return new EntryResponse(
        e.getId(),
        e.getDirection(),
        e.getAmount(),
        e.getOccurredOn(),
        e.getDescription(),
        e.getTransferGroupId());
  }
}
