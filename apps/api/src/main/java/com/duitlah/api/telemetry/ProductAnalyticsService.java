package com.duitlah.api.telemetry;

import java.util.Map;
import java.util.UUID;

/**
 * Abstraction over "somewhere a real product event gets recorded" -- named distinctly from {@code
 * com.duitlah.api.analytics} (that package is the user-facing personal-finance dashboard feature;
 * this is engineering/product observability, an unrelated meaning of "analytics"). The only
 * implementation active without configuration is {@link LoggingProductAnalyticsService}.
 */
public interface ProductAnalyticsService {

  void track(UUID userId, String event, Map<String, Object> properties);
}
