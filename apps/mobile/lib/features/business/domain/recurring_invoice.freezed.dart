// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringInvoiceLineItem {

 String get id; String? get productId; String get description;@AmountConverter() String get quantity;@AmountConverter() String get unitPrice;
/// Create a copy of RecurringInvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringInvoiceLineItemCopyWith<RecurringInvoiceLineItem> get copyWith => _$RecurringInvoiceLineItemCopyWithImpl<RecurringInvoiceLineItem>(this as RecurringInvoiceLineItem, _$identity);

  /// Serializes this RecurringInvoiceLineItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringInvoiceLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,description,quantity,unitPrice);

@override
String toString() {
  return 'RecurringInvoiceLineItem(id: $id, productId: $productId, description: $description, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class $RecurringInvoiceLineItemCopyWith<$Res>  {
  factory $RecurringInvoiceLineItemCopyWith(RecurringInvoiceLineItem value, $Res Function(RecurringInvoiceLineItem) _then) = _$RecurringInvoiceLineItemCopyWithImpl;
@useResult
$Res call({
 String id, String? productId, String description,@AmountConverter() String quantity,@AmountConverter() String unitPrice
});




}
/// @nodoc
class _$RecurringInvoiceLineItemCopyWithImpl<$Res>
    implements $RecurringInvoiceLineItemCopyWith<$Res> {
  _$RecurringInvoiceLineItemCopyWithImpl(this._self, this._then);

  final RecurringInvoiceLineItem _self;
  final $Res Function(RecurringInvoiceLineItem) _then;

/// Create a copy of RecurringInvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? description = null,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(RecurringInvoiceLineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringInvoiceLineItem].
extension RecurringInvoiceLineItemPatterns on RecurringInvoiceLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringInvoiceLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringInvoiceLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringInvoiceLineItem value)  $default,){
final _that = this;
switch (_that) {
case _RecurringInvoiceLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringInvoiceLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringInvoiceLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? productId,  String description, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringInvoiceLineItem() when $default != null:
return $default(_that.id,_that.productId,_that.description,_that.quantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? productId,  String description, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice)  $default,) {final _that = this;
switch (_that) {
case _RecurringInvoiceLineItem():
return $default(_that.id,_that.productId,_that.description,_that.quantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? productId,  String description, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice)?  $default,) {final _that = this;
switch (_that) {
case _RecurringInvoiceLineItem() when $default != null:
return $default(_that.id,_that.productId,_that.description,_that.quantity,_that.unitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringInvoiceLineItem implements RecurringInvoiceLineItem {
  const _RecurringInvoiceLineItem({required this.id, this.productId, required this.description, @AmountConverter() required this.quantity, @AmountConverter() required this.unitPrice});
  factory _RecurringInvoiceLineItem.fromJson(Map<String, dynamic> json) => _$RecurringInvoiceLineItemFromJson(json);

@override final  String id;
@override final  String? productId;
@override final  String description;
@override@AmountConverter() final  String quantity;
@override@AmountConverter() final  String unitPrice;

/// Create a copy of RecurringInvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringInvoiceLineItemCopyWith<_RecurringInvoiceLineItem> get copyWith => __$RecurringInvoiceLineItemCopyWithImpl<_RecurringInvoiceLineItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringInvoiceLineItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringInvoiceLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,description,quantity,unitPrice);

@override
String toString() {
  return 'RecurringInvoiceLineItem(id: $id, productId: $productId, description: $description, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class _$RecurringInvoiceLineItemCopyWith<$Res> implements $RecurringInvoiceLineItemCopyWith<$Res> {
  factory _$RecurringInvoiceLineItemCopyWith(_RecurringInvoiceLineItem value, $Res Function(_RecurringInvoiceLineItem) _then) = __$RecurringInvoiceLineItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String? productId, String description,@AmountConverter() String quantity,@AmountConverter() String unitPrice
});




}
/// @nodoc
class __$RecurringInvoiceLineItemCopyWithImpl<$Res>
    implements _$RecurringInvoiceLineItemCopyWith<$Res> {
  __$RecurringInvoiceLineItemCopyWithImpl(this._self, this._then);

  final _RecurringInvoiceLineItem _self;
  final $Res Function(_RecurringInvoiceLineItem) _then;

/// Create a copy of RecurringInvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? description = null,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_RecurringInvoiceLineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RecurringInvoice {

 String get id; String get customerId;@NullableAmountConverter() String? get taxPercent; String? get notes; int? get paymentTermDays; RecurrenceFrequency get frequency; int get intervalCount; String get startDate; String? get endDate; String get nextOccurrenceDate; bool get active; List<RecurringInvoiceLineItem> get lineItems;
/// Create a copy of RecurringInvoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringInvoiceCopyWith<RecurringInvoice> get copyWith => _$RecurringInvoiceCopyWithImpl<RecurringInvoice>(this as RecurringInvoice, _$identity);

  /// Serializes this RecurringInvoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringInvoice&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentTermDays, paymentTermDays) || other.paymentTermDays == paymentTermDays)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.intervalCount, intervalCount) || other.intervalCount == intervalCount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextOccurrenceDate, nextOccurrenceDate) || other.nextOccurrenceDate == nextOccurrenceDate)&&(identical(other.active, active) || other.active == active)&&const DeepCollectionEquality().equals(other.lineItems, lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,taxPercent,notes,paymentTermDays,frequency,intervalCount,startDate,endDate,nextOccurrenceDate,active,const DeepCollectionEquality().hash(lineItems));

@override
String toString() {
  return 'RecurringInvoice(id: $id, customerId: $customerId, taxPercent: $taxPercent, notes: $notes, paymentTermDays: $paymentTermDays, frequency: $frequency, intervalCount: $intervalCount, startDate: $startDate, endDate: $endDate, nextOccurrenceDate: $nextOccurrenceDate, active: $active, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class $RecurringInvoiceCopyWith<$Res>  {
  factory $RecurringInvoiceCopyWith(RecurringInvoice value, $Res Function(RecurringInvoice) _then) = _$RecurringInvoiceCopyWithImpl;
@useResult
$Res call({
 String id, String customerId,@NullableAmountConverter() String? taxPercent, String? notes, int? paymentTermDays, RecurrenceFrequency frequency, int intervalCount, String startDate, String? endDate, String nextOccurrenceDate, bool active, List<RecurringInvoiceLineItem> lineItems
});




}
/// @nodoc
class _$RecurringInvoiceCopyWithImpl<$Res>
    implements $RecurringInvoiceCopyWith<$Res> {
  _$RecurringInvoiceCopyWithImpl(this._self, this._then);

  final RecurringInvoice _self;
  final $Res Function(RecurringInvoice) _then;

/// Create a copy of RecurringInvoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? taxPercent = freezed,Object? notes = freezed,Object? paymentTermDays = freezed,Object? frequency = null,Object? intervalCount = null,Object? startDate = null,Object? endDate = freezed,Object? nextOccurrenceDate = null,Object? active = null,Object? lineItems = null,}) {
  return _then(RecurringInvoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,taxPercent: freezed == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentTermDays: freezed == paymentTermDays ? _self.paymentTermDays : paymentTermDays // ignore: cast_nullable_to_non_nullable
as int?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,intervalCount: null == intervalCount ? _self.intervalCount : intervalCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,nextOccurrenceDate: null == nextOccurrenceDate ? _self.nextOccurrenceDate : nextOccurrenceDate // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,lineItems: null == lineItems ? _self.lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<RecurringInvoiceLineItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringInvoice].
extension RecurringInvoicePatterns on RecurringInvoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringInvoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringInvoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringInvoice value)  $default,){
final _that = this;
switch (_that) {
case _RecurringInvoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringInvoice value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringInvoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId, @NullableAmountConverter()  String? taxPercent,  String? notes,  int? paymentTermDays,  RecurrenceFrequency frequency,  int intervalCount,  String startDate,  String? endDate,  String nextOccurrenceDate,  bool active,  List<RecurringInvoiceLineItem> lineItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringInvoice() when $default != null:
return $default(_that.id,_that.customerId,_that.taxPercent,_that.notes,_that.paymentTermDays,_that.frequency,_that.intervalCount,_that.startDate,_that.endDate,_that.nextOccurrenceDate,_that.active,_that.lineItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId, @NullableAmountConverter()  String? taxPercent,  String? notes,  int? paymentTermDays,  RecurrenceFrequency frequency,  int intervalCount,  String startDate,  String? endDate,  String nextOccurrenceDate,  bool active,  List<RecurringInvoiceLineItem> lineItems)  $default,) {final _that = this;
switch (_that) {
case _RecurringInvoice():
return $default(_that.id,_that.customerId,_that.taxPercent,_that.notes,_that.paymentTermDays,_that.frequency,_that.intervalCount,_that.startDate,_that.endDate,_that.nextOccurrenceDate,_that.active,_that.lineItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId, @NullableAmountConverter()  String? taxPercent,  String? notes,  int? paymentTermDays,  RecurrenceFrequency frequency,  int intervalCount,  String startDate,  String? endDate,  String nextOccurrenceDate,  bool active,  List<RecurringInvoiceLineItem> lineItems)?  $default,) {final _that = this;
switch (_that) {
case _RecurringInvoice() when $default != null:
return $default(_that.id,_that.customerId,_that.taxPercent,_that.notes,_that.paymentTermDays,_that.frequency,_that.intervalCount,_that.startDate,_that.endDate,_that.nextOccurrenceDate,_that.active,_that.lineItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringInvoice implements RecurringInvoice {
  const _RecurringInvoice({required this.id, required this.customerId, @NullableAmountConverter() this.taxPercent, this.notes, this.paymentTermDays, required this.frequency, required this.intervalCount, required this.startDate, this.endDate, required this.nextOccurrenceDate, required this.active, required  List<RecurringInvoiceLineItem> lineItems}): _lineItems = lineItems;
  factory _RecurringInvoice.fromJson(Map<String, dynamic> json) => _$RecurringInvoiceFromJson(json);

@override final  String id;
@override final  String customerId;
@override@NullableAmountConverter() final  String? taxPercent;
@override final  String? notes;
@override final  int? paymentTermDays;
@override final  RecurrenceFrequency frequency;
@override final  int intervalCount;
@override final  String startDate;
@override final  String? endDate;
@override final  String nextOccurrenceDate;
@override final  bool active;
 final  List<RecurringInvoiceLineItem> _lineItems;
@override List<RecurringInvoiceLineItem> get lineItems {
  if (_lineItems is EqualUnmodifiableListView) return _lineItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineItems);
}


/// Create a copy of RecurringInvoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringInvoiceCopyWith<_RecurringInvoice> get copyWith => __$RecurringInvoiceCopyWithImpl<_RecurringInvoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringInvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringInvoice&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentTermDays, paymentTermDays) || other.paymentTermDays == paymentTermDays)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.intervalCount, intervalCount) || other.intervalCount == intervalCount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextOccurrenceDate, nextOccurrenceDate) || other.nextOccurrenceDate == nextOccurrenceDate)&&(identical(other.active, active) || other.active == active)&&const DeepCollectionEquality().equals(other._lineItems, _lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,taxPercent,notes,paymentTermDays,frequency,intervalCount,startDate,endDate,nextOccurrenceDate,active,const DeepCollectionEquality().hash(_lineItems));

@override
String toString() {
  return 'RecurringInvoice(id: $id, customerId: $customerId, taxPercent: $taxPercent, notes: $notes, paymentTermDays: $paymentTermDays, frequency: $frequency, intervalCount: $intervalCount, startDate: $startDate, endDate: $endDate, nextOccurrenceDate: $nextOccurrenceDate, active: $active, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class _$RecurringInvoiceCopyWith<$Res> implements $RecurringInvoiceCopyWith<$Res> {
  factory _$RecurringInvoiceCopyWith(_RecurringInvoice value, $Res Function(_RecurringInvoice) _then) = __$RecurringInvoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId,@NullableAmountConverter() String? taxPercent, String? notes, int? paymentTermDays, RecurrenceFrequency frequency, int intervalCount, String startDate, String? endDate, String nextOccurrenceDate, bool active, List<RecurringInvoiceLineItem> lineItems
});




}
/// @nodoc
class __$RecurringInvoiceCopyWithImpl<$Res>
    implements _$RecurringInvoiceCopyWith<$Res> {
  __$RecurringInvoiceCopyWithImpl(this._self, this._then);

  final _RecurringInvoice _self;
  final $Res Function(_RecurringInvoice) _then;

/// Create a copy of RecurringInvoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? taxPercent = freezed,Object? notes = freezed,Object? paymentTermDays = freezed,Object? frequency = null,Object? intervalCount = null,Object? startDate = null,Object? endDate = freezed,Object? nextOccurrenceDate = null,Object? active = null,Object? lineItems = null,}) {
  return _then(_RecurringInvoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,taxPercent: freezed == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentTermDays: freezed == paymentTermDays ? _self.paymentTermDays : paymentTermDays // ignore: cast_nullable_to_non_nullable
as int?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,intervalCount: null == intervalCount ? _self.intervalCount : intervalCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,nextOccurrenceDate: null == nextOccurrenceDate ? _self.nextOccurrenceDate : nextOccurrenceDate // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,lineItems: null == lineItems ? _self._lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<RecurringInvoiceLineItem>,
  ));
}


}

// dart format on
