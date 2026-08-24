package com.duitlah.api.reconciliation;

import java.math.BigDecimal;

/**
 * {@code statementEndingBalance} may be supplied here if it wasn't set when the session started (or
 * to correct it); null leaves the session's existing value untouched.
 */
public record ResolveDifferenceRequest(BigDecimal statementEndingBalance, String description) {}
