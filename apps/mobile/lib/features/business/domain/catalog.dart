// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/amount_converter.dart';

part 'catalog.freezed.dart';
part 'catalog.g.dart';

enum ProductType { GOODS, SERVICE }

/// Purely a label for now — no tax calculation happens client or server
/// side off this value (Phase 8).
enum TaxClassification { STANDARD_RATED, ZERO_RATED, EXEMPT, NOT_APPLICABLE }

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    String? sku,
    required ProductType type,
    String? unit,
    @AmountConverter() required String unitPrice,
    required bool active,
    String? description,
    /// Reference/standard cost — distinct from the actual moving Weighted
    /// Average Cost tracked via stock movements (see
    /// `../../inventory/domain/inventory.dart`'s `ProductValuationResponse`).
    @NullableAmountConverter() String? cost,
    required TaxClassification taxClassification,
    required bool trackInventory,
    @NullableAmountConverter() String? reorderPoint,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
