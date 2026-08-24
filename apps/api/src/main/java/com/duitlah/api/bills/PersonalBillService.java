package com.duitlah.api.bills;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.receipts.ReceiptVaultService;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.transactions.CreateTransactionRequest;
import com.duitlah.api.transactions.TransactionResponse;
import com.duitlah.api.transactions.TransactionService;
import com.duitlah.api.transactions.TransactionType;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PersonalBillService {

  private final PersonalBillRepository bills;
  private final SpaceService spaceService;
  private final TransactionService transactionService;
  private final ReceiptVaultService receiptVaultService;

  public PersonalBillService(
      PersonalBillRepository bills,
      SpaceService spaceService,
      TransactionService transactionService,
      ReceiptVaultService receiptVaultService) {
    this.bills = bills;
    this.spaceService = spaceService;
    this.transactionService = transactionService;
    this.receiptVaultService = receiptVaultService;
  }

  @Transactional
  public PersonalBillResponse create(UUID userId, CreatePersonalBillRequest request) {
    PersonalBill bill =
        new PersonalBill(
            userId,
            spaceService.personalSpaceIdFor(userId),
            request.name().trim(),
            request.provider(),
            request.dueDate(),
            request.expectedAmount(),
            request.recurrenceOrNone(),
            null);
    bill.setNotes(request.notes());
    bills.save(bill);
    return PersonalBillResponse.from(bill);
  }

  public List<PersonalBillResponse> list(UUID userId, BillStatus status) {
    List<PersonalBill> rows =
        status != null
            ? bills.findByUserIdAndStatusOrderByDueDateAsc(userId, status)
            : bills.findByUserIdOrderByDueDateAsc(userId);
    return rows.stream().map(PersonalBillResponse::from).toList();
  }

  public PersonalBillResponse get(UUID userId, UUID billId) {
    return PersonalBillResponse.from(requireOwned(userId, billId));
  }

  @Transactional
  public PersonalBillResponse markPaid(UUID userId, UUID billId, MarkBillPaidRequest request) {
    PersonalBill bill = requireOwned(userId, billId);
    requireUnresolved(bill);

    TransactionResponse transaction =
        transactionService.create(
            userId,
            new CreateTransactionRequest(
                request.accountId(),
                TransactionType.EXPENSE,
                request.categoryId(),
                request.amount(),
                bill.getProvider() != null ? bill.getProvider() : bill.getName(),
                bill.getName(),
                null,
                request.paidOn(),
                null,
                null,
                null));

    bill.setLinkedTransactionId(transaction.id());
    bill.setStatus(BillStatus.PAID);
    bills.save(bill);

    if (bill.getRecurrence() != BillRecurrence.NONE) {
      PersonalBill next =
          new PersonalBill(
              userId,
              bill.getSpaceId(),
              bill.getName(),
              bill.getProvider(),
              nextDueDate(bill.getDueDate(), bill.getRecurrence()),
              bill.getExpectedAmount(),
              bill.getRecurrence(),
              bill.getRecurringTransactionId());
      bills.save(next);
    }

    return PersonalBillResponse.from(bill);
  }

  /**
   * "Receipt automation" (V2 Phase 13): wires up {@code receiptId}, previously a dead field with no
   * write path anywhere in this codebase. Reuses {@code ReceiptVaultService#get} to verify the
   * receipt actually belongs to this user (throws {@code NotFoundException} otherwise) rather than
   * trusting the id at face value.
   */
  @Transactional
  public PersonalBillResponse attachReceipt(UUID userId, UUID billId, UUID receiptId) {
    PersonalBill bill = requireOwned(userId, billId);
    receiptVaultService.get(userId, receiptId);
    bill.setReceiptId(receiptId);
    bills.save(bill);
    return PersonalBillResponse.from(bill);
  }

  @Transactional
  public PersonalBillResponse skip(UUID userId, UUID billId) {
    PersonalBill bill = requireOwned(userId, billId);
    requireUnresolved(bill);
    bill.setStatus(BillStatus.SKIPPED);
    bills.save(bill);
    return PersonalBillResponse.from(bill);
  }

  private static LocalDate nextDueDate(LocalDate current, BillRecurrence recurrence) {
    return switch (recurrence) {
      case WEEKLY -> current.plusWeeks(1);
      case MONTHLY -> current.plusMonths(1);
      case YEARLY -> current.plusYears(1);
      case NONE -> current;
    };
  }

  private void requireUnresolved(PersonalBill bill) {
    if (bill.isResolved()) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "BILL_ALREADY_RESOLVED",
          "This bill has already been " + bill.getStatus().name().toLowerCase() + ".");
    }
  }

  private PersonalBill requireOwned(UUID userId, UUID billId) {
    return bills
        .findByIdAndUserId(billId, userId)
        .orElseThrow(() -> new NotFoundException("BILL_NOT_FOUND", "Bill not found."));
  }
}
