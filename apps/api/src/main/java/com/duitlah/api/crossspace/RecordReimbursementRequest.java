package com.duitlah.api.crossspace;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code personalTransactionId} is the Personal "+amount, Reimbursement" inflow — never classified
 * as income (spec section 58). {@code relatedLinkId} optionally points back at the original {@link
 * CrossSpaceLinkType#BUSINESS_ADVANCE} this settles, for traceability.
 */
public record RecordReimbursementRequest(
    @NotNull UUID personalTransactionId,
    @NotNull UUID businessAccountId,
    UUID relatedLinkId,
    @NotNull @Positive BigDecimal amount,
    @NotNull LocalDate occurredOn,
    String description) {}
