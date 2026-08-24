package com.duitlah.api.receipts;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OcrConfig {

  @Bean
  public ReceiptOcrService receiptOcrService(OcrProperties properties) {
    if (properties.isConfigured()) {
      return new ClaudeVisionOcrService(properties.anthropicApiKey(), properties.model());
    }
    return new UnavailableOcrService();
  }
}
