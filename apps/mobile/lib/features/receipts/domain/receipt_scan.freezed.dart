// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_scan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParsedReceiptItem {

 String? get name;@NullableAmountConverter() String? get quantity;@NullableAmountConverter() String? get unitPrice;@NullableAmountConverter() String? get totalPrice; double get confidence;
/// Create a copy of ParsedReceiptItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedReceiptItemCopyWith<ParsedReceiptItem> get copyWith => _$ParsedReceiptItemCopyWithImpl<ParsedReceiptItem>(this as ParsedReceiptItem, _$identity);

  /// Serializes this ParsedReceiptItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedReceiptItem&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,unitPrice,totalPrice,confidence);

@override
String toString() {
  return 'ParsedReceiptItem(name: $name, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $ParsedReceiptItemCopyWith<$Res>  {
  factory $ParsedReceiptItemCopyWith(ParsedReceiptItem value, $Res Function(ParsedReceiptItem) _then) = _$ParsedReceiptItemCopyWithImpl;
@useResult
$Res call({
 String? name,@NullableAmountConverter() String? quantity,@NullableAmountConverter() String? unitPrice,@NullableAmountConverter() String? totalPrice, double confidence
});




}
/// @nodoc
class _$ParsedReceiptItemCopyWithImpl<$Res>
    implements $ParsedReceiptItemCopyWith<$Res> {
  _$ParsedReceiptItemCopyWithImpl(this._self, this._then);

  final ParsedReceiptItem _self;
  final $Res Function(ParsedReceiptItem) _then;

/// Create a copy of ParsedReceiptItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? quantity = freezed,Object? unitPrice = freezed,Object? totalPrice = freezed,Object? confidence = null,}) {
  return _then(ParsedReceiptItem(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String?,totalPrice: freezed == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedReceiptItem].
extension ParsedReceiptItemPatterns on ParsedReceiptItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedReceiptItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedReceiptItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedReceiptItem value)  $default,){
final _that = this;
switch (_that) {
case _ParsedReceiptItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedReceiptItem value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedReceiptItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name, @NullableAmountConverter()  String? quantity, @NullableAmountConverter()  String? unitPrice, @NullableAmountConverter()  String? totalPrice,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParsedReceiptItem() when $default != null:
return $default(_that.name,_that.quantity,_that.unitPrice,_that.totalPrice,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name, @NullableAmountConverter()  String? quantity, @NullableAmountConverter()  String? unitPrice, @NullableAmountConverter()  String? totalPrice,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _ParsedReceiptItem():
return $default(_that.name,_that.quantity,_that.unitPrice,_that.totalPrice,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name, @NullableAmountConverter()  String? quantity, @NullableAmountConverter()  String? unitPrice, @NullableAmountConverter()  String? totalPrice,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _ParsedReceiptItem() when $default != null:
return $default(_that.name,_that.quantity,_that.unitPrice,_that.totalPrice,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParsedReceiptItem implements ParsedReceiptItem {
  const _ParsedReceiptItem({this.name, @NullableAmountConverter() this.quantity, @NullableAmountConverter() this.unitPrice, @NullableAmountConverter() this.totalPrice, required this.confidence});
  factory _ParsedReceiptItem.fromJson(Map<String, dynamic> json) => _$ParsedReceiptItemFromJson(json);

@override final  String? name;
@override@NullableAmountConverter() final  String? quantity;
@override@NullableAmountConverter() final  String? unitPrice;
@override@NullableAmountConverter() final  String? totalPrice;
@override final  double confidence;

/// Create a copy of ParsedReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedReceiptItemCopyWith<_ParsedReceiptItem> get copyWith => __$ParsedReceiptItemCopyWithImpl<_ParsedReceiptItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParsedReceiptItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedReceiptItem&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,unitPrice,totalPrice,confidence);

@override
String toString() {
  return 'ParsedReceiptItem(name: $name, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$ParsedReceiptItemCopyWith<$Res> implements $ParsedReceiptItemCopyWith<$Res> {
  factory _$ParsedReceiptItemCopyWith(_ParsedReceiptItem value, $Res Function(_ParsedReceiptItem) _then) = __$ParsedReceiptItemCopyWithImpl;
@override @useResult
$Res call({
 String? name,@NullableAmountConverter() String? quantity,@NullableAmountConverter() String? unitPrice,@NullableAmountConverter() String? totalPrice, double confidence
});




}
/// @nodoc
class __$ParsedReceiptItemCopyWithImpl<$Res>
    implements _$ParsedReceiptItemCopyWith<$Res> {
  __$ParsedReceiptItemCopyWithImpl(this._self, this._then);

  final _ParsedReceiptItem _self;
  final $Res Function(_ParsedReceiptItem) _then;

/// Create a copy of ParsedReceiptItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? quantity = freezed,Object? unitPrice = freezed,Object? totalPrice = freezed,Object? confidence = null,}) {
  return _then(_ParsedReceiptItem(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String?,totalPrice: freezed == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ParsedReceipt {

 String? get merchant; double get merchantConfidence; String? get receiptDate; double get receiptDateConfidence; List<ParsedReceiptItem> get items;@NullableAmountConverter() String? get tax; double get taxConfidence;@NullableAmountConverter() String? get serviceCharge; double get serviceConfidence;@NullableAmountConverter() String? get discount; double get discountConfidence;@NullableAmountConverter() String? get total; double get totalConfidence; double get overallConfidence;
/// Create a copy of ParsedReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedReceiptCopyWith<ParsedReceipt> get copyWith => _$ParsedReceiptCopyWithImpl<ParsedReceipt>(this as ParsedReceipt, _$identity);

  /// Serializes this ParsedReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedReceipt&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.merchantConfidence, merchantConfidence) || other.merchantConfidence == merchantConfidence)&&(identical(other.receiptDate, receiptDate) || other.receiptDate == receiptDate)&&(identical(other.receiptDateConfidence, receiptDateConfidence) || other.receiptDateConfidence == receiptDateConfidence)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.taxConfidence, taxConfidence) || other.taxConfidence == taxConfidence)&&(identical(other.serviceCharge, serviceCharge) || other.serviceCharge == serviceCharge)&&(identical(other.serviceConfidence, serviceConfidence) || other.serviceConfidence == serviceConfidence)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountConfidence, discountConfidence) || other.discountConfidence == discountConfidence)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalConfidence, totalConfidence) || other.totalConfidence == totalConfidence)&&(identical(other.overallConfidence, overallConfidence) || other.overallConfidence == overallConfidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,merchant,merchantConfidence,receiptDate,receiptDateConfidence,const DeepCollectionEquality().hash(items),tax,taxConfidence,serviceCharge,serviceConfidence,discount,discountConfidence,total,totalConfidence,overallConfidence);

@override
String toString() {
  return 'ParsedReceipt(merchant: $merchant, merchantConfidence: $merchantConfidence, receiptDate: $receiptDate, receiptDateConfidence: $receiptDateConfidence, items: $items, tax: $tax, taxConfidence: $taxConfidence, serviceCharge: $serviceCharge, serviceConfidence: $serviceConfidence, discount: $discount, discountConfidence: $discountConfidence, total: $total, totalConfidence: $totalConfidence, overallConfidence: $overallConfidence)';
}


}

/// @nodoc
abstract mixin class $ParsedReceiptCopyWith<$Res>  {
  factory $ParsedReceiptCopyWith(ParsedReceipt value, $Res Function(ParsedReceipt) _then) = _$ParsedReceiptCopyWithImpl;
@useResult
$Res call({
 String? merchant, double merchantConfidence, String? receiptDate, double receiptDateConfidence, List<ParsedReceiptItem> items,@NullableAmountConverter() String? tax, double taxConfidence,@NullableAmountConverter() String? serviceCharge, double serviceConfidence,@NullableAmountConverter() String? discount, double discountConfidence,@NullableAmountConverter() String? total, double totalConfidence, double overallConfidence
});




}
/// @nodoc
class _$ParsedReceiptCopyWithImpl<$Res>
    implements $ParsedReceiptCopyWith<$Res> {
  _$ParsedReceiptCopyWithImpl(this._self, this._then);

  final ParsedReceipt _self;
  final $Res Function(ParsedReceipt) _then;

/// Create a copy of ParsedReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? merchant = freezed,Object? merchantConfidence = null,Object? receiptDate = freezed,Object? receiptDateConfidence = null,Object? items = null,Object? tax = freezed,Object? taxConfidence = null,Object? serviceCharge = freezed,Object? serviceConfidence = null,Object? discount = freezed,Object? discountConfidence = null,Object? total = freezed,Object? totalConfidence = null,Object? overallConfidence = null,}) {
  return _then(ParsedReceipt(
merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,merchantConfidence: null == merchantConfidence ? _self.merchantConfidence : merchantConfidence // ignore: cast_nullable_to_non_nullable
as double,receiptDate: freezed == receiptDate ? _self.receiptDate : receiptDate // ignore: cast_nullable_to_non_nullable
as String?,receiptDateConfidence: null == receiptDateConfidence ? _self.receiptDateConfidence : receiptDateConfidence // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ParsedReceiptItem>,tax: freezed == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as String?,taxConfidence: null == taxConfidence ? _self.taxConfidence : taxConfidence // ignore: cast_nullable_to_non_nullable
as double,serviceCharge: freezed == serviceCharge ? _self.serviceCharge : serviceCharge // ignore: cast_nullable_to_non_nullable
as String?,serviceConfidence: null == serviceConfidence ? _self.serviceConfidence : serviceConfidence // ignore: cast_nullable_to_non_nullable
as double,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as String?,discountConfidence: null == discountConfidence ? _self.discountConfidence : discountConfidence // ignore: cast_nullable_to_non_nullable
as double,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String?,totalConfidence: null == totalConfidence ? _self.totalConfidence : totalConfidence // ignore: cast_nullable_to_non_nullable
as double,overallConfidence: null == overallConfidence ? _self.overallConfidence : overallConfidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedReceipt].
extension ParsedReceiptPatterns on ParsedReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedReceipt value)  $default,){
final _that = this;
switch (_that) {
case _ParsedReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedReceipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? merchant,  double merchantConfidence,  String? receiptDate,  double receiptDateConfidence,  List<ParsedReceiptItem> items, @NullableAmountConverter()  String? tax,  double taxConfidence, @NullableAmountConverter()  String? serviceCharge,  double serviceConfidence, @NullableAmountConverter()  String? discount,  double discountConfidence, @NullableAmountConverter()  String? total,  double totalConfidence,  double overallConfidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParsedReceipt() when $default != null:
return $default(_that.merchant,_that.merchantConfidence,_that.receiptDate,_that.receiptDateConfidence,_that.items,_that.tax,_that.taxConfidence,_that.serviceCharge,_that.serviceConfidence,_that.discount,_that.discountConfidence,_that.total,_that.totalConfidence,_that.overallConfidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? merchant,  double merchantConfidence,  String? receiptDate,  double receiptDateConfidence,  List<ParsedReceiptItem> items, @NullableAmountConverter()  String? tax,  double taxConfidence, @NullableAmountConverter()  String? serviceCharge,  double serviceConfidence, @NullableAmountConverter()  String? discount,  double discountConfidence, @NullableAmountConverter()  String? total,  double totalConfidence,  double overallConfidence)  $default,) {final _that = this;
switch (_that) {
case _ParsedReceipt():
return $default(_that.merchant,_that.merchantConfidence,_that.receiptDate,_that.receiptDateConfidence,_that.items,_that.tax,_that.taxConfidence,_that.serviceCharge,_that.serviceConfidence,_that.discount,_that.discountConfidence,_that.total,_that.totalConfidence,_that.overallConfidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? merchant,  double merchantConfidence,  String? receiptDate,  double receiptDateConfidence,  List<ParsedReceiptItem> items, @NullableAmountConverter()  String? tax,  double taxConfidence, @NullableAmountConverter()  String? serviceCharge,  double serviceConfidence, @NullableAmountConverter()  String? discount,  double discountConfidence, @NullableAmountConverter()  String? total,  double totalConfidence,  double overallConfidence)?  $default,) {final _that = this;
switch (_that) {
case _ParsedReceipt() when $default != null:
return $default(_that.merchant,_that.merchantConfidence,_that.receiptDate,_that.receiptDateConfidence,_that.items,_that.tax,_that.taxConfidence,_that.serviceCharge,_that.serviceConfidence,_that.discount,_that.discountConfidence,_that.total,_that.totalConfidence,_that.overallConfidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParsedReceipt implements ParsedReceipt {
  const _ParsedReceipt({this.merchant, required this.merchantConfidence, this.receiptDate, required this.receiptDateConfidence, required  List<ParsedReceiptItem> items, @NullableAmountConverter() this.tax, required this.taxConfidence, @NullableAmountConverter() this.serviceCharge, required this.serviceConfidence, @NullableAmountConverter() this.discount, required this.discountConfidence, @NullableAmountConverter() this.total, required this.totalConfidence, required this.overallConfidence}): _items = items;
  factory _ParsedReceipt.fromJson(Map<String, dynamic> json) => _$ParsedReceiptFromJson(json);

@override final  String? merchant;
@override final  double merchantConfidence;
@override final  String? receiptDate;
@override final  double receiptDateConfidence;
 final  List<ParsedReceiptItem> _items;
@override List<ParsedReceiptItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@NullableAmountConverter() final  String? tax;
@override final  double taxConfidence;
@override@NullableAmountConverter() final  String? serviceCharge;
@override final  double serviceConfidence;
@override@NullableAmountConverter() final  String? discount;
@override final  double discountConfidence;
@override@NullableAmountConverter() final  String? total;
@override final  double totalConfidence;
@override final  double overallConfidence;

/// Create a copy of ParsedReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedReceiptCopyWith<_ParsedReceipt> get copyWith => __$ParsedReceiptCopyWithImpl<_ParsedReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParsedReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedReceipt&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.merchantConfidence, merchantConfidence) || other.merchantConfidence == merchantConfidence)&&(identical(other.receiptDate, receiptDate) || other.receiptDate == receiptDate)&&(identical(other.receiptDateConfidence, receiptDateConfidence) || other.receiptDateConfidence == receiptDateConfidence)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.taxConfidence, taxConfidence) || other.taxConfidence == taxConfidence)&&(identical(other.serviceCharge, serviceCharge) || other.serviceCharge == serviceCharge)&&(identical(other.serviceConfidence, serviceConfidence) || other.serviceConfidence == serviceConfidence)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountConfidence, discountConfidence) || other.discountConfidence == discountConfidence)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalConfidence, totalConfidence) || other.totalConfidence == totalConfidence)&&(identical(other.overallConfidence, overallConfidence) || other.overallConfidence == overallConfidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,merchant,merchantConfidence,receiptDate,receiptDateConfidence,const DeepCollectionEquality().hash(_items),tax,taxConfidence,serviceCharge,serviceConfidence,discount,discountConfidence,total,totalConfidence,overallConfidence);

@override
String toString() {
  return 'ParsedReceipt(merchant: $merchant, merchantConfidence: $merchantConfidence, receiptDate: $receiptDate, receiptDateConfidence: $receiptDateConfidence, items: $items, tax: $tax, taxConfidence: $taxConfidence, serviceCharge: $serviceCharge, serviceConfidence: $serviceConfidence, discount: $discount, discountConfidence: $discountConfidence, total: $total, totalConfidence: $totalConfidence, overallConfidence: $overallConfidence)';
}


}

/// @nodoc
abstract mixin class _$ParsedReceiptCopyWith<$Res> implements $ParsedReceiptCopyWith<$Res> {
  factory _$ParsedReceiptCopyWith(_ParsedReceipt value, $Res Function(_ParsedReceipt) _then) = __$ParsedReceiptCopyWithImpl;
@override @useResult
$Res call({
 String? merchant, double merchantConfidence, String? receiptDate, double receiptDateConfidence, List<ParsedReceiptItem> items,@NullableAmountConverter() String? tax, double taxConfidence,@NullableAmountConverter() String? serviceCharge, double serviceConfidence,@NullableAmountConverter() String? discount, double discountConfidence,@NullableAmountConverter() String? total, double totalConfidence, double overallConfidence
});




}
/// @nodoc
class __$ParsedReceiptCopyWithImpl<$Res>
    implements _$ParsedReceiptCopyWith<$Res> {
  __$ParsedReceiptCopyWithImpl(this._self, this._then);

  final _ParsedReceipt _self;
  final $Res Function(_ParsedReceipt) _then;

/// Create a copy of ParsedReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? merchant = freezed,Object? merchantConfidence = null,Object? receiptDate = freezed,Object? receiptDateConfidence = null,Object? items = null,Object? tax = freezed,Object? taxConfidence = null,Object? serviceCharge = freezed,Object? serviceConfidence = null,Object? discount = freezed,Object? discountConfidence = null,Object? total = freezed,Object? totalConfidence = null,Object? overallConfidence = null,}) {
  return _then(_ParsedReceipt(
merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,merchantConfidence: null == merchantConfidence ? _self.merchantConfidence : merchantConfidence // ignore: cast_nullable_to_non_nullable
as double,receiptDate: freezed == receiptDate ? _self.receiptDate : receiptDate // ignore: cast_nullable_to_non_nullable
as String?,receiptDateConfidence: null == receiptDateConfidence ? _self.receiptDateConfidence : receiptDateConfidence // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ParsedReceiptItem>,tax: freezed == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as String?,taxConfidence: null == taxConfidence ? _self.taxConfidence : taxConfidence // ignore: cast_nullable_to_non_nullable
as double,serviceCharge: freezed == serviceCharge ? _self.serviceCharge : serviceCharge // ignore: cast_nullable_to_non_nullable
as String?,serviceConfidence: null == serviceConfidence ? _self.serviceConfidence : serviceConfidence // ignore: cast_nullable_to_non_nullable
as double,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as String?,discountConfidence: null == discountConfidence ? _self.discountConfidence : discountConfidence // ignore: cast_nullable_to_non_nullable
as double,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String?,totalConfidence: null == totalConfidence ? _self.totalConfidence : totalConfidence // ignore: cast_nullable_to_non_nullable
as double,overallConfidence: null == overallConfidence ? _self.overallConfidence : overallConfidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ReceiptScan {

 String get id; ScanStatus get status; String get provider; double? get overallConfidence;/// Server-computed (`ParsedReceipt.needsReview()`, true when
/// `overallConfidence < 0.7`) — the one threshold every client should use
/// rather than guessing its own cutoff.
 bool get needsReview; ParsedReceipt get parsedReceipt; String get imageUrl; String? get errorMessage; String? get billId;
/// Create a copy of ReceiptScan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptScanCopyWith<ReceiptScan> get copyWith => _$ReceiptScanCopyWithImpl<ReceiptScan>(this as ReceiptScan, _$identity);

  /// Serializes this ReceiptScan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptScan&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.overallConfidence, overallConfidence) || other.overallConfidence == overallConfidence)&&(identical(other.needsReview, needsReview) || other.needsReview == needsReview)&&(identical(other.parsedReceipt, parsedReceipt) || other.parsedReceipt == parsedReceipt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.billId, billId) || other.billId == billId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,provider,overallConfidence,needsReview,parsedReceipt,imageUrl,errorMessage,billId);

@override
String toString() {
  return 'ReceiptScan(id: $id, status: $status, provider: $provider, overallConfidence: $overallConfidence, needsReview: $needsReview, parsedReceipt: $parsedReceipt, imageUrl: $imageUrl, errorMessage: $errorMessage, billId: $billId)';
}


}

/// @nodoc
abstract mixin class $ReceiptScanCopyWith<$Res>  {
  factory $ReceiptScanCopyWith(ReceiptScan value, $Res Function(ReceiptScan) _then) = _$ReceiptScanCopyWithImpl;
@useResult
$Res call({
 String id, ScanStatus status, String provider, double? overallConfidence, bool needsReview, ParsedReceipt parsedReceipt, String imageUrl, String? errorMessage, String? billId
});


$ParsedReceiptCopyWith<$Res> get parsedReceipt;

}
/// @nodoc
class _$ReceiptScanCopyWithImpl<$Res>
    implements $ReceiptScanCopyWith<$Res> {
  _$ReceiptScanCopyWithImpl(this._self, this._then);

  final ReceiptScan _self;
  final $Res Function(ReceiptScan) _then;

/// Create a copy of ReceiptScan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? provider = null,Object? overallConfidence = freezed,Object? needsReview = null,Object? parsedReceipt = null,Object? imageUrl = null,Object? errorMessage = freezed,Object? billId = freezed,}) {
  return _then(ReceiptScan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanStatus,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,overallConfidence: freezed == overallConfidence ? _self.overallConfidence : overallConfidence // ignore: cast_nullable_to_non_nullable
as double?,needsReview: null == needsReview ? _self.needsReview : needsReview // ignore: cast_nullable_to_non_nullable
as bool,parsedReceipt: null == parsedReceipt ? _self.parsedReceipt : parsedReceipt // ignore: cast_nullable_to_non_nullable
as ParsedReceipt,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,billId: freezed == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ReceiptScan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedReceiptCopyWith<$Res> get parsedReceipt {
  
  return $ParsedReceiptCopyWith<$Res>(_self.parsedReceipt, (value) {
    return _then(_self.copyWith(parsedReceipt: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptScan].
extension ReceiptScanPatterns on ReceiptScan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptScan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptScan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptScan value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptScan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptScan value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptScan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ScanStatus status,  String provider,  double? overallConfidence,  bool needsReview,  ParsedReceipt parsedReceipt,  String imageUrl,  String? errorMessage,  String? billId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptScan() when $default != null:
return $default(_that.id,_that.status,_that.provider,_that.overallConfidence,_that.needsReview,_that.parsedReceipt,_that.imageUrl,_that.errorMessage,_that.billId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ScanStatus status,  String provider,  double? overallConfidence,  bool needsReview,  ParsedReceipt parsedReceipt,  String imageUrl,  String? errorMessage,  String? billId)  $default,) {final _that = this;
switch (_that) {
case _ReceiptScan():
return $default(_that.id,_that.status,_that.provider,_that.overallConfidence,_that.needsReview,_that.parsedReceipt,_that.imageUrl,_that.errorMessage,_that.billId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ScanStatus status,  String provider,  double? overallConfidence,  bool needsReview,  ParsedReceipt parsedReceipt,  String imageUrl,  String? errorMessage,  String? billId)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptScan() when $default != null:
return $default(_that.id,_that.status,_that.provider,_that.overallConfidence,_that.needsReview,_that.parsedReceipt,_that.imageUrl,_that.errorMessage,_that.billId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptScan implements ReceiptScan {
  const _ReceiptScan({required this.id, required this.status, required this.provider, this.overallConfidence, this.needsReview = false, required this.parsedReceipt, required this.imageUrl, this.errorMessage, this.billId});
  factory _ReceiptScan.fromJson(Map<String, dynamic> json) => _$ReceiptScanFromJson(json);

@override final  String id;
@override final  ScanStatus status;
@override final  String provider;
@override final  double? overallConfidence;
/// Server-computed (`ParsedReceipt.needsReview()`, true when
/// `overallConfidence < 0.7`) — the one threshold every client should use
/// rather than guessing its own cutoff.
@override@JsonKey() final  bool needsReview;
@override final  ParsedReceipt parsedReceipt;
@override final  String imageUrl;
@override final  String? errorMessage;
@override final  String? billId;

/// Create a copy of ReceiptScan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptScanCopyWith<_ReceiptScan> get copyWith => __$ReceiptScanCopyWithImpl<_ReceiptScan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptScanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptScan&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.overallConfidence, overallConfidence) || other.overallConfidence == overallConfidence)&&(identical(other.needsReview, needsReview) || other.needsReview == needsReview)&&(identical(other.parsedReceipt, parsedReceipt) || other.parsedReceipt == parsedReceipt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.billId, billId) || other.billId == billId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,provider,overallConfidence,needsReview,parsedReceipt,imageUrl,errorMessage,billId);

@override
String toString() {
  return 'ReceiptScan(id: $id, status: $status, provider: $provider, overallConfidence: $overallConfidence, needsReview: $needsReview, parsedReceipt: $parsedReceipt, imageUrl: $imageUrl, errorMessage: $errorMessage, billId: $billId)';
}


}

/// @nodoc
abstract mixin class _$ReceiptScanCopyWith<$Res> implements $ReceiptScanCopyWith<$Res> {
  factory _$ReceiptScanCopyWith(_ReceiptScan value, $Res Function(_ReceiptScan) _then) = __$ReceiptScanCopyWithImpl;
@override @useResult
$Res call({
 String id, ScanStatus status, String provider, double? overallConfidence, bool needsReview, ParsedReceipt parsedReceipt, String imageUrl, String? errorMessage, String? billId
});


@override $ParsedReceiptCopyWith<$Res> get parsedReceipt;

}
/// @nodoc
class __$ReceiptScanCopyWithImpl<$Res>
    implements _$ReceiptScanCopyWith<$Res> {
  __$ReceiptScanCopyWithImpl(this._self, this._then);

  final _ReceiptScan _self;
  final $Res Function(_ReceiptScan) _then;

/// Create a copy of ReceiptScan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? provider = null,Object? overallConfidence = freezed,Object? needsReview = null,Object? parsedReceipt = null,Object? imageUrl = null,Object? errorMessage = freezed,Object? billId = freezed,}) {
  return _then(_ReceiptScan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanStatus,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,overallConfidence: freezed == overallConfidence ? _self.overallConfidence : overallConfidence // ignore: cast_nullable_to_non_nullable
as double?,needsReview: null == needsReview ? _self.needsReview : needsReview // ignore: cast_nullable_to_non_nullable
as bool,parsedReceipt: null == parsedReceipt ? _self.parsedReceipt : parsedReceipt // ignore: cast_nullable_to_non_nullable
as ParsedReceipt,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,billId: freezed == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ReceiptScan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParsedReceiptCopyWith<$Res> get parsedReceipt {
  
  return $ParsedReceiptCopyWith<$Res>(_self.parsedReceipt, (value) {
    return _then(_self.copyWith(parsedReceipt: value));
  });
}
}

// dart format on
