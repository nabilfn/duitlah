package com.duitlah.api.subscriptions;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record VerifyPurchaseRequest(
    @NotNull SubscriptionSource source, @NotBlank String receiptData) {}
