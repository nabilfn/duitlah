package com.duitlah.api.crossspace;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record CrossSpaceLinkResponse(
    UUID id,
    UUID businessSpaceId,
    CrossSpaceLinkType linkType,
    UUID personalTransactionId,
    UUID businessJournalEntryId,
    UUID relatedLinkId,
    BigDecimal amount,
    String description,
    Instant createdAt) {

  public static CrossSpaceLinkResponse of(CrossSpaceLink link) {
    return new CrossSpaceLinkResponse(
        link.getId(),
        link.getBusinessSpaceId(),
        link.getLinkType(),
        link.getPersonalTransactionId(),
        link.getBusinessJournalEntryId(),
        link.getRelatedLinkId(),
        link.getAmount(),
        link.getDescription(),
        link.getCreatedAt());
  }
}
