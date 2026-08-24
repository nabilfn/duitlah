package com.duitlah.api.bills;

import jakarta.validation.Valid;
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

@RestController
public class PersonalBillController {

  private final PersonalBillService bills;

  public PersonalBillController(PersonalBillService bills) {
    this.bills = bills;
  }

  @PostMapping("/api/v1/personal-bills")
  @ResponseStatus(HttpStatus.CREATED)
  public PersonalBillResponse create(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreatePersonalBillRequest request) {
    return bills.create(userId, request);
  }

  @GetMapping("/api/v1/personal-bills")
  public List<PersonalBillResponse> list(
      @AuthenticationPrincipal UUID userId, @RequestParam(required = false) BillStatus status) {
    return bills.list(userId, status);
  }

  @GetMapping("/api/v1/personal-bills/{billId}")
  public PersonalBillResponse get(@AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return bills.get(userId, billId);
  }

  @PostMapping("/api/v1/personal-bills/{billId}/mark-paid")
  public PersonalBillResponse markPaid(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @Valid @RequestBody MarkBillPaidRequest request) {
    return bills.markPaid(userId, billId, request);
  }

  @PostMapping("/api/v1/personal-bills/{billId}/skip")
  public PersonalBillResponse skip(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID billId) {
    return bills.skip(userId, billId);
  }

  @PostMapping("/api/v1/personal-bills/{billId}/receipt")
  public PersonalBillResponse attachReceipt(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID billId,
      @RequestParam UUID receiptId) {
    return bills.attachReceipt(userId, billId, receiptId);
  }
}
