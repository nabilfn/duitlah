package com.duitlah.api.common;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class VersionController {

  @GetMapping("/api/v1")
  public Map<String, String> version() {
    return Map.of("service", "duitlah-api", "version", "v1");
  }
}
