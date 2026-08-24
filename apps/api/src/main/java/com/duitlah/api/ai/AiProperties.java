package com.duitlah.api.ai;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "duitlah.ai.chat")
public record AiProperties(String anthropicApiKey, String model) {

  public boolean isConfigured() {
    return anthropicApiKey != null && !anthropicApiKey.isBlank();
  }
}
