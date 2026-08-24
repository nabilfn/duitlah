// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bill {

 String get id; String get ownerUserId; String? get groupId; String? get merchant; String get receiptDate; String get currency;@AmountConverter() String get tax; AllocationStrategy get taxStrategy;@AmountConverter() String get serviceCharge; AllocationStrategy get serviceStrategy;@AmountConverter() String get discount; String? get discountLabel;@NullableAmountConverter() String? get declaredTotal;@NullableAmountConverter() String? get total;@NullableAmountConverter() String? get roundingAdjustment; BillStatus get status; String? get finalizedAt;
/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillCopyWith<Bill> get copyWith => _$BillCopyWithImpl<Bill>(this as Bill, _$identity);

  /// Serializes this Bill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bill&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.receiptDate, receiptDate) || other.receiptDate == receiptDate)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.taxStrategy, taxStrategy) || other.taxStrategy == taxStrategy)&&(identical(other.serviceCharge, serviceCharge) || other.serviceCharge == serviceCharge)&&(identical(other.serviceStrategy, serviceStrategy) || other.serviceStrategy == serviceStrategy)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountLabel, discountLabel) || other.discountLabel == discountLabel)&&(identical(other.declaredTotal, declaredTotal) || other.declaredTotal == declaredTotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.roundingAdjustment, roundingAdjustment) || other.roundingAdjustment == roundingAdjustment)&&(identical(other.status, status) || other.status == status)&&(identical(other.finalizedAt, finalizedAt) || other.finalizedAt == finalizedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,groupId,merchant,receiptDate,currency,tax,taxStrategy,serviceCharge,serviceStrategy,discount,discountLabel,declaredTotal,total,roundingAdjustment,status,finalizedAt);

@override
String toString() {
  return 'Bill(id: $id, ownerUserId: $ownerUserId, groupId: $groupId, merchant: $merchant, receiptDate: $receiptDate, currency: $currency, tax: $tax, taxStrategy: $taxStrategy, serviceCharge: $serviceCharge, serviceStrategy: $serviceStrategy, discount: $discount, discountLabel: $discountLabel, declaredTotal: $declaredTotal, total: $total, roundingAdjustment: $roundingAdjustment, status: $status, finalizedAt: $finalizedAt)';
}


}

/// @nodoc
abstract mixin class $BillCopyWith<$Res>  {
  factory $BillCopyWith(Bill value, $Res Function(Bill) _then) = _$BillCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, String? groupId, String? merchant, String receiptDate, String currency,@AmountConverter() String tax, AllocationStrategy taxStrategy,@AmountConverter() String serviceCharge, AllocationStrategy serviceStrategy,@AmountConverter() String discount, String? discountLabel,@NullableAmountConverter() String? declaredTotal,@NullableAmountConverter() String? total,@NullableAmountConverter() String? roundingAdjustment, BillStatus status, String? finalizedAt
});




}
/// @nodoc
class _$BillCopyWithImpl<$Res>
    implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._self, this._then);

  final Bill _self;
  final $Res Function(Bill) _then;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? groupId = freezed,Object? merchant = freezed,Object? receiptDate = null,Object? currency = null,Object? tax = null,Object? taxStrategy = null,Object? serviceCharge = null,Object? serviceStrategy = null,Object? discount = null,Object? discountLabel = freezed,Object? declaredTotal = freezed,Object? total = freezed,Object? roundingAdjustment = freezed,Object? status = null,Object? finalizedAt = freezed,}) {
  return _then(Bill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptDate: null == receiptDate ? _self.receiptDate : receiptDate // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as String,taxStrategy: null == taxStrategy ? _self.taxStrategy : taxStrategy // ignore: cast_nullable_to_non_nullable
as AllocationStrategy,serviceCharge: null == serviceCharge ? _self.serviceCharge : serviceCharge // ignore: cast_nullable_to_non_nullable
as String,serviceStrategy: null == serviceStrategy ? _self.serviceStrategy : serviceStrategy // ignore: cast_nullable_to_non_nullable
as AllocationStrategy,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as String,discountLabel: freezed == discountLabel ? _self.discountLabel : discountLabel // ignore: cast_nullable_to_non_nullable
as String?,declaredTotal: freezed == declaredTotal ? _self.declaredTotal : declaredTotal // ignore: cast_nullable_to_non_nullable
as String?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String?,roundingAdjustment: freezed == roundingAdjustment ? _self.roundingAdjustment : roundingAdjustment // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BillStatus,finalizedAt: freezed == finalizedAt ? _self.finalizedAt : finalizedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Bill].
extension BillPatterns on Bill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bill value)  $default,){
final _that = this;
switch (_that) {
case _Bill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bill value)?  $default,){
final _that = this;
switch (_that) {
case _Bill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String? groupId,  String? merchant,  String receiptDate,  String currency, @AmountConverter()  String tax,  AllocationStrategy taxStrategy, @AmountConverter()  String serviceCharge,  AllocationStrategy serviceStrategy, @AmountConverter()  String discount,  String? discountLabel, @NullableAmountConverter()  String? declaredTotal, @NullableAmountConverter()  String? total, @NullableAmountConverter()  String? roundingAdjustment,  BillStatus status,  String? finalizedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.groupId,_that.merchant,_that.receiptDate,_that.currency,_that.tax,_that.taxStrategy,_that.serviceCharge,_that.serviceStrategy,_that.discount,_that.discountLabel,_that.declaredTotal,_that.total,_that.roundingAdjustment,_that.status,_that.finalizedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  String? groupId,  String? merchant,  String receiptDate,  String currency, @AmountConverter()  String tax,  AllocationStrategy taxStrategy, @AmountConverter()  String serviceCharge,  AllocationStrategy serviceStrategy, @AmountConverter()  String discount,  String? discountLabel, @NullableAmountConverter()  String? declaredTotal, @NullableAmountConverter()  String? total, @NullableAmountConverter()  String? roundingAdjustment,  BillStatus status,  String? finalizedAt)  $default,) {final _that = this;
switch (_that) {
case _Bill():
return $default(_that.id,_that.ownerUserId,_that.groupId,_that.merchant,_that.receiptDate,_that.currency,_that.tax,_that.taxStrategy,_that.serviceCharge,_that.serviceStrategy,_that.discount,_that.discountLabel,_that.declaredTotal,_that.total,_that.roundingAdjustment,_that.status,_that.finalizedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  String? groupId,  String? merchant,  String receiptDate,  String currency, @AmountConverter()  String tax,  AllocationStrategy taxStrategy, @AmountConverter()  String serviceCharge,  AllocationStrategy serviceStrategy, @AmountConverter()  String discount,  String? discountLabel, @NullableAmountConverter()  String? declaredTotal, @NullableAmountConverter()  String? total, @NullableAmountConverter()  String? roundingAdjustment,  BillStatus status,  String? finalizedAt)?  $default,) {final _that = this;
switch (_that) {
case _Bill() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.groupId,_that.merchant,_that.receiptDate,_that.currency,_that.tax,_that.taxStrategy,_that.serviceCharge,_that.serviceStrategy,_that.discount,_that.discountLabel,_that.declaredTotal,_that.total,_that.roundingAdjustment,_that.status,_that.finalizedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bill implements Bill {
  const _Bill({required this.id, required this.ownerUserId, this.groupId, this.merchant, required this.receiptDate, required this.currency, @AmountConverter() required this.tax, required this.taxStrategy, @AmountConverter() required this.serviceCharge, required this.serviceStrategy, @AmountConverter() required this.discount, this.discountLabel, @NullableAmountConverter() this.declaredTotal, @NullableAmountConverter() this.total, @NullableAmountConverter() this.roundingAdjustment, required this.status, this.finalizedAt});
  factory _Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

@override final  String id;
@override final  String ownerUserId;
@override final  String? groupId;
@override final  String? merchant;
@override final  String receiptDate;
@override final  String currency;
@override@AmountConverter() final  String tax;
@override final  AllocationStrategy taxStrategy;
@override@AmountConverter() final  String serviceCharge;
@override final  AllocationStrategy serviceStrategy;
@override@AmountConverter() final  String discount;
@override final  String? discountLabel;
@override@NullableAmountConverter() final  String? declaredTotal;
@override@NullableAmountConverter() final  String? total;
@override@NullableAmountConverter() final  String? roundingAdjustment;
@override final  BillStatus status;
@override final  String? finalizedAt;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillCopyWith<_Bill> get copyWith => __$BillCopyWithImpl<_Bill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bill&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.receiptDate, receiptDate) || other.receiptDate == receiptDate)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.taxStrategy, taxStrategy) || other.taxStrategy == taxStrategy)&&(identical(other.serviceCharge, serviceCharge) || other.serviceCharge == serviceCharge)&&(identical(other.serviceStrategy, serviceStrategy) || other.serviceStrategy == serviceStrategy)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountLabel, discountLabel) || other.discountLabel == discountLabel)&&(identical(other.declaredTotal, declaredTotal) || other.declaredTotal == declaredTotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.roundingAdjustment, roundingAdjustment) || other.roundingAdjustment == roundingAdjustment)&&(identical(other.status, status) || other.status == status)&&(identical(other.finalizedAt, finalizedAt) || other.finalizedAt == finalizedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,groupId,merchant,receiptDate,currency,tax,taxStrategy,serviceCharge,serviceStrategy,discount,discountLabel,declaredTotal,total,roundingAdjustment,status,finalizedAt);

