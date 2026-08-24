package com.duitlah.api.transactions;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.finance.Account;
import com.duitlah.api.finance.AccountService;
import com.duitlah.api.finance.CategoryService;
import com.duitlah.api.finance.CategoryType;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TransactionService {

  private final TransactionRepository transactions;
  private final AccountService accountService;
  private final CategoryService categoryService;
  private final AuditLogService auditLogService;

  public TransactionService(
      TransactionRepository transactions,
      AccountService accountService,
      CategoryService categoryService,
      AuditLogService auditLogService) {
    this.transactions = transactions;
    this.accountService = accountService;
    this.categoryService = categoryService;
    this.auditLogService = auditLogService;
  }

  @Transactional
  public TransactionResponse create(UUID userId, CreateTransactionRequest request) {
    if (request.type() == TransactionType.TRANSFER) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "USE_TRANSFER_ENDPOINT",
          "Use POST /api/v1/transactions/transfer for transfers.");
    }
    Account account = accountService.requireOwned(userId, request.accountId());
    if (request.categoryId() != null) {
      CategoryType categoryType =
          request.type() == TransactionType.INCOME ? CategoryType.INCOME : CategoryType.EXPENSE;
      categoryService.requireUsable(userId, request.categoryId(), categoryType);
    }

    TransactionDirection direction =
        request.type() == TransactionType.INCOME
            ? TransactionDirection.IN
            : TransactionDirection.OUT;
    Transaction transaction =
        new Transaction(
            userId,
            account.getId(),
            request.type(),
            direction,
            request.categoryId(),
            null,
            request.amount(),
            request.merchant(),
            request.description(),
            request.notes(),
            request.occurredOn());
    if (request.originalCurrency() != null) {
      transaction.setOriginalCurrency(request.originalCurrency());
      transaction.setOriginalAmount(request.originalAmount());
      transaction.setExchangeRate(request.exchangeRate());
      transaction.setConvertedAt(java.time.Instant.now());
    }
    transactions.save(transaction);
    auditLogService.record(
        userId,
        AuditAction.TRANSACTION_CREATED,
        "Transaction",
        transaction.getId(),
        Map.of("amount", request.amount(), "type", request.type()));
    return TransactionResponse.from(transaction);
  }

  @Transactional
  public List<TransactionResponse> createTransfer(UUID userId, CreateTransferRequest request) {
    if (request.fromAccountId().equals(request.toAccountId())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "SAME_ACCOUNT_TRANSFER", "Transfer accounts must be different.");
    }
    Account from = accountService.requireOwned(userId, request.fromAccountId());
    Account to = accountService.requireOwned(userId, request.toAccountId());
    if (!from.getCurrency().equals(to.getCurrency())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "CURRENCY_MISMATCH",
          "Transfers between accounts in different currencies aren't supported yet.");
    }

    UUID transferGroupId = UUID.randomUUID();
    Transaction outgoing =
        new Transaction(
            userId,
            from.getId(),
            TransactionType.TRANSFER,
            TransactionDirection.OUT,
            null,
            transferGroupId,
            request.amount(),
            null,
            request.description(),
            request.notes(),
            request.occurredOn());
    Transaction incoming =
        new Transaction(
            userId,
            to.getId(),
            TransactionType.TRANSFER,
            TransactionDirection.IN,
            null,
            transferGroupId,
            request.amount(),
            null,
            request.description(),
            request.notes(),
            request.occurredOn());
    transactions.save(outgoing);
    transactions.save(incoming);
    return List.of(TransactionResponse.from(outgoing), TransactionResponse.from(incoming));
  }

  public Page<TransactionResponse> search(
      UUID userId,
      UUID accountId,
      TransactionType type,
      LocalDate from,
      LocalDate to,
      Pageable pageable) {
    if (accountId != null) {
      accountService.requireOwned(userId, accountId);
    }
    return transactions
        .search(userId, accountId, type, from, to, pageable)
        .map(TransactionResponse::from);
  }

  public TransactionResponse get(UUID userId, UUID transactionId) {
    return TransactionResponse.from(requireOwned(userId, transactionId));
  }

  public List<TransactionResponse> recent(UUID userId) {
    return transactions.findTop10ByUserIdOrderByOccurredOnDescCreatedAtDesc(userId).stream()
        .map(TransactionResponse::from)
        .toList();
  }

  @Transactional
  public TransactionResponse update(
      UUID userId, UUID transactionId, UpdateTransactionRequest request) {
    Transaction transaction = requireOwned(userId, transactionId);
    if (request.categoryId() != null) {
      CategoryType categoryType =
          transaction.getType() == TransactionType.INCOME
              ? CategoryType.INCOME
              : CategoryType.EXPENSE;
      categoryService.requireUsable(userId, request.categoryId(), categoryType);
    }
    transaction.setCategoryId(request.categoryId());
    transaction.setAmount(request.amount());
    transaction.setMerchant(request.merchant());
    transaction.setDescription(request.description());
    transaction.setNotes(request.notes());
    transaction.setOccurredOn(request.occurredOn());
    transactions.save(transaction);
    auditLogService.record(
        userId,
        AuditAction.TRANSACTION_MODIFIED,
        "Transaction",
        transaction.getId(),
        Map.of("amount", request.amount()));
    return TransactionResponse.from(transaction);
  }

  @Transactional
  public void delete(UUID userId, UUID transactionId) {
    Transaction transaction = requireOwned(userId, transactionId);
    if (transaction.getTransferGroupId() != null) {
      List<Transaction> pair = transactions.findByTransferGroupId(transaction.getTransferGroupId());
      transactions.deleteAll(pair.stream().filter(t -> userId.equals(t.getUserId())).toList());
    } else {
      transactions.delete(transaction);
    }
  }

  private Transaction requireOwned(UUID userId, UUID transactionId) {
    return transactions
        .findByIdAndUserId(transactionId, userId)
        .orElseThrow(
            () -> new NotFoundException("TRANSACTION_NOT_FOUND", "Transaction not found."));
  }
}
