package com.duitlah.api.receipts;

import com.duitlah.api.common.error.ApiException;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ReceiptVaultController {

  private final ReceiptVaultService vault;

  public ReceiptVaultController(ReceiptVaultService vault) {
    this.vault = vault;
  }

  /** Accepts one or more files in the same request — "batch scanning" (spec section 15). */
  @PostMapping("/api/v1/receipts/vault")
  @ResponseStatus(HttpStatus.CREATED)
  public List<ReceiptResponse> upload(
      @AuthenticationPrincipal UUID userId,
      @RequestParam("files") List<MultipartFile> files,
      @RequestParam ReceiptPurpose purpose,
      @RequestParam(required = false) String folder,
      @RequestParam(required = false) List<String> tags) {
    return files.stream()
        .map(
            file -> {
              try {
                return vault.upload(
                    userId, file.getBytes(), file.getContentType(), purpose, folder, tags);
              } catch (IOException e) {
                throw new ApiException(
                    HttpStatus.BAD_REQUEST,
                    "UNREADABLE_UPLOAD",
                    "Couldn't read the uploaded file.");
              }
            })
        .toList();
  }

  @GetMapping("/api/v1/receipts/vault")
  public List<ReceiptResponse> search(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(required = false) String folder,
      @RequestParam(required = false) String merchant) {
    return vault.search(userId, folder, merchant);
  }

  @GetMapping("/api/v1/receipts/vault/{receiptId}")
  public ReceiptResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID receiptId) {
    return vault.get(userId, receiptId);
  }

  @PostMapping("/api/v1/receipts/vault/{receiptId}/attach")
  public ReceiptResponse attach(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID receiptId,
      @RequestParam UUID transactionId) {
    return vault.attachToTransaction(userId, receiptId, transactionId);
  }

  @GetMapping("/api/v1/receipts/vault/{receiptId}/match-suggestions")
  public List<ReceiptTransactionMatchSuggestion> matchSuggestions(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID receiptId) {
    return vault.suggestTransactionMatches(userId, receiptId);
  }
}
