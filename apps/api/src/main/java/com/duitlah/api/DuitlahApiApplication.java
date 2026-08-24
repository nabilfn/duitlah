package com.duitlah.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.boot.security.autoconfigure.UserDetailsServiceAutoConfiguration;

// UserDetailsService auto-config is excluded because auth is fully custom
// (JWT + refresh-token sessions, see the auth package) — without this,
// Spring Boot stands up an unused in-memory user and logs a generated
// password on every boot.
@SpringBootApplication(exclude = UserDetailsServiceAutoConfiguration.class)
@ConfigurationPropertiesScan
public class DuitlahApiApplication {

  public static void main(String[] args) {
    SpringApplication.run(DuitlahApiApplication.class, args);
  }
}
