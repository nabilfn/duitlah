package com.duitlah.api.receipts;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "duitlah.receipts.ocr")
public record OcrProperties(String anthropicApiKey, String model) {

  public boolean isConfigured() {
    return anthropicApiKey != null && !anthropicApiKey.isBlank();
  }
}