@override
String toString() {
  return 'Bill(id: $id, ownerUserId: $ownerUserId, groupId: $groupId, merchant: $merchant, receiptDate: $receiptDate, currency: $currency, tax: $tax, taxStrategy: $taxStrategy, serviceCharge: $serviceCharge, serviceStrategy: $serviceStrategy, discount: $discount, discountLabel: $discountLabel, declaredTotal: $declaredTotal, total: $total, roundingAdjustment: $roundingAdjustment, status: $status, finalizedAt: $finalizedAt)';
}


}

/// @nodoc
abstract mixin class _$BillCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$BillCopyWith(_Bill value, $Res Function(_Bill) _then) = __$BillCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, String? groupId, String? merchant, String receiptDate, String currency,@AmountConverter() String tax, AllocationStrategy taxStrategy,@AmountConverter() String serviceCharge, AllocationStrategy serviceStrategy,@AmountConverter() String discount, String? discountLabel,@NullableAmountConverter() String? declaredTotal,@NullableAmountConverter() String? total,@NullableAmountConverter() String? roundingAdjustment, BillStatus status, String? finalizedAt
});




}
/// @nodoc
class __$BillCopyWithImpl<$Res>
    implements _$BillCopyWith<$Res> {
  __$BillCopyWithImpl(this._self, this._then);

  final _Bill _self;
  final $Res Function(_Bill) _then;

/// Create a copy of Bill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? groupId = freezed,Object? merchant = freezed,Object? receiptDate = null,Object? currency = null,Object? tax = null,Object? taxStrategy = null,Object? serviceCharge = null,Object? serviceStrategy = null,Object? discount = null,Object? discountLabel = freezed,Object? declaredTotal = freezed,Object? total = freezed,Object? roundingAdjustment = freezed,Object? status = null,Object? finalizedAt = freezed,}) {
  return _then(_Bill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptDate: null == receiptDate ? _self.receiptDate : receiptDate // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,tax: null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as String,taxStrategy: null == taxStrategy ? _self.taxStrategy : taxStrategy // ignore: cast_nullable_to_non_nullable
as AllocationStrategy,serviceCharge: null == serviceCharge ? _self.serviceCharge : serviceCharge // ignore: cast_nullable_to_non_nullable
as String,serviceStrategy: null == serviceStrategy ? _self.serviceStrategy : serviceStrategy // ignore: cast_nullable_to_non_nullable
as AllocationStrategy,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as String,discountLabel: freezed == discountLabel ? _self.discountLabel : discountLabel // ignore: cast_nullable_to_non_nullable
as String?,declaredTotal: freezed == declaredTotal ? _self.declaredTotal : declaredTotal // ignore: cast_nullable_to_non_nullable
as String?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String?,roundingAdjustment: freezed == roundingAdjustment ? _self.roundingAdjustment : roundingAdjustment // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BillStatus,finalizedAt: freezed == finalizedAt ? _self.finalizedAt : finalizedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReceiptItem {

 String get id; String get name;@AmountConverter() String get quantity;@AmountConverter() String get unitPrice;@AmountConverter() String get itemDiscount;@AmountConverter() String get totalPrice;
/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemCopyWith<ReceiptItem> get copyWith => _$ReceiptItemCopyWithImpl<ReceiptItem>(this as ReceiptItem, _$identity);

  /// Serializes this ReceiptItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.itemDiscount, itemDiscount) || other.itemDiscount == itemDiscount)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,quantity,unitPrice,itemDiscount,totalPrice);

@override
String toString() {
  return 'ReceiptItem(id: $id, name: $name, quantity: $quantity, unitPrice: $unitPrice, itemDiscount: $itemDiscount, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class $ReceiptItemCopyWith<$Res>  {
  factory $ReceiptItemCopyWith(ReceiptItem value, $Res Function(ReceiptItem) _then) = _$ReceiptItemCopyWithImpl;
@useResult
$Res call({
 String id, String name,@AmountConverter() String quantity,@AmountConverter() String unitPrice,@AmountConverter() String itemDiscount,@AmountConverter() String totalPrice
});




}
/// @nodoc
class _$ReceiptItemCopyWithImpl<$Res>
    implements $ReceiptItemCopyWith<$Res> {
  _$ReceiptItemCopyWithImpl(this._self, this._then);

  final ReceiptItem _self;
  final $Res Function(ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? unitPrice = null,Object? itemDiscount = null,Object? totalPrice = null,}) {
  return _then(ReceiptItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,itemDiscount: null == itemDiscount ? _self.itemDiscount : itemDiscount // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItem].
extension ReceiptItemPatterns on ReceiptItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItem value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice, @AmountConverter()  String itemDiscount, @AmountConverter()  String totalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.unitPrice,_that.itemDiscount,_that.totalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice, @AmountConverter()  String itemDiscount, @AmountConverter()  String totalPrice)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem():
return $default(_that.id,_that.name,_that.quantity,_that.unitPrice,_that.itemDiscount,_that.totalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice, @AmountConverter()  String itemDiscount, @AmountConverter()  String totalPrice)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItem() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.unitPrice,_that.itemDiscount,_that.totalPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptItem implements ReceiptItem {
  const _ReceiptItem({required this.id, required this.name, @AmountConverter() required this.quantity, @AmountConverter() required this.unitPrice, @AmountConverter() required this.itemDiscount, @AmountConverter() required this.totalPrice});
  factory _ReceiptItem.fromJson(Map<String, dynamic> json) => _$ReceiptItemFromJson(json);

@override final  String id;
@override final  String name;
@override@AmountConverter() final  String quantity;
@override@AmountConverter() final  String unitPrice;
@override@AmountConverter() final  String itemDiscount;
@override@AmountConverter() final  String totalPrice;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemCopyWith<_ReceiptItem> get copyWith => __$ReceiptItemCopyWithImpl<_ReceiptItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.itemDiscount, itemDiscount) || other.itemDiscount == itemDiscount)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,quantity,unitPrice,itemDiscount,totalPrice);

@override
String toString() {
  return 'ReceiptItem(id: $id, name: $name, quantity: $quantity, unitPrice: $unitPrice, itemDiscount: $itemDiscount, totalPrice: $totalPrice)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemCopyWith<$Res> implements $ReceiptItemCopyWith<$Res> {
  factory _$ReceiptItemCopyWith(_ReceiptItem value, $Res Function(_ReceiptItem) _then) = __$ReceiptItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@AmountConverter() String quantity,@AmountConverter() String unitPrice,@AmountConverter() String itemDiscount,@AmountConverter() String totalPrice
});




}
/// @nodoc
class __$ReceiptItemCopyWithImpl<$Res>
    implements _$ReceiptItemCopyWith<$Res> {
  __$ReceiptItemCopyWithImpl(this._self, this._then);

  final _ReceiptItem _self;
  final $Res Function(_ReceiptItem) _then;

/// Create a copy of ReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? unitPrice = null,Object? itemDiscount = null,Object? totalPrice = null,}) {
  return _then(_ReceiptItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,itemDiscount: null == itemDiscount ? _self.itemDiscount : itemDiscount // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Participant {

 String get id; String? get userId; String get displayName; bool get guest;
/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantCopyWith<Participant> get copyWith => _$ParticipantCopyWithImpl<Participant>(this as Participant, _$identity);

  /// Serializes this Participant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Participant&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.guest, guest) || other.guest == guest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,displayName,guest);

@override
String toString() {
  return 'Participant(id: $id, userId: $userId, displayName: $displayName, guest: $guest)';
}


}

/// @nodoc
abstract mixin class $ParticipantCopyWith<$Res>  {
  factory $ParticipantCopyWith(Participant value, $Res Function(Participant) _then) = _$ParticipantCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String displayName, bool guest
});




}
/// @nodoc
class _$ParticipantCopyWithImpl<$Res>
    implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._self, this._then);

  final Participant _self;
  final $Res Function(Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? displayName = null,Object? guest = null,}) {
  return _then(Participant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Participant].
extension ParticipantPatterns on Participant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Participant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Participant value)  $default,){
final _that = this;
switch (_that) {
case _Participant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Participant value)?  $default,){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String displayName,  bool guest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.id,_that.userId,_that.displayName,_that.guest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String displayName,  bool guest)  $default,) {final _that = this;
switch (_that) {
case _Participant():
return $default(_that.id,_that.userId,_that.displayName,_that.guest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String displayName,  bool guest)?  $default,) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.id,_that.userId,_that.displayName,_that.guest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Participant implements Participant {
  const _Participant({required this.id, this.userId, required this.displayName, required this.guest});
  factory _Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String displayName;
@override final  bool guest;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantCopyWith<_Participant> get copyWith => __$ParticipantCopyWithImpl<_Participant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Participant&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.guest, guest) || other.guest == guest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,displayName,guest);

