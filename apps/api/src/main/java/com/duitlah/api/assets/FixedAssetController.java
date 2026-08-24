package com.duitlah.api.assets;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FixedAssetController {

  private final FixedAssetService assets;

  public FixedAssetController(FixedAssetService assets) {
    this.assets = assets;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/assets")
  @ResponseStatus(HttpStatus.CREATED)
  public FixedAssetResponse create(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @Valid @RequestBody CreateFixedAssetRequest request) {
    return assets.create(userId, spaceId, request);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/assets")
  public List<FixedAssetResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return assets.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/assets/{assetId}")
  public FixedAssetResponse get(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID assetId) {
    return assets.get(userId, spaceId, assetId);
  }

  @PutMapping("/api/v1/spaces/{spaceId}/assets/{assetId}")
  public FixedAssetResponse update(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID assetId,
      @Valid @RequestBody CreateFixedAssetRequest request) {
    return assets.update(userId, spaceId, assetId, request);
  }

  @PostMapping("/api/v1/spaces/{spaceId}/assets/{assetId}/dispose")
  public FixedAssetResponse dispose(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID assetId,
      @Valid @RequestBody DisposeAssetRequest request) {
    return assets.dispose(userId, spaceId, assetId, request);
  }
}
