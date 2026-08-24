// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovementResponse {

 String get id; String get productId; MovementType get type;@AmountConverter() String get quantity;@AmountConverter() String get unitCost;@AmountConverter() String get value; String get occurredOn; String? get notes; String? get sourceInvoiceLineItemId; String get createdByUserId; String get createdAt;
/// Create a copy of MovementResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementResponseCopyWith<MovementResponse> get copyWith => _$MovementResponseCopyWithImpl<MovementResponse>(this as MovementResponse, _$identity);

  /// Serializes this MovementResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovementResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.value, value) || other.value == value)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.sourceInvoiceLineItemId, sourceInvoiceLineItemId) || other.sourceInvoiceLineItemId == sourceInvoiceLineItemId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,type,quantity,unitCost,value,occurredOn,notes,sourceInvoiceLineItemId,createdByUserId,createdAt);

@override
String toString() {
  return 'MovementResponse(id: $id, productId: $productId, type: $type, quantity: $quantity, unitCost: $unitCost, value: $value, occurredOn: $occurredOn, notes: $notes, sourceInvoiceLineItemId: $sourceInvoiceLineItemId, createdByUserId: $createdByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MovementResponseCopyWith<$Res>  {
  factory $MovementResponseCopyWith(MovementResponse value, $Res Function(MovementResponse) _then) = _$MovementResponseCopyWithImpl;
@useResult
$Res call({
 String id, String productId, MovementType type,@AmountConverter() String quantity,@AmountConverter() String unitCost,@AmountConverter() String value, String occurredOn, String? notes, String? sourceInvoiceLineItemId, String createdByUserId, String createdAt
});




}
/// @nodoc
class _$MovementResponseCopyWithImpl<$Res>
    implements $MovementResponseCopyWith<$Res> {
  _$MovementResponseCopyWithImpl(this._self, this._then);

  final MovementResponse _self;
  final $Res Function(MovementResponse) _then;

/// Create a copy of MovementResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? unitCost = null,Object? value = null,Object? occurredOn = null,Object? notes = freezed,Object? sourceInvoiceLineItemId = freezed,Object? createdByUserId = null,Object? createdAt = null,}) {
  return _then(MovementResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sourceInvoiceLineItemId: freezed == sourceInvoiceLineItemId ? _self.sourceInvoiceLineItemId : sourceInvoiceLineItemId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovementResponse].
extension MovementResponsePatterns on MovementResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovementResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovementResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovementResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovementResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovementResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovementResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  MovementType type, @AmountConverter()  String quantity, @AmountConverter()  String unitCost, @AmountConverter()  String value,  String occurredOn,  String? notes,  String? sourceInvoiceLineItemId,  String createdByUserId,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovementResponse() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.unitCost,_that.value,_that.occurredOn,_that.notes,_that.sourceInvoiceLineItemId,_that.createdByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  MovementType type, @AmountConverter()  String quantity, @AmountConverter()  String unitCost, @AmountConverter()  String value,  String occurredOn,  String? notes,  String? sourceInvoiceLineItemId,  String createdByUserId,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _MovementResponse():
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.unitCost,_that.value,_that.occurredOn,_that.notes,_that.sourceInvoiceLineItemId,_that.createdByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  MovementType type, @AmountConverter()  String quantity, @AmountConverter()  String unitCost, @AmountConverter()  String value,  String occurredOn,  String? notes,  String? sourceInvoiceLineItemId,  String createdByUserId,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MovementResponse() when $default != null:
return $default(_that.id,_that.productId,_that.type,_that.quantity,_that.unitCost,_that.value,_that.occurredOn,_that.notes,_that.sourceInvoiceLineItemId,_that.createdByUserId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovementResponse implements MovementResponse {
  const _MovementResponse({required this.id, required this.productId, required this.type, @AmountConverter() required this.quantity, @AmountConverter() required this.unitCost, @AmountConverter() required this.value, required this.occurredOn, this.notes, this.sourceInvoiceLineItemId, required this.createdByUserId, required this.createdAt});
  factory _MovementResponse.fromJson(Map<String, dynamic> json) => _$MovementResponseFromJson(json);

@override final  String id;
@override final  String productId;
@override final  MovementType type;
@override@AmountConverter() final  String quantity;
@override@AmountConverter() final  String unitCost;
@override@AmountConverter() final  String value;
@override final  String occurredOn;
@override final  String? notes;
@override final  String? sourceInvoiceLineItemId;
@override final  String createdByUserId;
@override final  String createdAt;

/// Create a copy of MovementResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovementResponseCopyWith<_MovementResponse> get copyWith => __$MovementResponseCopyWithImpl<_MovementResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovementResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovementResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.type, type) || other.type == type)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.value, value) || other.value == value)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.sourceInvoiceLineItemId, sourceInvoiceLineItemId) || other.sourceInvoiceLineItemId == sourceInvoiceLineItemId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,type,quantity,unitCost,value,occurredOn,notes,sourceInvoiceLineItemId,createdByUserId,createdAt);

@override
String toString() {
  return 'MovementResponse(id: $id, productId: $productId, type: $type, quantity: $quantity, unitCost: $unitCost, value: $value, occurredOn: $occurredOn, notes: $notes, sourceInvoiceLineItemId: $sourceInvoiceLineItemId, createdByUserId: $createdByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MovementResponseCopyWith<$Res> implements $MovementResponseCopyWith<$Res> {
  factory _$MovementResponseCopyWith(_MovementResponse value, $Res Function(_MovementResponse) _then) = __$MovementResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, MovementType type,@AmountConverter() String quantity,@AmountConverter() String unitCost,@AmountConverter() String value, String occurredOn, String? notes, String? sourceInvoiceLineItemId, String createdByUserId, String createdAt
});




}
/// @nodoc
class __$MovementResponseCopyWithImpl<$Res>
    implements _$MovementResponseCopyWith<$Res> {
  __$MovementResponseCopyWithImpl(this._self, this._then);

  final _MovementResponse _self;
  final $Res Function(_MovementResponse) _then;

/// Create a copy of MovementResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? type = null,Object? quantity = null,Object? unitCost = null,Object? value = null,Object? occurredOn = null,Object? notes = freezed,Object? sourceInvoiceLineItemId = freezed,Object? createdByUserId = null,Object? createdAt = null,}) {
  return _then(_MovementResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MovementType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sourceInvoiceLineItemId: freezed == sourceInvoiceLineItemId ? _self.sourceInvoiceLineItemId : sourceInvoiceLineItemId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProductValuationResponse {

 String get productId;@AmountConverter() String get quantityOnHand;@AmountConverter() String get weightedAverageCost;@AmountConverter() String get totalValue;
/// Create a copy of ProductValuationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductValuationResponseCopyWith<ProductValuationResponse> get copyWith => _$ProductValuationResponseCopyWithImpl<ProductValuationResponse>(this as ProductValuationResponse, _$identity);

  /// Serializes this ProductValuationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductValuationResponse&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantityOnHand, quantityOnHand) || other.quantityOnHand == quantityOnHand)&&(identical(other.weightedAverageCost, weightedAverageCost) || other.weightedAverageCost == weightedAverageCost)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,quantityOnHand,weightedAverageCost,totalValue);

@override
String toString() {
  return 'ProductValuationResponse(productId: $productId, quantityOnHand: $quantityOnHand, weightedAverageCost: $weightedAverageCost, totalValue: $totalValue)';
}


}

/// @nodoc
abstract mixin class $ProductValuationResponseCopyWith<$Res>  {
  factory $ProductValuationResponseCopyWith(ProductValuationResponse value, $Res Function(ProductValuationResponse) _then) = _$ProductValuationResponseCopyWithImpl;
@useResult
$Res call({
 String productId,@AmountConverter() String quantityOnHand,@AmountConverter() String weightedAverageCost,@AmountConverter() String totalValue
});




}
/// @nodoc
class _$ProductValuationResponseCopyWithImpl<$Res>
    implements $ProductValuationResponseCopyWith<$Res> {
  _$ProductValuationResponseCopyWithImpl(this._self, this._then);

  final ProductValuationResponse _self;
  final $Res Function(ProductValuationResponse) _then;

/// Create a copy of ProductValuationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? quantityOnHand = null,Object? weightedAverageCost = null,Object? totalValue = null,}) {
  return _then(ProductValuationResponse(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantityOnHand: null == quantityOnHand ? _self.quantityOnHand : quantityOnHand // ignore: cast_nullable_to_non_nullable
as String,weightedAverageCost: null == weightedAverageCost ? _self.weightedAverageCost : weightedAverageCost // ignore: cast_nullable_to_non_nullable
as String,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductValuationResponse].
extension ProductValuationResponsePatterns on ProductValuationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductValuationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductValuationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductValuationResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProductValuationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductValuationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProductValuationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId, @AmountConverter()  String quantityOnHand, @AmountConverter()  String weightedAverageCost, @AmountConverter()  String totalValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductValuationResponse() when $default != null:
return $default(_that.productId,_that.quantityOnHand,_that.weightedAverageCost,_that.totalValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId, @AmountConverter()  String quantityOnHand, @AmountConverter()  String weightedAverageCost, @AmountConverter()  String totalValue)  $default,) {final _that = this;
switch (_that) {
case _ProductValuationResponse():
return $default(_that.productId,_that.quantityOnHand,_that.weightedAverageCost,_that.totalValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId, @AmountConverter()  String quantityOnHand, @AmountConverter()  String weightedAverageCost, @AmountConverter()  String totalValue)?  $default,) {final _that = this;
switch (_that) {
case _ProductValuationResponse() when $default != null:
return $default(_that.productId,_that.quantityOnHand,_that.weightedAverageCost,_that.totalValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductValuationResponse implements ProductValuationResponse {
  const _ProductValuationResponse({required this.productId, @AmountConverter() required this.quantityOnHand, @AmountConverter() required this.weightedAverageCost, @AmountConverter() required this.totalValue});
  factory _ProductValuationResponse.fromJson(Map<String, dynamic> json) => _$ProductValuationResponseFromJson(json);

@override final  String productId;
@override@AmountConverter() final  String quantityOnHand;
@override@AmountConverter() final  String weightedAverageCost;
@override@AmountConverter() final  String totalValue;

/// Create a copy of ProductValuationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductValuationResponseCopyWith<_ProductValuationResponse> get copyWith => __$ProductValuationResponseCopyWithImpl<_ProductValuationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductValuationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductValuationResponse&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantityOnHand, quantityOnHand) || other.quantityOnHand == quantityOnHand)&&(identical(other.weightedAverageCost, weightedAverageCost) || other.weightedAverageCost == weightedAverageCost)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,quantityOnHand,weightedAverageCost,totalValue);

@override
String toString() {
  return 'ProductValuationResponse(productId: $productId, quantityOnHand: $quantityOnHand, weightedAverageCost: $weightedAverageCost, totalValue: $totalValue)';
}


}

/// @nodoc
abstract mixin class _$ProductValuationResponseCopyWith<$Res> implements $ProductValuationResponseCopyWith<$Res> {
  factory _$ProductValuationResponseCopyWith(_ProductValuationResponse value, $Res Function(_ProductValuationResponse) _then) = __$ProductValuationResponseCopyWithImpl;
@override @useResult
$Res call({
 String productId,@AmountConverter() String quantityOnHand,@AmountConverter() String weightedAverageCost,@AmountConverter() String totalValue
});




}
/// @nodoc
class __$ProductValuationResponseCopyWithImpl<$Res>
    implements _$ProductValuationResponseCopyWith<$Res> {
  __$ProductValuationResponseCopyWithImpl(this._self, this._then);

  final _ProductValuationResponse _self;
  final $Res Function(_ProductValuationResponse) _then;

/// Create a copy of ProductValuationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantityOnHand = null,Object? weightedAverageCost = null,Object? totalValue = null,}) {
  return _then(_ProductValuationResponse(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantityOnHand: null == quantityOnHand ? _self.quantityOnHand : quantityOnHand // ignore: cast_nullable_to_non_nullable
as String,weightedAverageCost: null == weightedAverageCost ? _self.weightedAverageCost : weightedAverageCost // ignore: cast_nullable_to_non_nullable
as String,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RecipeItemResponse {

 String get id; String get ingredientProductId; String get ingredientName;@AmountConverter() String get quantityPerUnit;@AmountConverter() String get ingredientUnitCost;@AmountConverter() String get lineCost;
/// Create a copy of RecipeItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeItemResponseCopyWith<RecipeItemResponse> get copyWith => _$RecipeItemResponseCopyWithImpl<RecipeItemResponse>(this as RecipeItemResponse, _$identity);

  /// Serializes this RecipeItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.ingredientProductId, ingredientProductId) || other.ingredientProductId == ingredientProductId)&&(identical(other.ingredientName, ingredientName) || other.ingredientName == ingredientName)&&(identical(other.quantityPerUnit, quantityPerUnit) || other.quantityPerUnit == quantityPerUnit)&&(identical(other.ingredientUnitCost, ingredientUnitCost) || other.ingredientUnitCost == ingredientUnitCost)&&(identical(other.lineCost, lineCost) || other.lineCost == lineCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ingredientProductId,ingredientName,quantityPerUnit,ingredientUnitCost,lineCost);

@override
String toString() {
  return 'RecipeItemResponse(id: $id, ingredientProductId: $ingredientProductId, ingredientName: $ingredientName, quantityPerUnit: $quantityPerUnit, ingredientUnitCost: $ingredientUnitCost, lineCost: $lineCost)';
}


}

/// @nodoc
abstract mixin class $RecipeItemResponseCopyWith<$Res>  {
  factory $RecipeItemResponseCopyWith(RecipeItemResponse value, $Res Function(RecipeItemResponse) _then) = _$RecipeItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String ingredientProductId, String ingredientName,@AmountConverter() String quantityPerUnit,@AmountConverter() String ingredientUnitCost,@AmountConverter() String lineCost
});




}
/// @nodoc
class _$RecipeItemResponseCopyWithImpl<$Res>
    implements $RecipeItemResponseCopyWith<$Res> {
  _$RecipeItemResponseCopyWithImpl(this._self, this._then);

  final RecipeItemResponse _self;
  final $Res Function(RecipeItemResponse) _then;

/// Create a copy of RecipeItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ingredientProductId = null,Object? ingredientName = null,Object? quantityPerUnit = null,Object? ingredientUnitCost = null,Object? lineCost = null,}) {
  return _then(RecipeItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ingredientProductId: null == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String,ingredientName: null == ingredientName ? _self.ingredientName : ingredientName // ignore: cast_nullable_to_non_nullable
as String,quantityPerUnit: null == quantityPerUnit ? _self.quantityPerUnit : quantityPerUnit // ignore: cast_nullable_to_non_nullable
as String,ingredientUnitCost: null == ingredientUnitCost ? _self.ingredientUnitCost : ingredientUnitCost // ignore: cast_nullable_to_non_nullable
as String,lineCost: null == lineCost ? _self.lineCost : lineCost // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeItemResponse].
extension RecipeItemResponsePatterns on RecipeItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecipeItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ingredientProductId,  String ingredientName, @AmountConverter()  String quantityPerUnit, @AmountConverter()  String ingredientUnitCost, @AmountConverter()  String lineCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeItemResponse() when $default != null:
return $default(_that.id,_that.ingredientProductId,_that.ingredientName,_that.quantityPerUnit,_that.ingredientUnitCost,_that.lineCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ingredientProductId,  String ingredientName, @AmountConverter()  String quantityPerUnit, @AmountConverter()  String ingredientUnitCost, @AmountConverter()  String lineCost)  $default,) {final _that = this;
switch (_that) {
case _RecipeItemResponse():
return $default(_that.id,_that.ingredientProductId,_that.ingredientName,_that.quantityPerUnit,_that.ingredientUnitCost,_that.lineCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ingredientProductId,  String ingredientName, @AmountConverter()  String quantityPerUnit, @AmountConverter()  String ingredientUnitCost, @AmountConverter()  String lineCost)?  $default,) {final _that = this;
switch (_that) {
case _RecipeItemResponse() when $default != null:
return $default(_that.id,_that.ingredientProductId,_that.ingredientName,_that.quantityPerUnit,_that.ingredientUnitCost,_that.lineCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeItemResponse implements RecipeItemResponse {
  const _RecipeItemResponse({required this.id, required this.ingredientProductId, required this.ingredientName, @AmountConverter() required this.quantityPerUnit, @AmountConverter() required this.ingredientUnitCost, @AmountConverter() required this.lineCost});
  factory _RecipeItemResponse.fromJson(Map<String, dynamic> json) => _$RecipeItemResponseFromJson(json);

@override final  String id;
@override final  String ingredientProductId;
@override final  String ingredientName;
@override@AmountConverter() final  String quantityPerUnit;
@override@AmountConverter() final  String ingredientUnitCost;
@override@AmountConverter() final  String lineCost;

/// Create a copy of RecipeItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeItemResponseCopyWith<_RecipeItemResponse> get copyWith => __$RecipeItemResponseCopyWithImpl<_RecipeItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.ingredientProductId, ingredientProductId) || other.ingredientProductId == ingredientProductId)&&(identical(other.ingredientName, ingredientName) || other.ingredientName == ingredientName)&&(identical(other.quantityPerUnit, quantityPerUnit) || other.quantityPerUnit == quantityPerUnit)&&(identical(other.ingredientUnitCost, ingredientUnitCost) || other.ingredientUnitCost == ingredientUnitCost)&&(identical(other.lineCost, lineCost) || other.lineCost == lineCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ingredientProductId,ingredientName,quantityPerUnit,ingredientUnitCost,lineCost);

@override
String toString() {
  return 'RecipeItemResponse(id: $id, ingredientProductId: $ingredientProductId, ingredientName: $ingredientName, quantityPerUnit: $quantityPerUnit, ingredientUnitCost: $ingredientUnitCost, lineCost: $lineCost)';
}


}

/// @nodoc
abstract mixin class _$RecipeItemResponseCopyWith<$Res> implements $RecipeItemResponseCopyWith<$Res> {
  factory _$RecipeItemResponseCopyWith(_RecipeItemResponse value, $Res Function(_RecipeItemResponse) _then) = __$RecipeItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String ingredientProductId, String ingredientName,@AmountConverter() String quantityPerUnit,@AmountConverter() String ingredientUnitCost,@AmountConverter() String lineCost
});




}
/// @nodoc
class __$RecipeItemResponseCopyWithImpl<$Res>
    implements _$RecipeItemResponseCopyWith<$Res> {
  __$RecipeItemResponseCopyWithImpl(this._self, this._then);

  final _RecipeItemResponse _self;
  final $Res Function(_RecipeItemResponse) _then;

/// Create a copy of RecipeItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ingredientProductId = null,Object? ingredientName = null,Object? quantityPerUnit = null,Object? ingredientUnitCost = null,Object? lineCost = null,}) {
  return _then(_RecipeItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ingredientProductId: null == ingredientProductId ? _self.ingredientProductId : ingredientProductId // ignore: cast_nullable_to_non_nullable
as String,ingredientName: null == ingredientName ? _self.ingredientName : ingredientName // ignore: cast_nullable_to_non_nullable
as String,quantityPerUnit: null == quantityPerUnit ? _self.quantityPerUnit : quantityPerUnit // ignore: cast_nullable_to_non_nullable
as String,ingredientUnitCost: null == ingredientUnitCost ? _self.ingredientUnitCost : ingredientUnitCost // ignore: cast_nullable_to_non_nullable
as String,lineCost: null == lineCost ? _self.lineCost : lineCost // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RecipeCostResponse {

 String get productId; List<RecipeItemResponse> get items;@AmountConverter() String get unitCost;@AmountConverter() String get sellingPrice;@AmountConverter() String get grossMargin;@AmountConverter() String get grossMarginPercent;
/// Create a copy of RecipeCostResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCostResponseCopyWith<RecipeCostResponse> get copyWith => _$RecipeCostResponseCopyWithImpl<RecipeCostResponse>(this as RecipeCostResponse, _$identity);

  /// Serializes this RecipeCostResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeCostResponse&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.grossMargin, grossMargin) || other.grossMargin == grossMargin)&&(identical(other.grossMarginPercent, grossMarginPercent) || other.grossMarginPercent == grossMarginPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,const DeepCollectionEquality().hash(items),unitCost,sellingPrice,grossMargin,grossMarginPercent);

@override
String toString() {
  return 'RecipeCostResponse(productId: $productId, items: $items, unitCost: $unitCost, sellingPrice: $sellingPrice, grossMargin: $grossMargin, grossMarginPercent: $grossMarginPercent)';
}


}

/// @nodoc
abstract mixin class $RecipeCostResponseCopyWith<$Res>  {
  factory $RecipeCostResponseCopyWith(RecipeCostResponse value, $Res Function(RecipeCostResponse) _then) = _$RecipeCostResponseCopyWithImpl;
@useResult
$Res call({
 String productId, List<RecipeItemResponse> items,@AmountConverter() String unitCost,@AmountConverter() String sellingPrice,@AmountConverter() String grossMargin,@AmountConverter() String grossMarginPercent
});




}
/// @nodoc
class _$RecipeCostResponseCopyWithImpl<$Res>
    implements $RecipeCostResponseCopyWith<$Res> {
  _$RecipeCostResponseCopyWithImpl(this._self, this._then);

  final RecipeCostResponse _self;
  final $Res Function(RecipeCostResponse) _then;

/// Create a copy of RecipeCostResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? items = null,Object? unitCost = null,Object? sellingPrice = null,Object? grossMargin = null,Object? grossMarginPercent = null,}) {
  return _then(RecipeCostResponse(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RecipeItemResponse>,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as String,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as String,grossMargin: null == grossMargin ? _self.grossMargin : grossMargin // ignore: cast_nullable_to_non_nullable
as String,grossMarginPercent: null == grossMarginPercent ? _self.grossMarginPercent : grossMarginPercent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeCostResponse].
extension RecipeCostResponsePatterns on RecipeCostResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeCostResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeCostResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeCostResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecipeCostResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeCostResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeCostResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  List<RecipeItemResponse> items, @AmountConverter()  String unitCost, @AmountConverter()  String sellingPrice, @AmountConverter()  String grossMargin, @AmountConverter()  String grossMarginPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeCostResponse() when $default != null:
return $default(_that.productId,_that.items,_that.unitCost,_that.sellingPrice,_that.grossMargin,_that.grossMarginPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  List<RecipeItemResponse> items, @AmountConverter()  String unitCost, @AmountConverter()  String sellingPrice, @AmountConverter()  String grossMargin, @AmountConverter()  String grossMarginPercent)  $default,) {final _that = this;
switch (_that) {
case _RecipeCostResponse():
return $default(_that.productId,_that.items,_that.unitCost,_that.sellingPrice,_that.grossMargin,_that.grossMarginPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  List<RecipeItemResponse> items, @AmountConverter()  String unitCost, @AmountConverter()  String sellingPrice, @AmountConverter()  String grossMargin, @AmountConverter()  String grossMarginPercent)?  $default,) {final _that = this;
switch (_that) {
case _RecipeCostResponse() when $default != null:
return $default(_that.productId,_that.items,_that.unitCost,_that.sellingPrice,_that.grossMargin,_that.grossMarginPercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeCostResponse implements RecipeCostResponse {
  const _RecipeCostResponse({required this.productId, required  List<RecipeItemResponse> items, @AmountConverter() required this.unitCost, @AmountConverter() required this.sellingPrice, @AmountConverter() required this.grossMargin, @AmountConverter() required this.grossMarginPercent}): _items = items;
  factory _RecipeCostResponse.fromJson(Map<String, dynamic> json) => _$RecipeCostResponseFromJson(json);

@override final  String productId;
 final  List<RecipeItemResponse> _items;
@override List<RecipeItemResponse> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@AmountConverter() final  String unitCost;
@override@AmountConverter() final  String sellingPrice;
@override@AmountConverter() final  String grossMargin;
@override@AmountConverter() final  String grossMarginPercent;

/// Create a copy of RecipeCostResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCostResponseCopyWith<_RecipeCostResponse> get copyWith => __$RecipeCostResponseCopyWithImpl<_RecipeCostResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeCostResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeCostResponse&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.unitCost, unitCost) || other.unitCost == unitCost)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.grossMargin, grossMargin) || other.grossMargin == grossMargin)&&(identical(other.grossMarginPercent, grossMarginPercent) || other.grossMarginPercent == grossMarginPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,const DeepCollectionEquality().hash(_items),unitCost,sellingPrice,grossMargin,grossMarginPercent);

@override
String toString() {
  return 'RecipeCostResponse(productId: $productId, items: $items, unitCost: $unitCost, sellingPrice: $sellingPrice, grossMargin: $grossMargin, grossMarginPercent: $grossMarginPercent)';
}


}

/// @nodoc
abstract mixin class _$RecipeCostResponseCopyWith<$Res> implements $RecipeCostResponseCopyWith<$Res> {
  factory _$RecipeCostResponseCopyWith(_RecipeCostResponse value, $Res Function(_RecipeCostResponse) _then) = __$RecipeCostResponseCopyWithImpl;
@override @useResult
$Res call({
 String productId, List<RecipeItemResponse> items,@AmountConverter() String unitCost,@AmountConverter() String sellingPrice,@AmountConverter() String grossMargin,@AmountConverter() String grossMarginPercent
});




}
/// @nodoc
class __$RecipeCostResponseCopyWithImpl<$Res>
    implements _$RecipeCostResponseCopyWith<$Res> {
  __$RecipeCostResponseCopyWithImpl(this._self, this._then);

  final _RecipeCostResponse _self;
  final $Res Function(_RecipeCostResponse) _then;

/// Create a copy of RecipeCostResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? items = null,Object? unitCost = null,Object? sellingPrice = null,Object? grossMargin = null,Object? grossMarginPercent = null,}) {
  return _then(_RecipeCostResponse(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RecipeItemResponse>,unitCost: null == unitCost ? _self.unitCost : unitCost // ignore: cast_nullable_to_non_nullable
as String,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as String,grossMargin: null == grossMargin ? _self.grossMargin : grossMargin // ignore: cast_nullable_to_non_nullable
as String,grossMarginPercent: null == grossMarginPercent ? _self.grossMarginPercent : grossMarginPercent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StockValuationRow {

 String get productId; String get productName; String? get sku;@AmountConverter() String get quantityOnHand;@AmountConverter() String get weightedAverageCost;@AmountConverter() String get totalValue;
/// Create a copy of StockValuationRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockValuationRowCopyWith<StockValuationRow> get copyWith => _$StockValuationRowCopyWithImpl<StockValuationRow>(this as StockValuationRow, _$identity);

  /// Serializes this StockValuationRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockValuationRow&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.quantityOnHand, quantityOnHand) || other.quantityOnHand == quantityOnHand)&&(identical(other.weightedAverageCost, weightedAverageCost) || other.weightedAverageCost == weightedAverageCost)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,sku,quantityOnHand,weightedAverageCost,totalValue);

@override
String toString() {
  return 'StockValuationRow(productId: $productId, productName: $productName, sku: $sku, quantityOnHand: $quantityOnHand, weightedAverageCost: $weightedAverageCost, totalValue: $totalValue)';
}


}

/// @nodoc
abstract mixin class $StockValuationRowCopyWith<$Res>  {
  factory $StockValuationRowCopyWith(StockValuationRow value, $Res Function(StockValuationRow) _then) = _$StockValuationRowCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String? sku,@AmountConverter() String quantityOnHand,@AmountConverter() String weightedAverageCost,@AmountConverter() String totalValue
});




}
/// @nodoc
class _$StockValuationRowCopyWithImpl<$Res>
    implements $StockValuationRowCopyWith<$Res> {
  _$StockValuationRowCopyWithImpl(this._self, this._then);

  final StockValuationRow _self;
  final $Res Function(StockValuationRow) _then;

/// Create a copy of StockValuationRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? sku = freezed,Object? quantityOnHand = null,Object? weightedAverageCost = null,Object? totalValue = null,}) {
  return _then(StockValuationRow(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,quantityOnHand: null == quantityOnHand ? _self.quantityOnHand : quantityOnHand // ignore: cast_nullable_to_non_nullable
as String,weightedAverageCost: null == weightedAverageCost ? _self.weightedAverageCost : weightedAverageCost // ignore: cast_nullable_to_non_nullable
as String,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StockValuationRow].
extension StockValuationRowPatterns on StockValuationRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockValuationRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockValuationRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockValuationRow value)  $default,){
final _that = this;
switch (_that) {
case _StockValuationRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockValuationRow value)?  $default,){
final _that = this;
switch (_that) {
case _StockValuationRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String? sku, @AmountConverter()  String quantityOnHand, @AmountConverter()  String weightedAverageCost, @AmountConverter()  String totalValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockValuationRow() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.quantityOnHand,_that.weightedAverageCost,_that.totalValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String? sku, @AmountConverter()  String quantityOnHand, @AmountConverter()  String weightedAverageCost, @AmountConverter()  String totalValue)  $default,) {final _that = this;
switch (_that) {
case _StockValuationRow():
return $default(_that.productId,_that.productName,_that.sku,_that.quantityOnHand,_that.weightedAverageCost,_that.totalValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String? sku, @AmountConverter()  String quantityOnHand, @AmountConverter()  String weightedAverageCost, @AmountConverter()  String totalValue)?  $default,) {final _that = this;
switch (_that) {
case _StockValuationRow() when $default != null:
return $default(_that.productId,_that.productName,_that.sku,_that.quantityOnHand,_that.weightedAverageCost,_that.totalValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockValuationRow implements StockValuationRow {
  const _StockValuationRow({required this.productId, required this.productName, this.sku, @AmountConverter() required this.quantityOnHand, @AmountConverter() required this.weightedAverageCost, @AmountConverter() required this.totalValue});
  factory _StockValuationRow.fromJson(Map<String, dynamic> json) => _$StockValuationRowFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  String? sku;
@override@AmountConverter() final  String quantityOnHand;
@override@AmountConverter() final  String weightedAverageCost;
@override@AmountConverter() final  String totalValue;

/// Create a copy of StockValuationRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockValuationRowCopyWith<_StockValuationRow> get copyWith => __$StockValuationRowCopyWithImpl<_StockValuationRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockValuationRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockValuationRow&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.quantityOnHand, quantityOnHand) || other.quantityOnHand == quantityOnHand)&&(identical(other.weightedAverageCost, weightedAverageCost) || other.weightedAverageCost == weightedAverageCost)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,sku,quantityOnHand,weightedAverageCost,totalValue);

@override
String toString() {
  return 'StockValuationRow(productId: $productId, productName: $productName, sku: $sku, quantityOnHand: $quantityOnHand, weightedAverageCost: $weightedAverageCost, totalValue: $totalValue)';
}


}

/// @nodoc
abstract mixin class _$StockValuationRowCopyWith<$Res> implements $StockValuationRowCopyWith<$Res> {
  factory _$StockValuationRowCopyWith(_StockValuationRow value, $Res Function(_StockValuationRow) _then) = __$StockValuationRowCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String? sku,@AmountConverter() String quantityOnHand,@AmountConverter() String weightedAverageCost,@AmountConverter() String totalValue
});




}
/// @nodoc
class __$StockValuationRowCopyWithImpl<$Res>
    implements _$StockValuationRowCopyWith<$Res> {
  __$StockValuationRowCopyWithImpl(this._self, this._then);

  final _StockValuationRow _self;
  final $Res Function(_StockValuationRow) _then;

/// Create a copy of StockValuationRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? sku = freezed,Object? quantityOnHand = null,Object? weightedAverageCost = null,Object? totalValue = null,}) {
  return _then(_StockValuationRow(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,quantityOnHand: null == quantityOnHand ? _self.quantityOnHand : quantityOnHand // ignore: cast_nullable_to_non_nullable
as String,weightedAverageCost: null == weightedAverageCost ? _self.weightedAverageCost : weightedAverageCost // ignore: cast_nullable_to_non_nullable
as String,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CogsReport {

 String get from; String get to;@AmountConverter() String get totalCogs;
/// Create a copy of CogsReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CogsReportCopyWith<CogsReport> get copyWith => _$CogsReportCopyWithImpl<CogsReport>(this as CogsReport, _$identity);

  /// Serializes this CogsReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CogsReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalCogs, totalCogs) || other.totalCogs == totalCogs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,totalCogs);

@override
String toString() {
  return 'CogsReport(from: $from, to: $to, totalCogs: $totalCogs)';
}


}

/// @nodoc
abstract mixin class $CogsReportCopyWith<$Res>  {
  factory $CogsReportCopyWith(CogsReport value, $Res Function(CogsReport) _then) = _$CogsReportCopyWithImpl;
@useResult
$Res call({
 String from, String to,@AmountConverter() String totalCogs
});




}
/// @nodoc
class _$CogsReportCopyWithImpl<$Res>
    implements $CogsReportCopyWith<$Res> {
  _$CogsReportCopyWithImpl(this._self, this._then);

  final CogsReport _self;
  final $Res Function(CogsReport) _then;

/// Create a copy of CogsReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? totalCogs = null,}) {
  return _then(CogsReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,totalCogs: null == totalCogs ? _self.totalCogs : totalCogs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CogsReport].
extension CogsReportPatterns on CogsReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CogsReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CogsReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CogsReport value)  $default,){
final _that = this;
switch (_that) {
case _CogsReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CogsReport value)?  $default,){
final _that = this;
switch (_that) {
case _CogsReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to, @AmountConverter()  String totalCogs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CogsReport() when $default != null:
return $default(_that.from,_that.to,_that.totalCogs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to, @AmountConverter()  String totalCogs)  $default,) {final _that = this;
switch (_that) {
case _CogsReport():
return $default(_that.from,_that.to,_that.totalCogs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to, @AmountConverter()  String totalCogs)?  $default,) {final _that = this;
switch (_that) {
case _CogsReport() when $default != null:
return $default(_that.from,_that.to,_that.totalCogs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CogsReport implements CogsReport {
  const _CogsReport({required this.from, required this.to, @AmountConverter() required this.totalCogs});
  factory _CogsReport.fromJson(Map<String, dynamic> json) => _$CogsReportFromJson(json);

@override final  String from;
@override final  String to;
@override@AmountConverter() final  String totalCogs;

/// Create a copy of CogsReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CogsReportCopyWith<_CogsReport> get copyWith => __$CogsReportCopyWithImpl<_CogsReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CogsReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CogsReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalCogs, totalCogs) || other.totalCogs == totalCogs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,totalCogs);

@override
String toString() {
  return 'CogsReport(from: $from, to: $to, totalCogs: $totalCogs)';
}


}

/// @nodoc
abstract mixin class _$CogsReportCopyWith<$Res> implements $CogsReportCopyWith<$Res> {
  factory _$CogsReportCopyWith(_CogsReport value, $Res Function(_CogsReport) _then) = __$CogsReportCopyWithImpl;
@override @useResult
$Res call({
 String from, String to,@AmountConverter() String totalCogs
});




}
/// @nodoc
class __$CogsReportCopyWithImpl<$Res>
    implements _$CogsReportCopyWith<$Res> {
  __$CogsReportCopyWithImpl(this._self, this._then);

  final _CogsReport _self;
  final $Res Function(_CogsReport) _then;

/// Create a copy of CogsReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? totalCogs = null,}) {
  return _then(_CogsReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,totalCogs: null == totalCogs ? _self.totalCogs : totalCogs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
