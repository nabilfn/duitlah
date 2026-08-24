package com.duitlah.api.groups;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * {@code net = totalPaid - totalShare}: positive means the group owes this member, negative means
 * they owe the group.
 */
public record GroupBalanceResponse(
    UUID userId, String displayName, BigDecimal totalPaid, BigDecimal totalShare, BigDecimal net) {}
