package com.duitlah.api.transactions;

import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TransactionController {

  private final TransactionService transactionService;

  public TransactionController(TransactionService transactionService) {
    this.transactionService = transactionService;
  }

  @PostMapping("/api/v1/transactions")
  @ResponseStatus(HttpStatus.CREATED)
  public TransactionResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateTransactionRequest request) {
    return transactionService.create(userId, request);
  }

  @PostMapping("/api/v1/transactions/transfer")
  @ResponseStatus(HttpStatus.CREATED)
  public List<TransactionResponse> createTransfer(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateTransferRequest request) {
    return transactionService.createTransfer(userId, request);
  }

  @GetMapping("/api/v1/transactions")
  public Page<TransactionResponse> search(
      @AuthenticationPrincipal UUID userId,
      @RequestParam(required = false) UUID accountId,
      @RequestParam(required = false) TransactionType type,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
      @PageableDefault(size = 50) Pageable pageable) {
    return transactionService.search(userId, accountId, type, from, to, pageable);
  }

  @GetMapping("/api/v1/transactions/recent")
  public List<TransactionResponse> recent(@AuthenticationPrincipal UUID userId) {
    return transactionService.recent(userId);
  }

  @GetMapping("/api/v1/transactions/{transactionId}")
  public TransactionResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID transactionId) {
    return transactionService.get(userId, transactionId);
  }

  @PatchMapping("/api/v1/transactions/{transactionId}")
  public TransactionResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID transactionId,
      @Valid @RequestBody UpdateTransactionRequest request) {
    return transactionService.update(userId, transactionId, request);
  }

  @DeleteMapping("/api/v1/transactions/{transactionId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID transactionId) {
    transactionService.delete(userId, transactionId);
  }
}
