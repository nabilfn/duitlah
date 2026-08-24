package com.duitlah.api.ai;

import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AiConfig {

  @Bean
  public AiChatService aiChatService(
      AiProperties properties, List<AiToolProvider> toolProviders, SpaceService spaceService) {
    if (properties.isConfigured()) {
      return new ClaudeAiChatService(
          properties.anthropicApiKey(), properties.model(), toolProviders, spaceService);
    }
    return new UnavailableAiChatService();
  }
}
