package com.duitlah.api.crossspace;

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
public class CrossSpaceController {

  private final CrossSpaceService crossSpaceService;

  public CrossSpaceController(CrossSpaceService crossSpaceService) {
    this.crossSpaceService = crossSpaceService;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/crossspace/business-advance")
  @ResponseStatus(HttpStatus.CREATED)
  public CrossSpaceLinkResponse recordBusinessAdvance(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody RecordBusinessAdvanceRequest request) {
    return crossSpaceService.recordBusinessAdvance(userId, spaceId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/crossspace/reimbursement")
  @ResponseStatus(HttpStatus.CREATED)
  public CrossSpaceLinkResponse recordReimbursement(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody RecordReimbursementRequest request) {
    return crossSpaceService.recordReimbursement(userId, spaceId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/crossspace/owner-contribution")
  @ResponseStatus(HttpStatus.CREATED)
  public CrossSpaceLinkResponse recordOwnerContribution(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody RecordOwnerContributionRequest request) {
    return crossSpaceService.recordOwnerContribution(userId, spaceId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/crossspace/owner-drawing")
  @ResponseStatus(HttpStatus.CREATED)
  public CrossSpaceLinkResponse recordOwnerDrawing(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody RecordOwnerDrawingRequest request) {
    return crossSpaceService.recordOwnerDrawing(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/crossspace/links")
  public List<CrossSpaceLinkResponse> listForBusiness(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return crossSpaceService.listForBusiness(userId, spaceId);
  }

  @GetMapping("/api/v1/crossspace/links")
  public List<CrossSpaceLinkResponse> listForPersonal(@AuthenticationPrincipal UUID userId) {
    return crossSpaceService.listForPersonal(userId);
  }
}
