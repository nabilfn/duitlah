package com.duitlah.api.groups;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * {@code paidByUserId} defaults to the requester if omitted. {@code participantUserIds} defaults to
 * every current group member if omitted or empty — pass a subset when someone wasn't involved.
 * {@code category} is optional and available on every group type (see
 * V11__special_group_modes.sql). {@code originalCurrency}/{@code originalAmount}/{@code
 * exchangeRate} are an optional Trip-mode display snapshot only -- {@code amount} is always the
 * real MYR figure the backend uses for every computation; either all three snapshot fields are
 * present or none are.
 */
public record CreateGroupExpenseRequest(
    @NotBlank @Size(max = 255) String description,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @NotNull LocalDate occurredOn,
    UUID paidByUserId,
    List<UUID> participantUserIds,
    GroupExpenseCategory category,
    @Size(min = 3, max = 3) String originalCurrency,
    @DecimalMin(value = "0.01") BigDecimal originalAmount,
    @DecimalMin(value = "0.000001") BigDecimal exchangeRate) {}
