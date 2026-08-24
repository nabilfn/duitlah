package com.duitlah.api.einvoice;

import com.duitlah.api.common.error.ApiException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;
import java.util.List;
import java.util.Map;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;

/**
 * A real HTTP client against the documented MyInvois SDK endpoints (see package-info and
 * docs/business-tax-and-einvoice.md for the exact sources this was built against —
 * sdk.myinvois.hasil.gov.my's own API reference pages): OAuth2 client-credentials login ({@code
 * POST /connect/token} on the identity host), {@code POST /api/v1.0/documentsubmissions/}, {@code
 * GET /api/v1.0/documents/{uuid}/details}, {@code PUT /api/v1.0/documents/state/{uuid}/state}.
 *
 * <p><b>Scope boundary, stated plainly:</b> LHDN requires every submitted document to carry a
 * digital signature over its canonical content, produced with the business's own LHDN-issued
 * certificate. That certificate-based signing step is not implemented here — {@link #documentHash}
 * computes a real SHA-256 digest of the canonical payload (the {@code documentHash} field the API
 * genuinely expects), but the {@code document} field submitted is the plain base64-encoded,
 * unsigned JSON. A real go-live submission against LHDN would be rejected for a missing signature.
 * Authentication, and every endpoint's request/response shape and error handling below, are real
 * and match the documented API surface — signing (typically {@code java.security.Signature}/{@code
 * KeyStore} over a PKCS#12 certificate a business supplies during their own LHDN onboarding) is the
 * one piece a real go-live still needs to add.
 */
@Service
@ConditionalOnProperty(name = "duitlah.myinvois.enabled", havingValue = "true")
public class MyInvoisProvider implements EInvoiceProvider {

  private final MyInvoisProperties properties;
  private final RestClient identityClient;
  private final RestClient apiClient;
  private final ObjectMapper objectMapper = new ObjectMapper();

  private String cachedToken;
  private Instant tokenExpiresAt = Instant.EPOCH;

  public MyInvoisProvider(MyInvoisProperties properties) {
    this.properties = properties;
    this.identityClient = RestClient.builder().baseUrl(properties.identityUrlOrDefault()).build();
    this.apiClient = RestClient.builder().baseUrl(properties.baseUrlOrDefault()).build();
  }

  @Override
  public String providerName() {
    return "MYINVOIS";
  }

  @Override
  public boolean isAvailable() {
    return properties.isConfigured();
  }

  @Override
  public SubmissionResult submit(EInvoicePayload payload) {
    requireConfigured();
    try {
      String json = objectMapper.writeValueAsString(payload);
      String document = Base64.getEncoder().encodeToString(json.getBytes(StandardCharsets.UTF_8));
      String hash = documentHash(json);

      Map<String, Object> body =
          Map.of(
              "documents",
              List.of(
                  Map.of(
                      "format",
                      "JSON",
                      "document",
                      document,
                      "documentHash",
                      hash,
                      "codeNumber",
                      payload.invoiceNumber())));

      JsonNode response =
          apiClient
              .post()
              .uri("/api/v1.0/documentsubmissions/")
              .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken())
              .contentType(MediaType.APPLICATION_JSON)
              .body(body)
              .retrieve()
              .body(JsonNode.class);

      JsonNode accepted = response != null ? response.path("acceptedDocuments") : null;
      if (accepted != null && accepted.isArray() && !accepted.isEmpty()) {
        JsonNode first = accepted.get(0);
        return new SubmissionResult(
            true,
            response.path("submissionUID").asText(null),
            first.path("uuid").asText(null),
            null);
      }
      JsonNode rejected = response != null ? response.path("rejectedDocuments") : null;
      String error =
          rejected != null && rejected.isArray() && !rejected.isEmpty()
              ? rejected.get(0).path("error").toString()
              : "MyInvois rejected the submission.";
      return new SubmissionResult(false, null, null, error);
    } catch (Exception e) {
      return new SubmissionResult(false, null, null, e.getMessage());
    }
  }

  @Override
  public DocumentStatusResult checkStatus(String documentUuid) {
    requireConfigured();
    JsonNode response =
        apiClient
            .get()
            .uri("/api/v1.0/documents/{uuid}/details", documentUuid)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken())
            .retrieve()
            .body(JsonNode.class);
    String rawStatus = response != null ? response.path("status").asText("") : "";
    EInvoiceStatus status =
        switch (rawStatus.toLowerCase(java.util.Locale.ROOT)) {
          case "valid" -> EInvoiceStatus.VALID;
          case "invalid" -> EInvoiceStatus.INVALID;
          default -> EInvoiceStatus.SUBMITTED;
        };
    String longId = response != null ? response.path("longId").asText(null) : null;
    String invalidReason =
        status == EInvoiceStatus.INVALID && response != null
            ? response.path("validationResults").toString()
            : null;
    return new DocumentStatusResult(status, longId, Instant.now(), invalidReason);
  }

  @Override
  public void cancel(String documentUuid, String reason) {
    requireConfigured();
    changeState(documentUuid, "cancelled", reason);
  }

  @Override
  public void reject(String documentUuid, String reason) {
    requireConfigured();
    changeState(documentUuid, "rejected", reason);
  }

  private void changeState(String documentUuid, String status, String reason) {
    apiClient
        .put()
        .uri("/api/v1.0/documents/state/{uuid}/state", documentUuid)
        .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken())
        .contentType(MediaType.APPLICATION_JSON)
        .body(Map.of("status", status, "reason", reason))
        .retrieve()
        .toBodilessEntity();
  }

  private synchronized String accessToken() {
    if (cachedToken != null && Instant.now().isBefore(tokenExpiresAt.minusSeconds(60))) {
      return cachedToken;
    }
    MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
    form.add("client_id", properties.clientId());
    form.add("client_secret", properties.clientSecret());
    form.add("grant_type", "client_credentials");
    form.add("scope", properties.scopeOrDefault());

    JsonNode response =
        identityClient
            .post()
            .uri("/connect/token")
            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
            .body(form)
            .retrieve()
            .body(JsonNode.class);
    if (response == null || !response.has("access_token")) {
      throw new ApiException(
          HttpStatus.SERVICE_UNAVAILABLE,
          "EINVOICE_AUTH_FAILED",
          "Could not authenticate with MyInvois.");
    }
    cachedToken = response.path("access_token").asText();
    long expiresInSeconds = response.path("expires_in").asLong(3600);
    tokenExpiresAt = Instant.now().plusSeconds(expiresInSeconds);
    return cachedToken;
  }

  private void requireConfigured() {
    if (!isAvailable()) {
      throw new ApiException(
          HttpStatus.SERVICE_UNAVAILABLE,
          "EINVOICE_PROVIDER_UNAVAILABLE",
          "MyInvois credentials aren't configured for this environment.");
    }
  }

  private String documentHash(String json) {
    try {
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] hash = digest.digest(json.getBytes(StandardCharsets.UTF_8));
      return HexFormat.of().formatHex(hash);
    } catch (Exception e) {
      throw new IllegalStateException("SHA-256 is always available on the JVM", e);
    }
  }
}
