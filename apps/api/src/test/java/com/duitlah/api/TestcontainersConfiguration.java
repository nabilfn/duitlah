package com.duitlah.api;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Bean;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.utility.DockerImageName;

@TestConfiguration(proxyBeanMethods = false)
public class TestcontainersConfiguration {

  @Bean
  @ServiceConnection
  PostgreSQLContainer<?> postgresContainer() {
    return new PostgreSQLContainer<>(DockerImageName.parse("postgres:16-alpine"));
  }

  // No dedicated Testcontainers module for Redis (license changes removed
  // the official one) — a plain GenericContainer with @ServiceConnection("redis")
  // is Spring Boot's documented way to get the same auto-wiring.
  @Bean
  @ServiceConnection("redis")
  GenericContainer<?> redisContainer() {
    return new GenericContainer<>(DockerImageName.parse("redis:7-alpine")).withExposedPorts(6379);
  }

  // MinIO/S3 has no @ServiceConnection support and, unlike Postgres/Redis, isn't needed by every
  // test class — S3ObjectStorage tolerates being unreachable at startup (see its Javadoc), so
  // only ReceiptScanFlowTests wires a real MinIO container (via its own @DynamicPropertySource,
  // which — unlike this shared @TestConfiguration — Spring Test actually honors, since dynamic
  // properties are only discovered on the test class itself, not on @Import-ed configuration).
}
