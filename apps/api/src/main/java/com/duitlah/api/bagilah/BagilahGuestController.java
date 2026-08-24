package com.duitlah.api.bagilah;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * Read access plus collaborative claiming for a guest who joined via an invite link — a parallel,
 * deliberately narrower surface to {@link BillController} rather than retrofitted shared auth onto
 * it. A guest can never manage items/participants/charges, record payments, or finalize/cancel —
 * only view the bill and claim (see BillService's doc on collaborative claiming). Keeping this as
 * its own controller means the existing owner/participant endpoints and their tests are untouched
 * by guest access at all.
 */
@RestController
@RequestMapping("/api/v1/bagilah/guest/{guestToken}")
public class BagilahGuestController {

  private final BillService billService;

  public BagilahGuestController(BillService billService) {
    this.billService = billService;
  }

  @GetMapping
  public BillResponse getBill(@PathVariable String guestToken) {
    return billService.getForGuest(guestToken);
  }

  @GetMapping("/items")
  public List<ReceiptItemResponse> listItems(@PathVariable String guestToken) {
    return billService.listItemsForGuest(guestToken);
  }

  @GetMapping("/participants")
  public List<ParticipantResponse> listParticipants(@PathVariable String guestToken) {
    return billService.listParticipantsForGuest(guestToken);
  }

  @GetMapping("/items/{itemId}/claims")
  public List<ClaimResponse> listClaims(
      @PathVariable String guestToken, @PathVariable UUID itemId) {
    return billService.listClaimsForGuest(guestToken, itemId);
  }

  @PostMapping("/items/{itemId}/claims")
  @ResponseStatus(HttpStatus.CREATED)
  public ClaimResponse addClaim(
      @PathVariable String guestToken,
      @PathVariable UUID itemId,
      @Valid @RequestBody ClaimRequest request) {
    return billService.addClaimAsGuest(guestToken, itemId, request);
  }

  @PostMapping("/items/{itemId}/claims/equal-split")
  public List<ClaimResponse> equalSplitItem(
      @PathVariable String guestToken,
      @PathVariable UUID itemId,
      @Valid @RequestBody EqualSplitClaimRequest request) {
    return billService.equalSplitItemAsGuest(guestToken, itemId, request);
  }

  @DeleteMapping("/items/{itemId}/claims/{claimId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void removeClaim(
      @PathVariable String guestToken, @PathVariable UUID itemId, @PathVariable UUID claimId) {
    billService.removeClaimAsGuest(guestToken, itemId, claimId);
  }

  @GetMapping("/breakdown")
  public BreakdownResponse getBreakdown(@PathVariable String guestToken) {
    return billService.getBreakdownForGuest(guestToken);
  }

  @GetMapping(path = "/events", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
  public SseEmitter subscribeToEvents(@PathVariable String guestToken) {
    return billService.subscribeToEventsAsGuest(guestToken);
  }
}
