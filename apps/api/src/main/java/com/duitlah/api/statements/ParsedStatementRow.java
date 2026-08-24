package com.duitlah.api.statements;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * One normalized row out of a parser. {@code amount} is signed (positive = money in, negative =
 * money out) since that's how every source format actually expresses it (a single amount column, or
 * a debit/credit pair collapsed to one signed number) — {@link StatementImportService} converts
 * this into a magnitude + direction pair when creating the candidate, matching how {@code
 * transactions} itself always stores an unsigned amount plus a direction.
 */
public record ParsedStatementRow(
    LocalDate date, String description, BigDecimal amount, double confidence) {}
