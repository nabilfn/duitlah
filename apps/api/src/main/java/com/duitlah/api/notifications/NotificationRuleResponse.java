package com.duitlah.api.notifications;

import java.math.BigDecimal;

public record NotificationRuleResponse(
    NotificationRuleType type, boolean enabled, BigDecimal thresholdAmount) {}
