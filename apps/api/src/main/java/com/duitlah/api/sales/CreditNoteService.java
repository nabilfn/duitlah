package com.duitlah.api.sales;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.crm.CustomerService;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CreditNoteService {

  private final CreditNoteRepository creditNotes;
  private final SpaceService spaceService;
  private final CustomerService customerService;
  private final InvoiceService invoiceService;
  private final AutomaticPostingService automaticPostingService;

  public CreditNoteService(
      CreditNoteRepository creditNotes,
      SpaceService spaceService,
      CustomerService customerService,
      InvoiceService invoiceService,
      AutomaticPostingService automaticPostingService) {
    this.creditNotes = creditNotes;
    this.spaceService = spaceService;
    this.customerService = customerService;
    this.invoiceService = invoiceService;
    this.automaticPostingService = automaticPostingService;
  }

  @Transactional
  public CreditNoteResponse create(UUID userId, UUID spaceId, CreateCreditNoteRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    customerService.requireOwned(spaceId, request.customerId());
    if (request.invoiceId() != null) {
      invoiceService.requireOwned(spaceId, request.invoiceId());
    }
    CreditNote creditNote =
        new CreditNote(
            spaceId,
            request.customerId(),
            request.invoiceId(),
            nextCreditNoteNumber(spaceId),
            request.issueDate(),
            request.amount(),
            request.reason());
    creditNotes.save(creditNote);
    // Only posted when linked to an invoice — a standalone credit note has no prior recognized
    // revenue for this to reverse against.
    if (request.invoiceId() != null) {
      automaticPostingService.postCreditNote(
          spaceId,
          userId,
          creditNote.getId(),
          creditNote.getIssueDate(),
          creditNote.getAmount(),
          "Credit note " + creditNote.getCreditNoteNumber());
    }
    return CreditNoteResponse.of(creditNote);
  }

  public List<CreditNoteResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return creditNotes.findBySpaceIdOrderByIssueDateDesc(spaceId).stream()
        .map(CreditNoteResponse::of)
        .toList();
  }

  public CreditNoteResponse get(UUID userId, UUID spaceId, UUID creditNoteId) {
    spaceService.requireMembership(userId, spaceId);
    return CreditNoteResponse.of(requireOwned(spaceId, creditNoteId));
  }

  @Transactional
  public CreditNoteResponse voidCreditNote(UUID userId, UUID spaceId, UUID creditNoteId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    CreditNote creditNote = requireOwned(spaceId, creditNoteId);
    creditNote.setStatus(CreditNoteStatus.VOID);
    creditNotes.save(creditNote);
    return CreditNoteResponse.of(creditNote);
  }

  private String nextCreditNoteNumber(UUID spaceId) {
    long count = creditNotes.countBySpaceId(spaceId) + 1;
    return "CN-%05d".formatted(count);
  }

  public CreditNote requireOwned(UUID spaceId, UUID creditNoteId) {
    return creditNotes
        .findByIdAndSpaceId(creditNoteId, spaceId)
        .orElseThrow(
            () -> new NotFoundException("CREDIT_NOTE_NOT_FOUND", "Credit note not found."));
  }
}
