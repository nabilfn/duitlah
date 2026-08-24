package com.duitlah.api.spaces;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SpaceController {

  private final SpaceService spaceService;

  public SpaceController(SpaceService spaceService) {
    this.spaceService = spaceService;
  }

  @GetMapping("/api/v1/spaces")
  public List<FinancialSpaceResponse> listMine(@AuthenticationPrincipal UUID userId) {
    return spaceService.listMySpaces(userId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}")
  public FinancialSpaceResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return spaceService.getSpace(userId, spaceId);
  }

  @PostMapping("/api/v1/spaces/business")
  @ResponseStatus(HttpStatus.CREATED)
  public FinancialSpaceResponse createBusiness(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreateBusinessSpaceRequest request) {
    return spaceService.createBusinessSpace(userId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/business-profile")
  public BusinessProfileResponse getBusinessProfile(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return spaceService.getBusinessProfile(userId, spaceId);
  }

  @PutMapping("/api/v1/spaces/{spaceId}/business-profile")
  public BusinessProfileResponse updateBusinessProfile(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody UpdateBusinessProfileRequest request) {
    return spaceService.updateBusinessProfile(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/members")
  public List<SpaceMemberResponse> listMembers(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return spaceService.listMembers(userId, spaceId);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/members")
  @ResponseStatus(HttpStatus.CREATED)
  public SpaceMemberResponse addMember(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody AddSpaceMemberRequest request) {
    return spaceService.addMember(userId, spaceId, request);
  }

  @PatchMapping("/api/v1/spaces/{spaceId}/members/{memberId}")
  public SpaceMemberResponse changeRole(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID memberId,
      @Valid @RequestBody ChangeSpaceMemberRoleRequest request) {
    return spaceService.changeRole(userId, spaceId, memberId, request);
  }

  @DeleteMapping("/api/v1/spaces/{spaceId}/members/{memberId}")
  public void removeMember(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID memberId) {
    spaceService.removeMember(userId, spaceId, memberId);
  }
}
