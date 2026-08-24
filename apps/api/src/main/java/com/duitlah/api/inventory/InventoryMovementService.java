package com.duitlah.api.inventory;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.bizbanking.BusinessAccount;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.catalog.Product;
import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Creates {@link InventoryMovement} rows and drives the accounting side-effects that go with them
 * (spec sections 46-48). A movement's sign decides how its {@code unitCost} is determined, not its
 * {@link MovementType}: an inbound (positive-quantity) movement requires the caller to supply the
 * real unit cost paid; an outbound (negative-quantity) movement always has its cost computed
 * server-side from the current Weighted Average Cost, so a past sale's locked-in cost can never be
 * second-guessed by a client. Negative resulting stock is not blocked — this phase has no
 * warehouse/location concept, and rejecting it would just push the same reconciliation problem onto
 * the user in a more confusing way than a report simply showing a negative balance.
 */
@Service
public class InventoryMovementService {

  private final InventoryMovementRepository movements;
  private final InventoryValuationService valuationService;
  private final ProductService productService;
  private final BusinessAccountService businessAccountService;
  private final AutomaticPostingService automaticPostingService;
  private final SpaceService spaceService;

  public InventoryMovementService(
      InventoryMovementRepository movements,
      InventoryValuationService valuationService,
      ProductService productService,
      BusinessAccountService businessAccountService,
      AutomaticPostingService automaticPostingService,
      SpaceService spaceService) {
    this.movements = movements;
    this.valuationService = valuationService;
    this.productService = productService;
    this.businessAccountService = businessAccountService;
    this.automaticPostingService = automaticPostingService;
    this.spaceService = spaceService;
  }

  @Transactional
  public MovementResponse record(
      UUID userId, UUID spaceId, UUID productId, CreateMovementRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_PRODUCTS);
    Product product = productService.requireOwned(spaceId, productId);
    if (request.quantity().signum() == 0) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "ZERO_QUANTITY", "Movement quantity cannot be zero.");
    }

    BigDecimal unitCost;
    if (request.quantity().signum() > 0) {
      if (request.unitCost() == null) {
        throw new ApiException(
            HttpStatus.BAD_REQUEST, "UNIT_COST_REQUIRED", "An inbound movement needs a unit cost.");
      }
      unitCost = request.unitCost();
    } else {
      unitCost = valuationService.compute(product.getId()).weightedAverageCost();
    }

    InventoryMovement movement =
        new InventoryMovement(
            spaceId,
            product.getId(),
            request.type(),
            request.quantity(),
            unitCost,
            request.occurredOn(),
            request.notes(),
            userId);
    movements.save(movement);

    if (request.type() == MovementType.PURCHASE) {
      UUID businessAccountChartOfAccountsId = null;
      if (request.businessAccountId() != null) {
        BusinessAccount account =
            businessAccountService.requireOwned(spaceId, request.businessAccountId());
        businessAccountChartOfAccountsId = account.getChartOfAccountsId();
      }
      automaticPostingService.postInventoryPurchase(
          spaceId,
          userId,
          movement.getId(),
          request.occurredOn(),
          movement.value(),
          "Inventory purchase: " + product.getName(),
          businessAccountChartOfAccountsId);
    } else if (request.type() == MovementType.SALE) {
      automaticPostingService.postCogs(
          spaceId,
          userId,
          movement.getId(),
          request.occurredOn(),
          movement.value().abs(),
          "COGS: " + product.getName());
    }

    return MovementResponse.of(movement);
  }

  public List<MovementResponse> list(UUID userId, UUID spaceId, UUID productId) {
    spaceService.requireMembership(userId, spaceId);
    productService.requireOwned(spaceId, productId);
    return movements.findByProductIdOrderByOccurredOnDescCreatedAtDesc(productId).stream()
        .map(MovementResponse::of)
        .toList();
  }

  public ValuationResponse valuation(UUID userId, UUID spaceId, UUID productId) {
    spaceService.requireMembership(userId, spaceId);
    Product product = productService.requireOwned(spaceId, productId);
    return ValuationResponse.of(product.getId(), valuationService.compute(product.getId()));
  }

  /**
   * Called by {@code sales.InvoiceService} on the DRAFT→SENT transition for each line item whose
   * product tracks inventory. Idempotent per invoice line item: re-issuing (or any retry) is a
   * no-op once a movement already exists for that line item.
   */
  @Transactional
  public void recordSaleFromInvoice(
      UUID spaceId,
      UUID userId,
      UUID productId,
      BigDecimal quantitySold,
      LocalDate occurredOn,
      UUID invoiceLineItemId) {
    if (movements.existsBySourceInvoiceLineItemId(invoiceLineItemId)) {
      return;
    }
    BigDecimal unitCost = valuationService.compute(productId).weightedAverageCost();
    InventoryMovement movement =
        new InventoryMovement(
            spaceId,
            productId,
            MovementType.SALE,
            quantitySold.abs().negate(),
            unitCost,
            occurredOn,
            "Invoice sale",
            userId);
    movement.setSourceInvoiceLineItemId(invoiceLineItemId);
    movements.save(movement);
    Product product = productService.requireOwned(spaceId, productId);
    automaticPostingService.postCogs(
        spaceId,
        userId,
        movement.getId(),
        occurredOn,
        movement.value().abs(),
        "COGS: " + product.getName());
  }

  InventoryMovement requireOwned(UUID spaceId, UUID movementId) {
    return movements
        .findByIdAndSpaceId(movementId, spaceId)
        .orElseThrow(
            () -> new NotFoundException("MOVEMENT_NOT_FOUND", "Inventory movement not found."));
  }
}
