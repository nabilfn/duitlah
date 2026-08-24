package com.duitlah.api.assets;

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
public class AssetDepreciationController {

  private final DepreciationService depreciationService;

  public AssetDepreciationController(DepreciationService depreciationService) {
    this.depreciationService = depreciationService;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/assets/{assetId}/depreciation/run")
  @ResponseStatus(HttpStatus.CREATED)
  public DepreciationEntryResponse run(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID assetId,
      @Valid @RequestBody RunDepreciationRequest request) {
    return depreciationService.runForPeriod(userId, spaceId, assetId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/assets/{assetId}/depreciation-entries")
  public List<DepreciationEntryResponse> list(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID assetId) {
    return depreciationService.listEntries(userId, spaceId, assetId);
  }
}
