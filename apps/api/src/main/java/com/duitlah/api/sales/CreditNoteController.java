package com.duitlah.api.sales;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CreditNoteController {

  private final CreditNoteService creditNotes;

  public CreditNoteController(CreditNoteService creditNotes) {
    this.creditNotes = creditNotes;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/credit-notes")
  @ResponseStatus(HttpStatus.CREATED)
  public CreditNoteResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateCreditNoteRequest request) {
    return creditNotes.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/credit-notes")
  public List<CreditNoteResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return creditNotes.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/credit-notes/{creditNoteId}")
  public CreditNoteResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID creditNoteId) {
    return creditNotes.get(userId, spaceId, creditNoteId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/credit-notes/{creditNoteId}/void")
  public CreditNoteResponse voidCreditNote(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID creditNoteId) {
    return creditNotes.voidCreditNote(userId, spaceId, creditNoteId);
  }
}
