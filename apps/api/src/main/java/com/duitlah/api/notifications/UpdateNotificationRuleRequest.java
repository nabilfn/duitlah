package com.duitlah.api.notifications;

import java.math.BigDecimal;

public record UpdateNotificationRuleRequest(boolean enabled, BigDecimal thresholdAmount) {}