@override
String toString() {
  return 'Participant(id: $id, userId: $userId, displayName: $displayName, guest: $guest)';
}


}

/// @nodoc
abstract mixin class _$ParticipantCopyWith<$Res> implements $ParticipantCopyWith<$Res> {
  factory _$ParticipantCopyWith(_Participant value, $Res Function(_Participant) _then) = __$ParticipantCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String displayName, bool guest
});




}
/// @nodoc
class __$ParticipantCopyWithImpl<$Res>
    implements _$ParticipantCopyWith<$Res> {
  __$ParticipantCopyWithImpl(this._self, this._then);

  final _Participant _self;
  final $Res Function(_Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? displayName = null,Object? guest = null,}) {
  return _then(_Participant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Claim {

 String get id; String get participantId; String get displayName; ClaimType get claimType;@AmountConverter() String get value;
/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimCopyWith<Claim> get copyWith => _$ClaimCopyWithImpl<Claim>(this as Claim, _$identity);

  /// Serializes this Claim to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Claim&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.claimType, claimType) || other.claimType == claimType)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,displayName,claimType,value);

@override
String toString() {
  return 'Claim(id: $id, participantId: $participantId, displayName: $displayName, claimType: $claimType, value: $value)';
}


}

/// @nodoc
abstract mixin class $ClaimCopyWith<$Res>  {
  factory $ClaimCopyWith(Claim value, $Res Function(Claim) _then) = _$ClaimCopyWithImpl;
@useResult
$Res call({
 String id, String participantId, String displayName, ClaimType claimType,@AmountConverter() String value
});




}
/// @nodoc
class _$ClaimCopyWithImpl<$Res>
    implements $ClaimCopyWith<$Res> {
  _$ClaimCopyWithImpl(this._self, this._then);

  final Claim _self;
  final $Res Function(Claim) _then;

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participantId = null,Object? displayName = null,Object? claimType = null,Object? value = null,}) {
  return _then(Claim(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,claimType: null == claimType ? _self.claimType : claimType // ignore: cast_nullable_to_non_nullable
as ClaimType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Claim].
extension ClaimPatterns on Claim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Claim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Claim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Claim value)  $default,){
final _that = this;
switch (_that) {
case _Claim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Claim value)?  $default,){
final _that = this;
switch (_that) {
case _Claim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String participantId,  String displayName,  ClaimType claimType, @AmountConverter()  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Claim() when $default != null:
return $default(_that.id,_that.participantId,_that.displayName,_that.claimType,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String participantId,  String displayName,  ClaimType claimType, @AmountConverter()  String value)  $default,) {final _that = this;
switch (_that) {
case _Claim():
return $default(_that.id,_that.participantId,_that.displayName,_that.claimType,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String participantId,  String displayName,  ClaimType claimType, @AmountConverter()  String value)?  $default,) {final _that = this;
switch (_that) {
case _Claim() when $default != null:
return $default(_that.id,_that.participantId,_that.displayName,_that.claimType,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Claim implements Claim {
  const _Claim({required this.id, required this.participantId, required this.displayName, required this.claimType, @AmountConverter() required this.value});
  factory _Claim.fromJson(Map<String, dynamic> json) => _$ClaimFromJson(json);

@override final  String id;
@override final  String participantId;
@override final  String displayName;
@override final  ClaimType claimType;
@override@AmountConverter() final  String value;

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimCopyWith<_Claim> get copyWith => __$ClaimCopyWithImpl<_Claim>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClaimToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Claim&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.claimType, claimType) || other.claimType == claimType)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,displayName,claimType,value);

@override
String toString() {
  return 'Claim(id: $id, participantId: $participantId, displayName: $displayName, claimType: $claimType, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ClaimCopyWith<$Res> implements $ClaimCopyWith<$Res> {
  factory _$ClaimCopyWith(_Claim value, $Res Function(_Claim) _then) = __$ClaimCopyWithImpl;
@override @useResult
$Res call({
 String id, String participantId, String displayName, ClaimType claimType,@AmountConverter() String value
});




}
/// @nodoc
class __$ClaimCopyWithImpl<$Res>
    implements _$ClaimCopyWith<$Res> {
  __$ClaimCopyWithImpl(this._self, this._then);

  final _Claim _self;
  final $Res Function(_Claim) _then;

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participantId = null,Object? displayName = null,Object? claimType = null,Object? value = null,}) {
  return _then(_Claim(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,claimType: null == claimType ? _self.claimType : claimType // ignore: cast_nullable_to_non_nullable
as ClaimType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BillPayment {

 String get participantId; String get displayName;@AmountConverter() String get amountPaid;
/// Create a copy of BillPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillPaymentCopyWith<BillPayment> get copyWith => _$BillPaymentCopyWithImpl<BillPayment>(this as BillPayment, _$identity);

  /// Serializes this BillPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillPayment&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,displayName,amountPaid);

@override
String toString() {
  return 'BillPayment(participantId: $participantId, displayName: $displayName, amountPaid: $amountPaid)';
}


}

/// @nodoc
abstract mixin class $BillPaymentCopyWith<$Res>  {
  factory $BillPaymentCopyWith(BillPayment value, $Res Function(BillPayment) _then) = _$BillPaymentCopyWithImpl;
@useResult
$Res call({
 String participantId, String displayName,@AmountConverter() String amountPaid
});




}
/// @nodoc
class _$BillPaymentCopyWithImpl<$Res>
    implements $BillPaymentCopyWith<$Res> {
  _$BillPaymentCopyWithImpl(this._self, this._then);

  final BillPayment _self;
  final $Res Function(BillPayment) _then;

/// Create a copy of BillPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantId = null,Object? displayName = null,Object? amountPaid = null,}) {
  return _then(BillPayment(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BillPayment].
extension BillPaymentPatterns on BillPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillPayment value)  $default,){
final _that = this;
switch (_that) {
case _BillPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillPayment value)?  $default,){
final _that = this;
switch (_that) {
case _BillPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String participantId,  String displayName, @AmountConverter()  String amountPaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillPayment() when $default != null:
return $default(_that.participantId,_that.displayName,_that.amountPaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String participantId,  String displayName, @AmountConverter()  String amountPaid)  $default,) {final _that = this;
switch (_that) {
case _BillPayment():
return $default(_that.participantId,_that.displayName,_that.amountPaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String participantId,  String displayName, @AmountConverter()  String amountPaid)?  $default,) {final _that = this;
switch (_that) {
case _BillPayment() when $default != null:
return $default(_that.participantId,_that.displayName,_that.amountPaid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillPayment implements BillPayment {
  const _BillPayment({required this.participantId, required this.displayName, @AmountConverter() required this.amountPaid});
  factory _BillPayment.fromJson(Map<String, dynamic> json) => _$BillPaymentFromJson(json);

@override final  String participantId;
@override final  String displayName;
@override@AmountConverter() final  String amountPaid;

/// Create a copy of BillPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillPaymentCopyWith<_BillPayment> get copyWith => __$BillPaymentCopyWithImpl<_BillPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillPayment&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,displayName,amountPaid);

@override
String toString() {
  return 'BillPayment(participantId: $participantId, displayName: $displayName, amountPaid: $amountPaid)';
}


}

/// @nodoc
abstract mixin class _$BillPaymentCopyWith<$Res> implements $BillPaymentCopyWith<$Res> {
  factory _$BillPaymentCopyWith(_BillPayment value, $Res Function(_BillPayment) _then) = __$BillPaymentCopyWithImpl;
@override @useResult
$Res call({
 String participantId, String displayName,@AmountConverter() String amountPaid
});




}
/// @nodoc
class __$BillPaymentCopyWithImpl<$Res>
    implements _$BillPaymentCopyWith<$Res> {
  __$BillPaymentCopyWithImpl(this._self, this._then);

  final _BillPayment _self;
  final $Res Function(_BillPayment) _then;

/// Create a copy of BillPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? displayName = null,Object? amountPaid = null,}) {
  return _then(_BillPayment(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ItemIssue {

 String get itemId; String get itemName; IssueType get type;
/// Create a copy of ItemIssue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemIssueCopyWith<ItemIssue> get copyWith => _$ItemIssueCopyWithImpl<ItemIssue>(this as ItemIssue, _$identity);

  /// Serializes this ItemIssue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemIssue&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,itemName,type);

@override
String toString() {
  return 'ItemIssue(itemId: $itemId, itemName: $itemName, type: $type)';
}


}

/// @nodoc
abstract mixin class $ItemIssueCopyWith<$Res>  {
  factory $ItemIssueCopyWith(ItemIssue value, $Res Function(ItemIssue) _then) = _$ItemIssueCopyWithImpl;
@useResult
$Res call({
 String itemId, String itemName, IssueType type
});




}
/// @nodoc
class _$ItemIssueCopyWithImpl<$Res>
    implements $ItemIssueCopyWith<$Res> {
  _$ItemIssueCopyWithImpl(this._self, this._then);

  final ItemIssue _self;
  final $Res Function(ItemIssue) _then;

/// Create a copy of ItemIssue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? itemName = null,Object? type = null,}) {
  return _then(ItemIssue(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as IssueType,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemIssue].
extension ItemIssuePatterns on ItemIssue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemIssue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemIssue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemIssue value)  $default,){
final _that = this;
switch (_that) {
case _ItemIssue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemIssue value)?  $default,){
final _that = this;
switch (_that) {
case _ItemIssue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String itemName,  IssueType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemIssue() when $default != null:
return $default(_that.itemId,_that.itemName,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String itemName,  IssueType type)  $default,) {final _that = this;
switch (_that) {
case _ItemIssue():
return $default(_that.itemId,_that.itemName,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String itemName,  IssueType type)?  $default,) {final _that = this;
switch (_that) {
case _ItemIssue() when $default != null:
return $default(_that.itemId,_that.itemName,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemIssue implements ItemIssue {
  const _ItemIssue({required this.itemId, required this.itemName, required this.type});
  factory _ItemIssue.fromJson(Map<String, dynamic> json) => _$ItemIssueFromJson(json);

@override final  String itemId;
@override final  String itemName;
@override final  IssueType type;

/// Create a copy of ItemIssue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemIssueCopyWith<_ItemIssue> get copyWith => __$ItemIssueCopyWithImpl<_ItemIssue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemIssueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemIssue&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,itemName,type);

@override
String toString() {
  return 'ItemIssue(itemId: $itemId, itemName: $itemName, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ItemIssueCopyWith<$Res> implements $ItemIssueCopyWith<$Res> {
  factory _$ItemIssueCopyWith(_ItemIssue value, $Res Function(_ItemIssue) _then) = __$ItemIssueCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String itemName, IssueType type
});




}
/// @nodoc
class __$ItemIssueCopyWithImpl<$Res>
    implements _$ItemIssueCopyWith<$Res> {
  __$ItemIssueCopyWithImpl(this._self, this._then);

  final _ItemIssue _self;
  final $Res Function(_ItemIssue) _then;

/// Create a copy of ItemIssue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? itemName = null,Object? type = null,}) {
  return _then(_ItemIssue(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as IssueType,
  ));
}


}


/// @nodoc
mixin _$ParticipantBreakdown {

 String get participantId; String get displayName;@AmountConverter() String get subtotal;@AmountConverter() String get taxShare;@AmountConverter() String get serviceShare;@AmountConverter() String get discountShare;@AmountConverter() String get roundingShare;@AmountConverter() String get finalAmount;
/// Create a copy of ParticipantBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantBreakdownCopyWith<ParticipantBreakdown> get copyWith => _$ParticipantBreakdownCopyWithImpl<ParticipantBreakdown>(this as ParticipantBreakdown, _$identity);

  /// Serializes this ParticipantBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantBreakdown&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxShare, taxShare) || other.taxShare == taxShare)&&(identical(other.serviceShare, serviceShare) || other.serviceShare == serviceShare)&&(identical(other.discountShare, discountShare) || other.discountShare == discountShare)&&(identical(other.roundingShare, roundingShare) || other.roundingShare == roundingShare)&&(identical(other.finalAmount, finalAmount) || other.finalAmount == finalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,displayName,subtotal,taxShare,serviceShare,discountShare,roundingShare,finalAmount);

@override
String toString() {
  return 'ParticipantBreakdown(participantId: $participantId, displayName: $displayName, subtotal: $subtotal, taxShare: $taxShare, serviceShare: $serviceShare, discountShare: $discountShare, roundingShare: $roundingShare, finalAmount: $finalAmount)';
}


}

/// @nodoc
abstract mixin class $ParticipantBreakdownCopyWith<$Res>  {
  factory $ParticipantBreakdownCopyWith(ParticipantBreakdown value, $Res Function(ParticipantBreakdown) _then) = _$ParticipantBreakdownCopyWithImpl;
@useResult
$Res call({
 String participantId, String displayName,@AmountConverter() String subtotal,@AmountConverter() String taxShare,@AmountConverter() String serviceShare,@AmountConverter() String discountShare,@AmountConverter() String roundingShare,@AmountConverter() String finalAmount
});




}
/// @nodoc
class _$ParticipantBreakdownCopyWithImpl<$Res>
    implements $ParticipantBreakdownCopyWith<$Res> {
  _$ParticipantBreakdownCopyWithImpl(this._self, this._then);

  final ParticipantBreakdown _self;
  final $Res Function(ParticipantBreakdown) _then;

/// Create a copy of ParticipantBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantId = null,Object? displayName = null,Object? subtotal = null,Object? taxShare = null,Object? serviceShare = null,Object? discountShare = null,Object? roundingShare = null,Object? finalAmount = null,}) {
  return _then(ParticipantBreakdown(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,taxShare: null == taxShare ? _self.taxShare : taxShare // ignore: cast_nullable_to_non_nullable
as String,serviceShare: null == serviceShare ? _self.serviceShare : serviceShare // ignore: cast_nullable_to_non_nullable
as String,discountShare: null == discountShare ? _self.discountShare : discountShare // ignore: cast_nullable_to_non_nullable
as String,roundingShare: null == roundingShare ? _self.roundingShare : roundingShare // ignore: cast_nullable_to_non_nullable
as String,finalAmount: null == finalAmount ? _self.finalAmount : finalAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantBreakdown].
extension ParticipantBreakdownPatterns on ParticipantBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String participantId,  String displayName, @AmountConverter()  String subtotal, @AmountConverter()  String taxShare, @AmountConverter()  String serviceShare, @AmountConverter()  String discountShare, @AmountConverter()  String roundingShare, @AmountConverter()  String finalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantBreakdown() when $default != null:
return $default(_that.participantId,_that.displayName,_that.subtotal,_that.taxShare,_that.serviceShare,_that.discountShare,_that.roundingShare,_that.finalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String participantId,  String displayName, @AmountConverter()  String subtotal, @AmountConverter()  String taxShare, @AmountConverter()  String serviceShare, @AmountConverter()  String discountShare, @AmountConverter()  String roundingShare, @AmountConverter()  String finalAmount)  $default,) {final _that = this;
switch (_that) {
case _ParticipantBreakdown():
return $default(_that.participantId,_that.displayName,_that.subtotal,_that.taxShare,_that.serviceShare,_that.discountShare,_that.roundingShare,_that.finalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String participantId,  String displayName, @AmountConverter()  String subtotal, @AmountConverter()  String taxShare, @AmountConverter()  String serviceShare, @AmountConverter()  String discountShare, @AmountConverter()  String roundingShare, @AmountConverter()  String finalAmount)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantBreakdown() when $default != null:
return $default(_that.participantId,_that.displayName,_that.subtotal,_that.taxShare,_that.serviceShare,_that.discountShare,_that.roundingShare,_that.finalAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantBreakdown implements ParticipantBreakdown {
  const _ParticipantBreakdown({required this.participantId, required this.displayName, @AmountConverter() required this.subtotal, @AmountConverter() required this.taxShare, @AmountConverter() required this.serviceShare, @AmountConverter() required this.discountShare, @AmountConverter() required this.roundingShare, @AmountConverter() required this.finalAmount});
  factory _ParticipantBreakdown.fromJson(Map<String, dynamic> json) => _$ParticipantBreakdownFromJson(json);

@override final  String participantId;
@override final  String displayName;
@override@AmountConverter() final  String subtotal;
@override@AmountConverter() final  String taxShare;
@override@AmountConverter() final  String serviceShare;
@override@AmountConverter() final  String discountShare;
@override@AmountConverter() final  String roundingShare;
@override@AmountConverter() final  String finalAmount;

/// Create a copy of ParticipantBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantBreakdownCopyWith<_ParticipantBreakdown> get copyWith => __$ParticipantBreakdownCopyWithImpl<_ParticipantBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantBreakdown&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxShare, taxShare) || other.taxShare == taxShare)&&(identical(other.serviceShare, serviceShare) || other.serviceShare == serviceShare)&&(identical(other.discountShare, discountShare) || other.discountShare == discountShare)&&(identical(other.roundingShare, roundingShare) || other.roundingShare == roundingShare)&&(identical(other.finalAmount, finalAmount) || other.finalAmount == finalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,displayName,subtotal,taxShare,serviceShare,discountShare,roundingShare,finalAmount);

@override
String toString() {
  return 'ParticipantBreakdown(participantId: $participantId, displayName: $displayName, subtotal: $subtotal, taxShare: $taxShare, serviceShare: $serviceShare, discountShare: $discountShare, roundingShare: $roundingShare, finalAmount: $finalAmount)';
}


}

/// @nodoc
abstract mixin class _$ParticipantBreakdownCopyWith<$Res> implements $ParticipantBreakdownCopyWith<$Res> {
  factory _$ParticipantBreakdownCopyWith(_ParticipantBreakdown value, $Res Function(_ParticipantBreakdown) _then) = __$ParticipantBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String participantId, String displayName,@AmountConverter() String subtotal,@AmountConverter() String taxShare,@AmountConverter() String serviceShare,@AmountConverter() String discountShare,@AmountConverter() String roundingShare,@AmountConverter() String finalAmount
});




}
/// @nodoc
class __$ParticipantBreakdownCopyWithImpl<$Res>
    implements _$ParticipantBreakdownCopyWith<$Res> {
  __$ParticipantBreakdownCopyWithImpl(this._self, this._then);

  final _ParticipantBreakdown _self;
  final $Res Function(_ParticipantBreakdown) _then;

/// Create a copy of ParticipantBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? displayName = null,Object? subtotal = null,Object? taxShare = null,Object? serviceShare = null,Object? discountShare = null,Object? roundingShare = null,Object? finalAmount = null,}) {
  return _then(_ParticipantBreakdown(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,taxShare: null == taxShare ? _self.taxShare : taxShare // ignore: cast_nullable_to_non_nullable
as String,serviceShare: null == serviceShare ? _self.serviceShare : serviceShare // ignore: cast_nullable_to_non_nullable
as String,discountShare: null == discountShare ? _self.discountShare : discountShare // ignore: cast_nullable_to_non_nullable
as String,roundingShare: null == roundingShare ? _self.roundingShare : roundingShare // ignore: cast_nullable_to_non_nullable
as String,finalAmount: null == finalAmount ? _self.finalAmount : finalAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Breakdown {

 bool get valid; List<ItemIssue> get issues;@AmountConverter() String get subtotal;@AmountConverter() String get computedTotal;@AmountConverter() String get roundingAdjustment; List<ParticipantBreakdown> get participants;
/// Create a copy of Breakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreakdownCopyWith<Breakdown> get copyWith => _$BreakdownCopyWithImpl<Breakdown>(this as Breakdown, _$identity);

  /// Serializes this Breakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Breakdown&&(identical(other.valid, valid) || other.valid == valid)&&const DeepCollectionEquality().equals(other.issues, issues)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.computedTotal, computedTotal) || other.computedTotal == computedTotal)&&(identical(other.roundingAdjustment, roundingAdjustment) || other.roundingAdjustment == roundingAdjustment)&&const DeepCollectionEquality().equals(other.participants, participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valid,const DeepCollectionEquality().hash(issues),subtotal,computedTotal,roundingAdjustment,const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'Breakdown(valid: $valid, issues: $issues, subtotal: $subtotal, computedTotal: $computedTotal, roundingAdjustment: $roundingAdjustment, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $BreakdownCopyWith<$Res>  {
  factory $BreakdownCopyWith(Breakdown value, $Res Function(Breakdown) _then) = _$BreakdownCopyWithImpl;
@useResult
$Res call({
 bool valid, List<ItemIssue> issues,@AmountConverter() String subtotal,@AmountConverter() String computedTotal,@AmountConverter() String roundingAdjustment, List<ParticipantBreakdown> participants
});




}
/// @nodoc
class _$BreakdownCopyWithImpl<$Res>
    implements $BreakdownCopyWith<$Res> {
  _$BreakdownCopyWithImpl(this._self, this._then);

  final Breakdown _self;
  final $Res Function(Breakdown) _then;

/// Create a copy of Breakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? valid = null,Object? issues = null,Object? subtotal = null,Object? computedTotal = null,Object? roundingAdjustment = null,Object? participants = null,}) {
  return _then(Breakdown(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as List<ItemIssue>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,computedTotal: null == computedTotal ? _self.computedTotal : computedTotal // ignore: cast_nullable_to_non_nullable
as String,roundingAdjustment: null == roundingAdjustment ? _self.roundingAdjustment : roundingAdjustment // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantBreakdown>,
  ));
}

}


/// Adds pattern-matching-related methods to [Breakdown].
extension BreakdownPatterns on Breakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Breakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Breakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Breakdown value)  $default,){
final _that = this;
switch (_that) {
case _Breakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Breakdown value)?  $default,){
final _that = this;
switch (_that) {
case _Breakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool valid,  List<ItemIssue> issues, @AmountConverter()  String subtotal, @AmountConverter()  String computedTotal, @AmountConverter()  String roundingAdjustment,  List<ParticipantBreakdown> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Breakdown() when $default != null:
return $default(_that.valid,_that.issues,_that.subtotal,_that.computedTotal,_that.roundingAdjustment,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool valid,  List<ItemIssue> issues, @AmountConverter()  String subtotal, @AmountConverter()  String computedTotal, @AmountConverter()  String roundingAdjustment,  List<ParticipantBreakdown> participants)  $default,) {final _that = this;
switch (_that) {
case _Breakdown():
return $default(_that.valid,_that.issues,_that.subtotal,_that.computedTotal,_that.roundingAdjustment,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool valid,  List<ItemIssue> issues, @AmountConverter()  String subtotal, @AmountConverter()  String computedTotal, @AmountConverter()  String roundingAdjustment,  List<ParticipantBreakdown> participants)?  $default,) {final _that = this;
switch (_that) {
case _Breakdown() when $default != null:
return $default(_that.valid,_that.issues,_that.subtotal,_that.computedTotal,_that.roundingAdjustment,_that.participants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Breakdown implements Breakdown {
  const _Breakdown({required this.valid, required  List<ItemIssue> issues, @AmountConverter() required this.subtotal, @AmountConverter() required this.computedTotal, @AmountConverter() required this.roundingAdjustment, required  List<ParticipantBreakdown> participants}): _issues = issues,_participants = participants;
  factory _Breakdown.fromJson(Map<String, dynamic> json) => _$BreakdownFromJson(json);

@override final  bool valid;
 final  List<ItemIssue> _issues;
@override List<ItemIssue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}

@override@AmountConverter() final  String subtotal;
@override@AmountConverter() final  String computedTotal;
@override@AmountConverter() final  String roundingAdjustment;
 final  List<ParticipantBreakdown> _participants;
@override List<ParticipantBreakdown> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of Breakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreakdownCopyWith<_Breakdown> get copyWith => __$BreakdownCopyWithImpl<_Breakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Breakdown&&(identical(other.valid, valid) || other.valid == valid)&&const DeepCollectionEquality().equals(other._issues, _issues)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.computedTotal, computedTotal) || other.computedTotal == computedTotal)&&(identical(other.roundingAdjustment, roundingAdjustment) || other.roundingAdjustment == roundingAdjustment)&&const DeepCollectionEquality().equals(other._participants, _participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valid,const DeepCollectionEquality().hash(_issues),subtotal,computedTotal,roundingAdjustment,const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'Breakdown(valid: $valid, issues: $issues, subtotal: $subtotal, computedTotal: $computedTotal, roundingAdjustment: $roundingAdjustment, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$BreakdownCopyWith<$Res> implements $BreakdownCopyWith<$Res> {
  factory _$BreakdownCopyWith(_Breakdown value, $Res Function(_Breakdown) _then) = __$BreakdownCopyWithImpl;
@override @useResult
$Res call({
 bool valid, List<ItemIssue> issues,@AmountConverter() String subtotal,@AmountConverter() String computedTotal,@AmountConverter() String roundingAdjustment, List<ParticipantBreakdown> participants
});




}
/// @nodoc
class __$BreakdownCopyWithImpl<$Res>
    implements _$BreakdownCopyWith<$Res> {
  __$BreakdownCopyWithImpl(this._self, this._then);

  final _Breakdown _self;
  final $Res Function(_Breakdown) _then;

/// Create a copy of Breakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? valid = null,Object? issues = null,Object? subtotal = null,Object? computedTotal = null,Object? roundingAdjustment = null,Object? participants = null,}) {
  return _then(_Breakdown(
valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<ItemIssue>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,computedTotal: null == computedTotal ? _self.computedTotal : computedTotal // ignore: cast_nullable_to_non_nullable
as String,roundingAdjustment: null == roundingAdjustment ? _self.roundingAdjustment : roundingAdjustment // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ParticipantBreakdown>,
  ));
}


}


/// @nodoc
mixin _$BillBalance {

 String get participantId; String get displayName;@AmountConverter() String get paid;@AmountConverter() String get owed;@AmountConverter() String get net;
/// Create a copy of BillBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillBalanceCopyWith<BillBalance> get copyWith => _$BillBalanceCopyWithImpl<BillBalance>(this as BillBalance, _$identity);

  /// Serializes this BillBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillBalance&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.owed, owed) || other.owed == owed)&&(identical(other.net, net) || other.net == net));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,displayName,paid,owed,net);

@override
String toString() {
  return 'BillBalance(participantId: $participantId, displayName: $displayName, paid: $paid, owed: $owed, net: $net)';
}


}

/// @nodoc
abstract mixin class $BillBalanceCopyWith<$Res>  {
  factory $BillBalanceCopyWith(BillBalance value, $Res Function(BillBalance) _then) = _$BillBalanceCopyWithImpl;
@useResult
$Res call({
 String participantId, String displayName,@AmountConverter() String paid,@AmountConverter() String owed,@AmountConverter() String net
});




}
/// @nodoc
class _$BillBalanceCopyWithImpl<$Res>
    implements $BillBalanceCopyWith<$Res> {
  _$BillBalanceCopyWithImpl(this._self, this._then);

  final BillBalance _self;
  final $Res Function(BillBalance) _then;

/// Create a copy of BillBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantId = null,Object? displayName = null,Object? paid = null,Object? owed = null,Object? net = null,}) {
  return _then(BillBalance(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as String,owed: null == owed ? _self.owed : owed // ignore: cast_nullable_to_non_nullable
as String,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BillBalance].
extension BillBalancePatterns on BillBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillBalance value)  $default,){
final _that = this;
switch (_that) {
case _BillBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillBalance value)?  $default,){
final _that = this;
switch (_that) {
case _BillBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String participantId,  String displayName, @AmountConverter()  String paid, @AmountConverter()  String owed, @AmountConverter()  String net)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillBalance() when $default != null:
return $default(_that.participantId,_that.displayName,_that.paid,_that.owed,_that.net);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String participantId,  String displayName, @AmountConverter()  String paid, @AmountConverter()  String owed, @AmountConverter()  String net)  $default,) {final _that = this;
switch (_that) {
case _BillBalance():
return $default(_that.participantId,_that.displayName,_that.paid,_that.owed,_that.net);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String participantId,  String displayName, @AmountConverter()  String paid, @AmountConverter()  String owed, @AmountConverter()  String net)?  $default,) {final _that = this;
switch (_that) {
case _BillBalance() when $default != null:
return $default(_that.participantId,_that.displayName,_that.paid,_that.owed,_that.net);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillBalance implements BillBalance {
  const _BillBalance({required this.participantId, required this.displayName, @AmountConverter() required this.paid, @AmountConverter() required this.owed, @AmountConverter() required this.net});
  factory _BillBalance.fromJson(Map<String, dynamic> json) => _$BillBalanceFromJson(json);

@override final  String participantId;
@override final  String displayName;
@override@AmountConverter() final  String paid;
@override@AmountConverter() final  String owed;
@override@AmountConverter() final  String net;

/// Create a copy of BillBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillBalanceCopyWith<_BillBalance> get copyWith => __$BillBalanceCopyWithImpl<_BillBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillBalance&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.owed, owed) || other.owed == owed)&&(identical(other.net, net) || other.net == net));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,displayName,paid,owed,net);

@override
String toString() {
  return 'BillBalance(participantId: $participantId, displayName: $displayName, paid: $paid, owed: $owed, net: $net)';
}


}

/// @nodoc
abstract mixin class _$BillBalanceCopyWith<$Res> implements $BillBalanceCopyWith<$Res> {
  factory _$BillBalanceCopyWith(_BillBalance value, $Res Function(_BillBalance) _then) = __$BillBalanceCopyWithImpl;
@override @useResult
$Res call({
 String participantId, String displayName,@AmountConverter() String paid,@AmountConverter() String owed,@AmountConverter() String net
});




}
/// @nodoc
class __$BillBalanceCopyWithImpl<$Res>
    implements _$BillBalanceCopyWith<$Res> {
  __$BillBalanceCopyWithImpl(this._self, this._then);

  final _BillBalance _self;
  final $Res Function(_BillBalance) _then;

/// Create a copy of BillBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? displayName = null,Object? paid = null,Object? owed = null,Object? net = null,}) {
  return _then(_BillBalance(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as String,owed: null == owed ? _self.owed : owed // ignore: cast_nullable_to_non_nullable
as String,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$JoinBillResponse {

 String get billId; String get participantId; String get displayName; bool get guest; String? get guestToken;
/// Create a copy of JoinBillResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinBillResponseCopyWith<JoinBillResponse> get copyWith => _$JoinBillResponseCopyWithImpl<JoinBillResponse>(this as JoinBillResponse, _$identity);

  /// Serializes this JoinBillResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinBillResponse&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.guest, guest) || other.guest == guest)&&(identical(other.guestToken, guestToken) || other.guestToken == guestToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,billId,participantId,displayName,guest,guestToken);

@override
String toString() {
  return 'JoinBillResponse(billId: $billId, participantId: $participantId, displayName: $displayName, guest: $guest, guestToken: $guestToken)';
}


}

/// @nodoc
abstract mixin class $JoinBillResponseCopyWith<$Res>  {
  factory $JoinBillResponseCopyWith(JoinBillResponse value, $Res Function(JoinBillResponse) _then) = _$JoinBillResponseCopyWithImpl;
@useResult
$Res call({
 String billId, String participantId, String displayName, bool guest, String? guestToken
});




}
/// @nodoc
class _$JoinBillResponseCopyWithImpl<$Res>
    implements $JoinBillResponseCopyWith<$Res> {
  _$JoinBillResponseCopyWithImpl(this._self, this._then);

  final JoinBillResponse _self;
  final $Res Function(JoinBillResponse) _then;

/// Create a copy of JoinBillResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? billId = null,Object? participantId = null,Object? displayName = null,Object? guest = null,Object? guestToken = freezed,}) {
  return _then(JoinBillResponse(
billId: null == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as bool,guestToken: freezed == guestToken ? _self.guestToken : guestToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinBillResponse].
extension JoinBillResponsePatterns on JoinBillResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinBillResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinBillResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinBillResponse value)  $default,){
final _that = this;
switch (_that) {
case _JoinBillResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinBillResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JoinBillResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String billId,  String participantId,  String displayName,  bool guest,  String? guestToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinBillResponse() when $default != null:
return $default(_that.billId,_that.participantId,_that.displayName,_that.guest,_that.guestToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String billId,  String participantId,  String displayName,  bool guest,  String? guestToken)  $default,) {final _that = this;
switch (_that) {
case _JoinBillResponse():
return $default(_that.billId,_that.participantId,_that.displayName,_that.guest,_that.guestToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String billId,  String participantId,  String displayName,  bool guest,  String? guestToken)?  $default,) {final _that = this;
switch (_that) {
case _JoinBillResponse() when $default != null:
return $default(_that.billId,_that.participantId,_that.displayName,_that.guest,_that.guestToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JoinBillResponse implements JoinBillResponse {
  const _JoinBillResponse({required this.billId, required this.participantId, required this.displayName, required this.guest, this.guestToken});
  factory _JoinBillResponse.fromJson(Map<String, dynamic> json) => _$JoinBillResponseFromJson(json);

@override final  String billId;
@override final  String participantId;
@override final  String displayName;
@override final  bool guest;
@override final  String? guestToken;

/// Create a copy of JoinBillResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinBillResponseCopyWith<_JoinBillResponse> get copyWith => __$JoinBillResponseCopyWithImpl<_JoinBillResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JoinBillResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinBillResponse&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.guest, guest) || other.guest == guest)&&(identical(other.guestToken, guestToken) || other.guestToken == guestToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,billId,participantId,displayName,guest,guestToken);

@override
String toString() {
  return 'JoinBillResponse(billId: $billId, participantId: $participantId, displayName: $displayName, guest: $guest, guestToken: $guestToken)';
}


}

/// @nodoc
abstract mixin class _$JoinBillResponseCopyWith<$Res> implements $JoinBillResponseCopyWith<$Res> {
  factory _$JoinBillResponseCopyWith(_JoinBillResponse value, $Res Function(_JoinBillResponse) _then) = __$JoinBillResponseCopyWithImpl;
@override @useResult
$Res call({
 String billId, String participantId, String displayName, bool guest, String? guestToken
});




}
/// @nodoc
class __$JoinBillResponseCopyWithImpl<$Res>
    implements _$JoinBillResponseCopyWith<$Res> {
  __$JoinBillResponseCopyWithImpl(this._self, this._then);

  final _JoinBillResponse _self;
  final $Res Function(_JoinBillResponse) _then;

/// Create a copy of JoinBillResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? billId = null,Object? participantId = null,Object? displayName = null,Object? guest = null,Object? guestToken = freezed,}) {
  return _then(_JoinBillResponse(
billId: null == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,guest: null == guest ? _self.guest : guest // ignore: cast_nullable_to_non_nullable
as bool,guestToken: freezed == guestToken ? _self.guestToken : guestToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
