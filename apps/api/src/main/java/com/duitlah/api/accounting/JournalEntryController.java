package com.duitlah.api.accounting;

import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.format.annotation.DateTimeFormat;
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
public class JournalEntryController {

  private final JournalEntryService journalEntries;

  public JournalEntryController(JournalEntryService journalEntries) {
    this.journalEntries = journalEntries;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/accounting/journal-entries")
  @ResponseStatus(HttpStatus.CREATED)
  public JournalEntryResponse postManual(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateJournalEntryRequest request) {
    return journalEntries.postManual(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/journal-entries")
  public List<JournalEntryResponse> list(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    return journalEntries.list(userId, spaceId, from, to);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/accounting/journal-entries/{entryId}")
  public JournalEntryResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID entryId) {
    return journalEntries.get(userId, spaceId, entryId);
  }
}
