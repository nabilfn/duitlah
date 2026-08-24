package com.duitlah.api.receipts;

import com.duitlah.api.bagilah.BillResponse;
import com.duitlah.api.common.error.ApiException;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ReceiptScanController {

  private final ReceiptScanService receiptScanService;

  public ReceiptScanController(ReceiptScanService receiptScanService) {
    this.receiptScanService = receiptScanService;
  }

  @PostMapping("/api/v1/receipts/scans")
  @ResponseStatus(HttpStatus.CREATED)
  public ReceiptScanResponse upload(
      @AuthenticationPrincipal UUID userId, @RequestParam("image") MultipartFile image) {
    try {
      return receiptScanService.upload(userId, image.getBytes(), image.getContentType());
    } catch (IOException e) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "UNREADABLE_UPLOAD", "Couldn't read the uploaded file.");
    }
  }

  @GetMapping("/api/v1/receipts/scans")
  public List<ReceiptScanResponse> list(@AuthenticationPrincipal UUID userId) {
    return receiptScanService.listForUser(userId);
  }

  @GetMapping("/api/v1/receipts/scans/{scanId}")
  public ReceiptScanResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID scanId) {
    return receiptScanService.getForUser(userId, scanId);
  }

  @PostMapping("/api/v1/receipts/scans/{scanId}/confirm")
  public BillResponse confirm(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID scanId,
      @Valid @RequestBody ConfirmReceiptScanRequest request) {
    return receiptScanService.confirm(userId, scanId, request);
  }
}
