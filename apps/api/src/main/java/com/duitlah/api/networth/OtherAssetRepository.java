package com.duitlah.api.networth;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OtherAssetRepository extends JpaRepository<OtherAsset, UUID> {

  Optional<OtherAsset> findByIdAndUserId(UUID id, UUID userId);

  List<OtherAsset> findByUserId(UUID userId);
}
