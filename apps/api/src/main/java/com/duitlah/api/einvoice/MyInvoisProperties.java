package com.duitlah.api.einvoice;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * {@code baseUrl}/{@code identityUrl} default to the real, documented LHDN preprod/sandbox hosts
 * (sdk.myinvois.hasil.gov.my) so a space only needs to supply real {@code clientId}/{@code
 * clientSecret} to go live against the sandbox; point both at the production hosts to go live for
 * real. See package-info.
 */
@ConfigurationProperties(prefix = "duitlah.myinvois")
public record MyInvoisProperties(
    boolean enabled,
    String clientId,
    String clientSecret,
    String baseUrl,
    String identityUrl,
    String scope) {

  private static final String DEFAULT_BASE_URL = "https://preprod-api.myinvois.hasil.gov.my";
  private static final String DEFAULT_IDENTITY_URL =
      "https://preprod-identity.myinvois.hasil.gov.my";
  private static final String DEFAULT_SCOPE = "InvoicingAPI";

  public String baseUrlOrDefault() {
    return baseUrl != null && !baseUrl.isBlank() ? baseUrl : DEFAULT_BASE_URL;
  }

  public String identityUrlOrDefault() {
    return identityUrl != null && !identityUrl.isBlank() ? identityUrl : DEFAULT_IDENTITY_URL;
  }

  public String scopeOrDefault() {
    return scope != null && !scope.isBlank() ? scope : DEFAULT_SCOPE;
  }

  public boolean isConfigured() {
    return enabled
        && clientId != null
        && !clientId.isBlank()
        && clientSecret != null
        && !clientSecret.isBlank();
  }
}
