package com.duitlah.api.assets;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AssetDepreciationEntryRepository
    extends JpaRepository<AssetDepreciationEntry, UUID> {

  List<AssetDepreciationEntry> findByAssetIdOrderByPeriodDesc(UUID assetId);

  boolean existsByAssetIdAndPeriod(UUID assetId, LocalDate period);

  @Query(
      "select coalesce(sum(e.amount), 0) from AssetDepreciationEntry e where e.assetId = :assetId")
  BigDecimal sumAmountByAssetId(UUID assetId);
}
