package com.duitlah.api.transactions;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * {@code originalCurrency}/{@code originalAmount}/{@code exchangeRate} are all optional and only
 * ever a display snapshot (spec section 22) — {@code amount} is always the real base-currency
 * figure the account/transaction ledger uses; leave the three multi-currency fields unset for an
 * ordinary same-currency transaction, exactly as every transaction was created before this phase.
 */
public record CreateTransactionRequest(
    @NotNull UUID accountId,
    @NotNull TransactionType type,
    UUID categoryId,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @Size(max = 120) String merchant,
    @Size(max = 255) String description,
    String notes,
    @NotNull LocalDate occurredOn,
    @Pattern(regexp = "[A-Z]{3}") String originalCurrency,
    @DecimalMin(value = "0.01") BigDecimal originalAmount,
    @DecimalMin(value = "0.000001") BigDecimal exchangeRate) {}
