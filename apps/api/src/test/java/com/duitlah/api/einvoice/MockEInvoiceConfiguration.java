package com.duitlah.api.einvoice;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

/**
 * Same {@code @TestConfiguration} + explicit {@code @Import} idiom as {@code
 * TestcontainersConfiguration} — only test classes that need the full submit-to-VALID happy path
 * import this; every other test keeps exercising the real default {@link
 * UnavailableEInvoiceProvider}.
 */
@TestConfiguration
public class MockEInvoiceConfiguration {

  @Bean
  @Primary
  public MockEInvoiceProvider mockEInvoiceProvider() {
    return new MockEInvoiceProvider();
  }
}
