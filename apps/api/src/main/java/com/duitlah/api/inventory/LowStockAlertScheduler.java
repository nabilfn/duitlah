package com.duitlah.api.inventory;

import com.duitlah.api.catalog.Product;
import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.notifications.NotificationService;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.FinancialSpaceRepository;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.spaces.SpaceType;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Notifies members who can {@code MANAGE_PRODUCTS} once a tracked product's quantity on hand dips
 * to or below its reorder point (spec section 49). Same "thin {@code @Scheduled} wrapper around a
 * plain, independently-callable/testable method" shape as {@code bills.PersonalBillScheduler}.
 *
 * <p>Dedup: {@code Product.lowStockNotifiedAt} is set the first time a dip is detected and only
 * cleared once stock rises back above the reorder point, so a sustained dip sends exactly one alert
 * rather than one per scheduler run.
 */
@Component
public class LowStockAlertScheduler {

  private static final Logger log = LoggerFactory.getLogger(LowStockAlertScheduler.class);

  private final FinancialSpaceRepository spaces;
  private final ProductService productService;
  private final InventoryValuationService valuationService;
  private final SpaceService spaceService;
  private final NotificationService notifications;

  public LowStockAlertScheduler(
      FinancialSpaceRepository spaces,
      ProductService productService,
      InventoryValuationService valuationService,
      SpaceService spaceService,
      NotificationService notifications) {
    this.spaces = spaces;
    this.productService = productService;
    this.valuationService = valuationService;
    this.spaceService = spaceService;
    this.notifications = notifications;
  }

  @Scheduled(cron = "0 0 7 * * *")
  @Transactional
  public void checkLowStock() {
    int alerted = 0;
    for (var space : spaces.findByType(SpaceType.BUSINESS)) {
      for (Product product : productService.listTrackedWithReorderPoint(space.getId())) {
        BigDecimal quantityOnHand = valuationService.compute(product.getId()).quantityOnHand();
        boolean lowStock = quantityOnHand.compareTo(product.getReorderPoint()) <= 0;
        if (lowStock && product.getLowStockNotifiedAt() == null) {
          alertMembers(space.getId(), product, quantityOnHand);
          productService.markLowStockNotifiedAt(product.getId(), Instant.now());
          alerted++;
        } else if (!lowStock && product.getLowStockNotifiedAt() != null) {
          productService.markLowStockNotifiedAt(product.getId(), null);
        }
      }
    }
    if (alerted > 0) {
      log.info("Low-stock alerts sent for {} product(s)", alerted);
    }
  }

  private void alertMembers(UUID spaceId, Product product, BigDecimal quantityOnHand) {
    List<UUID> recipients =
        spaceService.listActiveMemberUserIdsWithPermission(
            spaceId, BusinessPermission.MANAGE_PRODUCTS);
    String title = product.getName() + " is running low";
    String body =
        product.getName()
            + " has "
            + quantityOnHand
            + " "
            + product.getUnit()
            + " on hand, at or below its reorder point of "
            + product.getReorderPoint()
            + ".";
    for (UUID userId : recipients) {
      notifications.notify(userId, "LOW_STOCK_ALERT", title, body);
    }
  }
}
