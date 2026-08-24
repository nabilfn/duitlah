// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

/// Phase 8 — Inventory & Costing. `PURCHASE`/`RETURN`/`ADJUSTMENT` (positive)/
/// `TRANSFER` (either sign)/`OPENING_BALANCE` can be inbound; `SALE` and a
/// negative `ADJUSTMENT`/`TRANSFER` are outbound. The client never computes
/// which — it just sends a signed [MovementResponse.quantity] and lets the
/// server decide, matching the request contract's "signed decimal string".
enum MovementType { PURCHASE, SALE, RETURN, ADJUSTMENT, TRANSFER, OPENING_BALANCE }

/// One stock movement against a [MovementType.trackInventory]-enabled
/// product. [unitCost] is always populated in the response even though the
/// request only requires it for a positive [quantity] — for a negative
/// (outbound) movement the server fills it in itself from the current
/// Weighted Average Cost at posting time.
@freezed
abstract class MovementResponse with _$MovementResponse {
  const factory MovementResponse({
    required String id,
    required String productId,
    required MovementType type,
    @AmountConverter() required String quantity,
    @AmountConverter() required String unitCost,
    @AmountConverter() required String value,
    required String occurredOn,
    String? notes,
    String? sourceInvoiceLineItemId,
    required String createdByUserId,
    required String createdAt,
  }) = _MovementResponse;

  factory MovementResponse.fromJson(Map<String, dynamic> json) => _$MovementResponseFromJson(json);
}

/// A product's current stock position — [weightedAverageCost] is the
/// actual moving cost this phase tracks, distinct from `Product.cost`
/// (a reference/standard cost that never moves on its own).
@freezed
abstract class ProductValuationResponse with _$ProductValuationResponse {
  const factory ProductValuationResponse({
    required String productId,
    @AmountConverter() required String quantityOnHand,
    @AmountConverter() required String weightedAverageCost,
    @AmountConverter() required String totalValue,
  }) = _ProductValuationResponse;

  factory ProductValuationResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductValuationResponseFromJson(json);
}

/// One ingredient line within a product's recipe (e.g. a menu item's
/// per-unit ingredient list). [lineCost] = [quantityPerUnit] ×
/// [ingredientUnitCost], both computed server-side.
@freezed
abstract class RecipeItemResponse with _$RecipeItemResponse {
  const factory RecipeItemResponse({
    required String id,
    required String ingredientProductId,
    required String ingredientName,
    @AmountConverter() required String quantityPerUnit,
    @AmountConverter() required String ingredientUnitCost,
    @AmountConverter() required String lineCost,
  }) = _RecipeItemResponse;

  factory RecipeItemResponse.fromJson(Map<String, dynamic> json) => _$RecipeItemResponseFromJson(json);
}

/// The computed cost/margin summary for one product's recipe — entirely
/// optional per product; a product with no recipe items simply has nothing
/// to show alongside this (never force-populated).
@freezed
abstract class RecipeCostResponse with _$RecipeCostResponse {
  const factory RecipeCostResponse({
    required String productId,
    required List<RecipeItemResponse> items,
    @AmountConverter() required String unitCost,
    @AmountConverter() required String sellingPrice,
    @AmountConverter() required String grossMargin,
    @AmountConverter() required String grossMarginPercent,
  }) = _RecipeCostResponse;

  factory RecipeCostResponse.fromJson(Map<String, dynamic> json) => _$RecipeCostResponseFromJson(json);
}

/// One row of the space-wide stock valuation report — every
/// `trackInventory`-enabled product in the space.
@freezed
abstract class StockValuationRow with _$StockValuationRow {
  const factory StockValuationRow({
    required String productId,
    required String productName,
    String? sku,
    @AmountConverter() required String quantityOnHand,
    @AmountConverter() required String weightedAverageCost,
    @AmountConverter() required String totalValue,
  }) = _StockValuationRow;

  factory StockValuationRow.fromJson(Map<String, dynamic> json) => _$StockValuationRowFromJson(json);
}

/// Space-wide Cost of Goods Sold over a date range.
@freezed
abstract class CogsReport with _$CogsReport {
  const factory CogsReport({
    required String from,
    required String to,
    @AmountConverter() required String totalCogs,
  }) = _CogsReport;

  factory CogsReport.fromJson(Map<String, dynamic> json) => _$CogsReportFromJson(json);
}
