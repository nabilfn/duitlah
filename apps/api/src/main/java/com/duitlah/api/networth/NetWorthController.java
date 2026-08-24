package com.duitlah.api.networth;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class NetWorthController {

  private final NetWorthService netWorth;

  public NetWorthController(NetWorthService netWorth) {
    this.netWorth = netWorth;
  }

  @GetMapping("/api/v1/net-worth")
  public NetWorthResponse compute(@AuthenticationPrincipal UUID userId) {
    return netWorth.compute(userId);
  }

  @PostMapping("/api/v1/net-worth/snapshots")
  @ResponseStatus(HttpStatus.CREATED)
  public NetWorthSnapshotResponse takeSnapshot(@AuthenticationPrincipal UUID userId) {
    return netWorth.takeSnapshot(userId);
  }

  @GetMapping("/api/v1/net-worth/snapshots")
  public List<NetWorthSnapshotResponse> history(@AuthenticationPrincipal UUID userId) {
    return netWorth.history(userId);
  }

  @PostMapping("/api/v1/net-worth/other-assets")
  @ResponseStatus(HttpStatus.CREATED)
  public OtherAssetResponse addOtherAsset(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody CreateOtherAssetRequest request) {
    return netWorth.addOtherAsset(userId, request);
  }

  @GetMapping("/api/v1/net-worth/other-assets")
  public List<OtherAssetResponse> listOtherAssets(@AuthenticationPrincipal UUID userId) {
    return netWorth.listOtherAssets(userId);
  }

  @DeleteMapping("/api/v1/net-worth/other-assets/{assetId}")
  public void deleteOtherAsset(@AuthenticationPrincipal UUID userId, @PathVariable UUID assetId) {
    netWorth.deleteOtherAsset(userId, assetId);
  }
}
