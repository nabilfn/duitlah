package com.duitlah.api.assets;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FixedAssetRepository extends JpaRepository<FixedAsset, UUID> {

  Optional<FixedAsset> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<FixedAsset> findBySpaceIdOrderByAcquisitionDateDesc(UUID spaceId);

  /** Every active asset across every business space — for {@link AssetDepreciationScheduler}. */
  List<FixedAsset> findByStatus(AssetStatus status);
}
