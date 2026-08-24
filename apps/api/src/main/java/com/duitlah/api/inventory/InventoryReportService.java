package com.duitlah.api.inventory;

import com.duitlah.api.catalog.Product;
import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class InventoryReportService {

  private final ProductService productService;
  private final InventoryValuationService valuationService;
  private final InventoryMovementRepository movements;
  private final SpaceService spaceService;

  public InventoryReportService(
      ProductService productService,
      InventoryValuationService valuationService,
      InventoryMovementRepository movements,
      SpaceService spaceService) {
    this.productService = productService;
    this.valuationService = valuationService;
    this.movements = movements;
    this.spaceService = spaceService;
  }

  public List<StockValuationRow> stockValuation(UUID userId, UUID spaceId) {
    return productService.listTracked(userId, spaceId).stream().map(this::toRow).toList();
  }

  public CogsReportResponse cogsForPeriod(UUID userId, UUID spaceId, LocalDate from, LocalDate to) {
    spaceService.requireMembership(userId, spaceId);
    BigDecimal totalCogs =
        movements
            .findBySpaceIdAndTypeAndOccurredOnBetween(spaceId, MovementType.SALE, from, to)
            .stream()
            .map(m -> m.value().abs())
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    return new CogsReportResponse(from, to, totalCogs);
  }

  private StockValuationRow toRow(Product product) {
    InventoryValuation valuation = valuationService.compute(product.getId());
    return new StockValuationRow(
        product.getId(),
        product.getName(),
        product.getSku(),
        valuation.quantityOnHand(),
        valuation.weightedAverageCost(),
        valuation.totalValue());
  }
}
