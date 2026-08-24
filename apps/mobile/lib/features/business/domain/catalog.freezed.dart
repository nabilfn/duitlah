// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String? get sku; ProductType get type; String? get unit;@AmountConverter() String get unitPrice; bool get active; String? get description;/// Reference/standard cost — distinct from the actual moving Weighted
/// Average Cost tracked via stock movements (see
/// `../../inventory/domain/inventory.dart`'s `ProductValuationResponse`).
@NullableAmountConverter() String? get cost; TaxClassification get taxClassification; bool get trackInventory;@NullableAmountConverter() String? get reorderPoint;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.active, active) || other.active == active)&&(identical(other.description, description) || other.description == description)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.taxClassification, taxClassification) || other.taxClassification == taxClassification)&&(identical(other.trackInventory, trackInventory) || other.trackInventory == trackInventory)&&(identical(other.reorderPoint, reorderPoint) || other.reorderPoint == reorderPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sku,type,unit,unitPrice,active,description,cost,taxClassification,trackInventory,reorderPoint);

@override
String toString() {
  return 'Product(id: $id, name: $name, sku: $sku, type: $type, unit: $unit, unitPrice: $unitPrice, active: $active, description: $description, cost: $cost, taxClassification: $taxClassification, trackInventory: $trackInventory, reorderPoint: $reorderPoint)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? sku, ProductType type, String? unit,@AmountConverter() String unitPrice, bool active, String? description,@NullableAmountConverter() String? cost, TaxClassification taxClassification, bool trackInventory,@NullableAmountConverter() String? reorderPoint
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sku = freezed,Object? type = null,Object? unit = freezed,Object? unitPrice = null,Object? active = null,Object? description = freezed,Object? cost = freezed,Object? taxClassification = null,Object? trackInventory = null,Object? reorderPoint = freezed,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String?,taxClassification: null == taxClassification ? _self.taxClassification : taxClassification // ignore: cast_nullable_to_non_nullable
as TaxClassification,trackInventory: null == trackInventory ? _self.trackInventory : trackInventory // ignore: cast_nullable_to_non_nullable
as bool,reorderPoint: freezed == reorderPoint ? _self.reorderPoint : reorderPoint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? sku,  ProductType type,  String? unit, @AmountConverter()  String unitPrice,  bool active,  String? description, @NullableAmountConverter()  String? cost,  TaxClassification taxClassification,  bool trackInventory, @NullableAmountConverter()  String? reorderPoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.sku,_that.type,_that.unit,_that.unitPrice,_that.active,_that.description,_that.cost,_that.taxClassification,_that.trackInventory,_that.reorderPoint);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? sku,  ProductType type,  String? unit, @AmountConverter()  String unitPrice,  bool active,  String? description, @NullableAmountConverter()  String? cost,  TaxClassification taxClassification,  bool trackInventory, @NullableAmountConverter()  String? reorderPoint)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.sku,_that.type,_that.unit,_that.unitPrice,_that.active,_that.description,_that.cost,_that.taxClassification,_that.trackInventory,_that.reorderPoint);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? sku,  ProductType type,  String? unit, @AmountConverter()  String unitPrice,  bool active,  String? description, @NullableAmountConverter()  String? cost,  TaxClassification taxClassification,  bool trackInventory, @NullableAmountConverter()  String? reorderPoint)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.sku,_that.type,_that.unit,_that.unitPrice,_that.active,_that.description,_that.cost,_that.taxClassification,_that.trackInventory,_that.reorderPoint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.name, this.sku, required this.type, this.unit, @AmountConverter() required this.unitPrice, required this.active, this.description, @NullableAmountConverter() this.cost, required this.taxClassification, required this.trackInventory, @NullableAmountConverter() this.reorderPoint});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? sku;
@override final  ProductType type;
@override final  String? unit;
@override@AmountConverter() final  String unitPrice;
@override final  bool active;
@override final  String? description;
/// Reference/standard cost — distinct from the actual moving Weighted
/// Average Cost tracked via stock movements (see
/// `../../inventory/domain/inventory.dart`'s `ProductValuationResponse`).
@override@NullableAmountConverter() final  String? cost;
@override final  TaxClassification taxClassification;
@override final  bool trackInventory;
@override@NullableAmountConverter() final  String? reorderPoint;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.active, active) || other.active == active)&&(identical(other.description, description) || other.description == description)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.taxClassification, taxClassification) || other.taxClassification == taxClassification)&&(identical(other.trackInventory, trackInventory) || other.trackInventory == trackInventory)&&(identical(other.reorderPoint, reorderPoint) || other.reorderPoint == reorderPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sku,type,unit,unitPrice,active,description,cost,taxClassification,trackInventory,reorderPoint);

@override
String toString() {
  return 'Product(id: $id, name: $name, sku: $sku, type: $type, unit: $unit, unitPrice: $unitPrice, active: $active, description: $description, cost: $cost, taxClassification: $taxClassification, trackInventory: $trackInventory, reorderPoint: $reorderPoint)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? sku, ProductType type, String? unit,@AmountConverter() String unitPrice, bool active, String? description,@NullableAmountConverter() String? cost, TaxClassification taxClassification, bool trackInventory,@NullableAmountConverter() String? reorderPoint
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sku = freezed,Object? type = null,Object? unit = freezed,Object? unitPrice = null,Object? active = null,Object? description = freezed,Object? cost = freezed,Object? taxClassification = null,Object? trackInventory = null,Object? reorderPoint = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProductType,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String?,taxClassification: null == taxClassification ? _self.taxClassification : taxClassification // ignore: cast_nullable_to_non_nullable
as TaxClassification,trackInventory: null == trackInventory ? _self.trackInventory : trackInventory // ignore: cast_nullable_to_non_nullable
as bool,reorderPoint: freezed == reorderPoint ? _self.reorderPoint : reorderPoint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
