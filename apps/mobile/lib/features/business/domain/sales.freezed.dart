// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LineItem {

 String get id; String? get productId; String get description;@AmountConverter() String get quantity;@AmountConverter() String get unitPrice;@AmountConverter() String get lineTotal;
/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineItemCopyWith<LineItem> get copyWith => _$LineItemCopyWithImpl<LineItem>(this as LineItem, _$identity);

  /// Serializes this LineItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,description,quantity,unitPrice,lineTotal);

@override
String toString() {
  return 'LineItem(id: $id, productId: $productId, description: $description, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class $LineItemCopyWith<$Res>  {
  factory $LineItemCopyWith(LineItem value, $Res Function(LineItem) _then) = _$LineItemCopyWithImpl;
@useResult
$Res call({
 String id, String? productId, String description,@AmountConverter() String quantity,@AmountConverter() String unitPrice,@AmountConverter() String lineTotal
});




}
/// @nodoc
class _$LineItemCopyWithImpl<$Res>
    implements $LineItemCopyWith<$Res> {
  _$LineItemCopyWithImpl(this._self, this._then);

  final LineItem _self;
  final $Res Function(LineItem) _then;

/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? description = null,Object? quantity = null,Object? unitPrice = null,Object? lineTotal = null,}) {
  return _then(LineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LineItem].
extension LineItemPatterns on LineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineItem value)  $default,){
final _that = this;
switch (_that) {
case _LineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineItem value)?  $default,){
final _that = this;
switch (_that) {
case _LineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? productId,  String description, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice, @AmountConverter()  String lineTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineItem() when $default != null:
return $default(_that.id,_that.productId,_that.description,_that.quantity,_that.unitPrice,_that.lineTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? productId,  String description, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice, @AmountConverter()  String lineTotal)  $default,) {final _that = this;
switch (_that) {
case _LineItem():
return $default(_that.id,_that.productId,_that.description,_that.quantity,_that.unitPrice,_that.lineTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? productId,  String description, @AmountConverter()  String quantity, @AmountConverter()  String unitPrice, @AmountConverter()  String lineTotal)?  $default,) {final _that = this;
switch (_that) {
case _LineItem() when $default != null:
return $default(_that.id,_that.productId,_that.description,_that.quantity,_that.unitPrice,_that.lineTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineItem implements LineItem {
  const _LineItem({required this.id, this.productId, required this.description, @AmountConverter() required this.quantity, @AmountConverter() required this.unitPrice, @AmountConverter() required this.lineTotal});
  factory _LineItem.fromJson(Map<String, dynamic> json) => _$LineItemFromJson(json);

@override final  String id;
@override final  String? productId;
@override final  String description;
@override@AmountConverter() final  String quantity;
@override@AmountConverter() final  String unitPrice;
@override@AmountConverter() final  String lineTotal;

/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineItemCopyWith<_LineItem> get copyWith => __$LineItemCopyWithImpl<_LineItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,description,quantity,unitPrice,lineTotal);

@override
String toString() {
  return 'LineItem(id: $id, productId: $productId, description: $description, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class _$LineItemCopyWith<$Res> implements $LineItemCopyWith<$Res> {
  factory _$LineItemCopyWith(_LineItem value, $Res Function(_LineItem) _then) = __$LineItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String? productId, String description,@AmountConverter() String quantity,@AmountConverter() String unitPrice,@AmountConverter() String lineTotal
});




}
/// @nodoc
class __$LineItemCopyWithImpl<$Res>
    implements _$LineItemCopyWith<$Res> {
  __$LineItemCopyWithImpl(this._self, this._then);

  final _LineItem _self;
  final $Res Function(_LineItem) _then;

/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? description = null,Object? quantity = null,Object? unitPrice = null,Object? lineTotal = null,}) {
  return _then(_LineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as String,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Quotation {

 String get id; String get customerId; String get quoteNumber; String get issueDate; String? get expiryDate; QuotationStatus get status;@AmountConverter() String get taxPercent;@AmountConverter() String get subtotal;@AmountConverter() String get taxAmount;@AmountConverter() String get total; String? get notes; List<LineItem> get lineItems;
/// Create a copy of Quotation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationCopyWith<Quotation> get copyWith => _$QuotationCopyWithImpl<Quotation>(this as Quotation, _$identity);

  /// Serializes this Quotation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quotation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.quoteNumber, quoteNumber) || other.quoteNumber == quoteNumber)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.total, total) || other.total == total)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.lineItems, lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,quoteNumber,issueDate,expiryDate,status,taxPercent,subtotal,taxAmount,total,notes,const DeepCollectionEquality().hash(lineItems));

@override
String toString() {
  return 'Quotation(id: $id, customerId: $customerId, quoteNumber: $quoteNumber, issueDate: $issueDate, expiryDate: $expiryDate, status: $status, taxPercent: $taxPercent, subtotal: $subtotal, taxAmount: $taxAmount, total: $total, notes: $notes, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class $QuotationCopyWith<$Res>  {
  factory $QuotationCopyWith(Quotation value, $Res Function(Quotation) _then) = _$QuotationCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, String quoteNumber, String issueDate, String? expiryDate, QuotationStatus status,@AmountConverter() String taxPercent,@AmountConverter() String subtotal,@AmountConverter() String taxAmount,@AmountConverter() String total, String? notes, List<LineItem> lineItems
});




}
/// @nodoc
class _$QuotationCopyWithImpl<$Res>
    implements $QuotationCopyWith<$Res> {
  _$QuotationCopyWithImpl(this._self, this._then);

  final Quotation _self;
  final $Res Function(Quotation) _then;

/// Create a copy of Quotation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? quoteNumber = null,Object? issueDate = null,Object? expiryDate = freezed,Object? status = null,Object? taxPercent = null,Object? subtotal = null,Object? taxAmount = null,Object? total = null,Object? notes = freezed,Object? lineItems = null,}) {
  return _then(Quotation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,quoteNumber: null == quoteNumber ? _self.quoteNumber : quoteNumber // ignore: cast_nullable_to_non_nullable
as String,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuotationStatus,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lineItems: null == lineItems ? _self.lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<LineItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Quotation].
extension QuotationPatterns on Quotation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quotation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quotation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quotation value)  $default,){
final _that = this;
switch (_that) {
case _Quotation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quotation value)?  $default,){
final _that = this;
switch (_that) {
case _Quotation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  String quoteNumber,  String issueDate,  String? expiryDate,  QuotationStatus status, @AmountConverter()  String taxPercent, @AmountConverter()  String subtotal, @AmountConverter()  String taxAmount, @AmountConverter()  String total,  String? notes,  List<LineItem> lineItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quotation() when $default != null:
return $default(_that.id,_that.customerId,_that.quoteNumber,_that.issueDate,_that.expiryDate,_that.status,_that.taxPercent,_that.subtotal,_that.taxAmount,_that.total,_that.notes,_that.lineItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  String quoteNumber,  String issueDate,  String? expiryDate,  QuotationStatus status, @AmountConverter()  String taxPercent, @AmountConverter()  String subtotal, @AmountConverter()  String taxAmount, @AmountConverter()  String total,  String? notes,  List<LineItem> lineItems)  $default,) {final _that = this;
switch (_that) {
case _Quotation():
return $default(_that.id,_that.customerId,_that.quoteNumber,_that.issueDate,_that.expiryDate,_that.status,_that.taxPercent,_that.subtotal,_that.taxAmount,_that.total,_that.notes,_that.lineItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  String quoteNumber,  String issueDate,  String? expiryDate,  QuotationStatus status, @AmountConverter()  String taxPercent, @AmountConverter()  String subtotal, @AmountConverter()  String taxAmount, @AmountConverter()  String total,  String? notes,  List<LineItem> lineItems)?  $default,) {final _that = this;
switch (_that) {
case _Quotation() when $default != null:
return $default(_that.id,_that.customerId,_that.quoteNumber,_that.issueDate,_that.expiryDate,_that.status,_that.taxPercent,_that.subtotal,_that.taxAmount,_that.total,_that.notes,_that.lineItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quotation implements Quotation {
  const _Quotation({required this.id, required this.customerId, required this.quoteNumber, required this.issueDate, this.expiryDate, required this.status, @AmountConverter() required this.taxPercent, @AmountConverter() required this.subtotal, @AmountConverter() required this.taxAmount, @AmountConverter() required this.total, this.notes, required  List<LineItem> lineItems}): _lineItems = lineItems;
  factory _Quotation.fromJson(Map<String, dynamic> json) => _$QuotationFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  String quoteNumber;
@override final  String issueDate;
@override final  String? expiryDate;
@override final  QuotationStatus status;
@override@AmountConverter() final  String taxPercent;
@override@AmountConverter() final  String subtotal;
@override@AmountConverter() final  String taxAmount;
@override@AmountConverter() final  String total;
@override final  String? notes;
 final  List<LineItem> _lineItems;
@override List<LineItem> get lineItems {
  if (_lineItems is EqualUnmodifiableListView) return _lineItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineItems);
}


/// Create a copy of Quotation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationCopyWith<_Quotation> get copyWith => __$QuotationCopyWithImpl<_Quotation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quotation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.quoteNumber, quoteNumber) || other.quoteNumber == quoteNumber)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.total, total) || other.total == total)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._lineItems, _lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,quoteNumber,issueDate,expiryDate,status,taxPercent,subtotal,taxAmount,total,notes,const DeepCollectionEquality().hash(_lineItems));

@override
String toString() {
  return 'Quotation(id: $id, customerId: $customerId, quoteNumber: $quoteNumber, issueDate: $issueDate, expiryDate: $expiryDate, status: $status, taxPercent: $taxPercent, subtotal: $subtotal, taxAmount: $taxAmount, total: $total, notes: $notes, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class _$QuotationCopyWith<$Res> implements $QuotationCopyWith<$Res> {
  factory _$QuotationCopyWith(_Quotation value, $Res Function(_Quotation) _then) = __$QuotationCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, String quoteNumber, String issueDate, String? expiryDate, QuotationStatus status,@AmountConverter() String taxPercent,@AmountConverter() String subtotal,@AmountConverter() String taxAmount,@AmountConverter() String total, String? notes, List<LineItem> lineItems
});




}
/// @nodoc
class __$QuotationCopyWithImpl<$Res>
    implements _$QuotationCopyWith<$Res> {
  __$QuotationCopyWithImpl(this._self, this._then);

  final _Quotation _self;
  final $Res Function(_Quotation) _then;

/// Create a copy of Quotation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? quoteNumber = null,Object? issueDate = null,Object? expiryDate = freezed,Object? status = null,Object? taxPercent = null,Object? subtotal = null,Object? taxAmount = null,Object? total = null,Object? notes = freezed,Object? lineItems = null,}) {
  return _then(_Quotation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,quoteNumber: null == quoteNumber ? _self.quoteNumber : quoteNumber // ignore: cast_nullable_to_non_nullable
as String,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuotationStatus,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lineItems: null == lineItems ? _self._lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<LineItem>,
  ));
}


}


/// @nodoc
mixin _$Invoice {

 String get id; String get customerId; String get invoiceNumber; String get issueDate; String get dueDate; InvoiceStatus get status; InvoiceEffectiveStatus get effectiveStatus;@AmountConverter() String get taxPercent;@AmountConverter() String get subtotal;@AmountConverter() String get taxAmount;@AmountConverter() String get total;@AmountConverter() String get amountPaid;@AmountConverter() String get amountCredited;@AmountConverter() String get amountOutstanding; String? get convertedFromQuotationId;/// Set when this invoice was auto-materialized by a
/// [RecurringInvoice]'s daily scheduler rather than created directly —
/// always `DRAFT` on creation either way (see `RecurringInvoiceService`
/// docs), so this is purely provenance, never a different lifecycle.
 String? get sourceRecurringInvoiceId; String? get notes; List<LineItem> get lineItems;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.effectiveStatus, effectiveStatus) || other.effectiveStatus == effectiveStatus)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.total, total) || other.total == total)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountCredited, amountCredited) || other.amountCredited == amountCredited)&&(identical(other.amountOutstanding, amountOutstanding) || other.amountOutstanding == amountOutstanding)&&(identical(other.convertedFromQuotationId, convertedFromQuotationId) || other.convertedFromQuotationId == convertedFromQuotationId)&&(identical(other.sourceRecurringInvoiceId, sourceRecurringInvoiceId) || other.sourceRecurringInvoiceId == sourceRecurringInvoiceId)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.lineItems, lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,invoiceNumber,issueDate,dueDate,status,effectiveStatus,taxPercent,subtotal,taxAmount,total,amountPaid,amountCredited,amountOutstanding,convertedFromQuotationId,sourceRecurringInvoiceId,notes,const DeepCollectionEquality().hash(lineItems));

@override
String toString() {
  return 'Invoice(id: $id, customerId: $customerId, invoiceNumber: $invoiceNumber, issueDate: $issueDate, dueDate: $dueDate, status: $status, effectiveStatus: $effectiveStatus, taxPercent: $taxPercent, subtotal: $subtotal, taxAmount: $taxAmount, total: $total, amountPaid: $amountPaid, amountCredited: $amountCredited, amountOutstanding: $amountOutstanding, convertedFromQuotationId: $convertedFromQuotationId, sourceRecurringInvoiceId: $sourceRecurringInvoiceId, notes: $notes, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, String invoiceNumber, String issueDate, String dueDate, InvoiceStatus status, InvoiceEffectiveStatus effectiveStatus,@AmountConverter() String taxPercent,@AmountConverter() String subtotal,@AmountConverter() String taxAmount,@AmountConverter() String total,@AmountConverter() String amountPaid,@AmountConverter() String amountCredited,@AmountConverter() String amountOutstanding, String? convertedFromQuotationId, String? sourceRecurringInvoiceId, String? notes, List<LineItem> lineItems
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? invoiceNumber = null,Object? issueDate = null,Object? dueDate = null,Object? status = null,Object? effectiveStatus = null,Object? taxPercent = null,Object? subtotal = null,Object? taxAmount = null,Object? total = null,Object? amountPaid = null,Object? amountCredited = null,Object? amountOutstanding = null,Object? convertedFromQuotationId = freezed,Object? sourceRecurringInvoiceId = freezed,Object? notes = freezed,Object? lineItems = null,}) {
  return _then(Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,effectiveStatus: null == effectiveStatus ? _self.effectiveStatus : effectiveStatus // ignore: cast_nullable_to_non_nullable
as InvoiceEffectiveStatus,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,amountCredited: null == amountCredited ? _self.amountCredited : amountCredited // ignore: cast_nullable_to_non_nullable
as String,amountOutstanding: null == amountOutstanding ? _self.amountOutstanding : amountOutstanding // ignore: cast_nullable_to_non_nullable
as String,convertedFromQuotationId: freezed == convertedFromQuotationId ? _self.convertedFromQuotationId : convertedFromQuotationId // ignore: cast_nullable_to_non_nullable
as String?,sourceRecurringInvoiceId: freezed == sourceRecurringInvoiceId ? _self.sourceRecurringInvoiceId : sourceRecurringInvoiceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lineItems: null == lineItems ? _self.lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<LineItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  String invoiceNumber,  String issueDate,  String dueDate,  InvoiceStatus status,  InvoiceEffectiveStatus effectiveStatus, @AmountConverter()  String taxPercent, @AmountConverter()  String subtotal, @AmountConverter()  String taxAmount, @AmountConverter()  String total, @AmountConverter()  String amountPaid, @AmountConverter()  String amountCredited, @AmountConverter()  String amountOutstanding,  String? convertedFromQuotationId,  String? sourceRecurringInvoiceId,  String? notes,  List<LineItem> lineItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.customerId,_that.invoiceNumber,_that.issueDate,_that.dueDate,_that.status,_that.effectiveStatus,_that.taxPercent,_that.subtotal,_that.taxAmount,_that.total,_that.amountPaid,_that.amountCredited,_that.amountOutstanding,_that.convertedFromQuotationId,_that.sourceRecurringInvoiceId,_that.notes,_that.lineItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  String invoiceNumber,  String issueDate,  String dueDate,  InvoiceStatus status,  InvoiceEffectiveStatus effectiveStatus, @AmountConverter()  String taxPercent, @AmountConverter()  String subtotal, @AmountConverter()  String taxAmount, @AmountConverter()  String total, @AmountConverter()  String amountPaid, @AmountConverter()  String amountCredited, @AmountConverter()  String amountOutstanding,  String? convertedFromQuotationId,  String? sourceRecurringInvoiceId,  String? notes,  List<LineItem> lineItems)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.customerId,_that.invoiceNumber,_that.issueDate,_that.dueDate,_that.status,_that.effectiveStatus,_that.taxPercent,_that.subtotal,_that.taxAmount,_that.total,_that.amountPaid,_that.amountCredited,_that.amountOutstanding,_that.convertedFromQuotationId,_that.sourceRecurringInvoiceId,_that.notes,_that.lineItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  String invoiceNumber,  String issueDate,  String dueDate,  InvoiceStatus status,  InvoiceEffectiveStatus effectiveStatus, @AmountConverter()  String taxPercent, @AmountConverter()  String subtotal, @AmountConverter()  String taxAmount, @AmountConverter()  String total, @AmountConverter()  String amountPaid, @AmountConverter()  String amountCredited, @AmountConverter()  String amountOutstanding,  String? convertedFromQuotationId,  String? sourceRecurringInvoiceId,  String? notes,  List<LineItem> lineItems)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.customerId,_that.invoiceNumber,_that.issueDate,_that.dueDate,_that.status,_that.effectiveStatus,_that.taxPercent,_that.subtotal,_that.taxAmount,_that.total,_that.amountPaid,_that.amountCredited,_that.amountOutstanding,_that.convertedFromQuotationId,_that.sourceRecurringInvoiceId,_that.notes,_that.lineItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice implements Invoice {
  const _Invoice({required this.id, required this.customerId, required this.invoiceNumber, required this.issueDate, required this.dueDate, required this.status, required this.effectiveStatus, @AmountConverter() required this.taxPercent, @AmountConverter() required this.subtotal, @AmountConverter() required this.taxAmount, @AmountConverter() required this.total, @AmountConverter() required this.amountPaid, @AmountConverter() required this.amountCredited, @AmountConverter() required this.amountOutstanding, this.convertedFromQuotationId, this.sourceRecurringInvoiceId, this.notes, required  List<LineItem> lineItems}): _lineItems = lineItems;
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  String invoiceNumber;
@override final  String issueDate;
@override final  String dueDate;
@override final  InvoiceStatus status;
@override final  InvoiceEffectiveStatus effectiveStatus;
@override@AmountConverter() final  String taxPercent;
@override@AmountConverter() final  String subtotal;
@override@AmountConverter() final  String taxAmount;
@override@AmountConverter() final  String total;
@override@AmountConverter() final  String amountPaid;
@override@AmountConverter() final  String amountCredited;
@override@AmountConverter() final  String amountOutstanding;
@override final  String? convertedFromQuotationId;
/// Set when this invoice was auto-materialized by a
/// [RecurringInvoice]'s daily scheduler rather than created directly —
/// always `DRAFT` on creation either way (see `RecurringInvoiceService`
/// docs), so this is purely provenance, never a different lifecycle.
@override final  String? sourceRecurringInvoiceId;
@override final  String? notes;
 final  List<LineItem> _lineItems;
@override List<LineItem> get lineItems {
  if (_lineItems is EqualUnmodifiableListView) return _lineItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineItems);
}


/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.effectiveStatus, effectiveStatus) || other.effectiveStatus == effectiveStatus)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.total, total) || other.total == total)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountCredited, amountCredited) || other.amountCredited == amountCredited)&&(identical(other.amountOutstanding, amountOutstanding) || other.amountOutstanding == amountOutstanding)&&(identical(other.convertedFromQuotationId, convertedFromQuotationId) || other.convertedFromQuotationId == convertedFromQuotationId)&&(identical(other.sourceRecurringInvoiceId, sourceRecurringInvoiceId) || other.sourceRecurringInvoiceId == sourceRecurringInvoiceId)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._lineItems, _lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,invoiceNumber,issueDate,dueDate,status,effectiveStatus,taxPercent,subtotal,taxAmount,total,amountPaid,amountCredited,amountOutstanding,convertedFromQuotationId,sourceRecurringInvoiceId,notes,const DeepCollectionEquality().hash(_lineItems));

@override
String toString() {
  return 'Invoice(id: $id, customerId: $customerId, invoiceNumber: $invoiceNumber, issueDate: $issueDate, dueDate: $dueDate, status: $status, effectiveStatus: $effectiveStatus, taxPercent: $taxPercent, subtotal: $subtotal, taxAmount: $taxAmount, total: $total, amountPaid: $amountPaid, amountCredited: $amountCredited, amountOutstanding: $amountOutstanding, convertedFromQuotationId: $convertedFromQuotationId, sourceRecurringInvoiceId: $sourceRecurringInvoiceId, notes: $notes, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, String invoiceNumber, String issueDate, String dueDate, InvoiceStatus status, InvoiceEffectiveStatus effectiveStatus,@AmountConverter() String taxPercent,@AmountConverter() String subtotal,@AmountConverter() String taxAmount,@AmountConverter() String total,@AmountConverter() String amountPaid,@AmountConverter() String amountCredited,@AmountConverter() String amountOutstanding, String? convertedFromQuotationId, String? sourceRecurringInvoiceId, String? notes, List<LineItem> lineItems
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? invoiceNumber = null,Object? issueDate = null,Object? dueDate = null,Object? status = null,Object? effectiveStatus = null,Object? taxPercent = null,Object? subtotal = null,Object? taxAmount = null,Object? total = null,Object? amountPaid = null,Object? amountCredited = null,Object? amountOutstanding = null,Object? convertedFromQuotationId = freezed,Object? sourceRecurringInvoiceId = freezed,Object? notes = freezed,Object? lineItems = null,}) {
  return _then(_Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,effectiveStatus: null == effectiveStatus ? _self.effectiveStatus : effectiveStatus // ignore: cast_nullable_to_non_nullable
as InvoiceEffectiveStatus,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,amountCredited: null == amountCredited ? _self.amountCredited : amountCredited // ignore: cast_nullable_to_non_nullable
as String,amountOutstanding: null == amountOutstanding ? _self.amountOutstanding : amountOutstanding // ignore: cast_nullable_to_non_nullable
as String,convertedFromQuotationId: freezed == convertedFromQuotationId ? _self.convertedFromQuotationId : convertedFromQuotationId // ignore: cast_nullable_to_non_nullable
as String?,sourceRecurringInvoiceId: freezed == sourceRecurringInvoiceId ? _self.sourceRecurringInvoiceId : sourceRecurringInvoiceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lineItems: null == lineItems ? _self._lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<LineItem>,
  ));
}


}


/// @nodoc
mixin _$InvoicePayment {

 String get id; String get businessAccountId;@AmountConverter() String get amount; String get paidOn; String? get notes;
/// Create a copy of InvoicePayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePaymentCopyWith<InvoicePayment> get copyWith => _$InvoicePaymentCopyWithImpl<InvoicePayment>(this as InvoicePayment, _$identity);

  /// Serializes this InvoicePayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePayment&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,amount,paidOn,notes);

@override
String toString() {
  return 'InvoicePayment(id: $id, businessAccountId: $businessAccountId, amount: $amount, paidOn: $paidOn, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $InvoicePaymentCopyWith<$Res>  {
  factory $InvoicePaymentCopyWith(InvoicePayment value, $Res Function(InvoicePayment) _then) = _$InvoicePaymentCopyWithImpl;
@useResult
$Res call({
 String id, String businessAccountId,@AmountConverter() String amount, String paidOn, String? notes
});




}
/// @nodoc
class _$InvoicePaymentCopyWithImpl<$Res>
    implements $InvoicePaymentCopyWith<$Res> {
  _$InvoicePaymentCopyWithImpl(this._self, this._then);

  final InvoicePayment _self;
  final $Res Function(InvoicePayment) _then;

/// Create a copy of InvoicePayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessAccountId = null,Object? amount = null,Object? paidOn = null,Object? notes = freezed,}) {
  return _then(InvoicePayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoicePayment].
extension InvoicePaymentPatterns on InvoicePayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicePayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicePayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicePayment value)  $default,){
final _that = this;
switch (_that) {
case _InvoicePayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicePayment value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicePayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessAccountId, @AmountConverter()  String amount,  String paidOn,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicePayment() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.amount,_that.paidOn,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessAccountId, @AmountConverter()  String amount,  String paidOn,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _InvoicePayment():
return $default(_that.id,_that.businessAccountId,_that.amount,_that.paidOn,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessAccountId, @AmountConverter()  String amount,  String paidOn,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _InvoicePayment() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.amount,_that.paidOn,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoicePayment implements InvoicePayment {
  const _InvoicePayment({required this.id, required this.businessAccountId, @AmountConverter() required this.amount, required this.paidOn, this.notes});
  factory _InvoicePayment.fromJson(Map<String, dynamic> json) => _$InvoicePaymentFromJson(json);

@override final  String id;
@override final  String businessAccountId;
@override@AmountConverter() final  String amount;
@override final  String paidOn;
@override final  String? notes;

/// Create a copy of InvoicePayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicePaymentCopyWith<_InvoicePayment> get copyWith => __$InvoicePaymentCopyWithImpl<_InvoicePayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoicePaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicePayment&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,amount,paidOn,notes);

@override
String toString() {
  return 'InvoicePayment(id: $id, businessAccountId: $businessAccountId, amount: $amount, paidOn: $paidOn, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$InvoicePaymentCopyWith<$Res> implements $InvoicePaymentCopyWith<$Res> {
  factory _$InvoicePaymentCopyWith(_InvoicePayment value, $Res Function(_InvoicePayment) _then) = __$InvoicePaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessAccountId,@AmountConverter() String amount, String paidOn, String? notes
});




}
/// @nodoc
class __$InvoicePaymentCopyWithImpl<$Res>
    implements _$InvoicePaymentCopyWith<$Res> {
  __$InvoicePaymentCopyWithImpl(this._self, this._then);

  final _InvoicePayment _self;
  final $Res Function(_InvoicePayment) _then;

/// Create a copy of InvoicePayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessAccountId = null,Object? amount = null,Object? paidOn = null,Object? notes = freezed,}) {
  return _then(_InvoicePayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreditNote {

 String get id; String get customerId; String? get invoiceId; String get creditNoteNumber; String get issueDate;@AmountConverter() String get amount; String? get reason; CreditNoteStatus get status;
/// Create a copy of CreditNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditNoteCopyWith<CreditNote> get copyWith => _$CreditNoteCopyWithImpl<CreditNote>(this as CreditNote, _$identity);

  /// Serializes this CreditNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditNote&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.creditNoteNumber, creditNoteNumber) || other.creditNoteNumber == creditNoteNumber)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,invoiceId,creditNoteNumber,issueDate,amount,reason,status);

@override
String toString() {
  return 'CreditNote(id: $id, customerId: $customerId, invoiceId: $invoiceId, creditNoteNumber: $creditNoteNumber, issueDate: $issueDate, amount: $amount, reason: $reason, status: $status)';
}


}

/// @nodoc
abstract mixin class $CreditNoteCopyWith<$Res>  {
  factory $CreditNoteCopyWith(CreditNote value, $Res Function(CreditNote) _then) = _$CreditNoteCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, String? invoiceId, String creditNoteNumber, String issueDate,@AmountConverter() String amount, String? reason, CreditNoteStatus status
});




}
/// @nodoc
class _$CreditNoteCopyWithImpl<$Res>
    implements $CreditNoteCopyWith<$Res> {
  _$CreditNoteCopyWithImpl(this._self, this._then);

  final CreditNote _self;
  final $Res Function(CreditNote) _then;

/// Create a copy of CreditNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? invoiceId = freezed,Object? creditNoteNumber = null,Object? issueDate = null,Object? amount = null,Object? reason = freezed,Object? status = null,}) {
  return _then(CreditNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,creditNoteNumber: null == creditNoteNumber ? _self.creditNoteNumber : creditNoteNumber // ignore: cast_nullable_to_non_nullable
as String,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CreditNoteStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditNote].
extension CreditNotePatterns on CreditNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditNote value)  $default,){
final _that = this;
switch (_that) {
case _CreditNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditNote value)?  $default,){
final _that = this;
switch (_that) {
case _CreditNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  String? invoiceId,  String creditNoteNumber,  String issueDate, @AmountConverter()  String amount,  String? reason,  CreditNoteStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditNote() when $default != null:
return $default(_that.id,_that.customerId,_that.invoiceId,_that.creditNoteNumber,_that.issueDate,_that.amount,_that.reason,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  String? invoiceId,  String creditNoteNumber,  String issueDate, @AmountConverter()  String amount,  String? reason,  CreditNoteStatus status)  $default,) {final _that = this;
switch (_that) {
case _CreditNote():
return $default(_that.id,_that.customerId,_that.invoiceId,_that.creditNoteNumber,_that.issueDate,_that.amount,_that.reason,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  String? invoiceId,  String creditNoteNumber,  String issueDate, @AmountConverter()  String amount,  String? reason,  CreditNoteStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CreditNote() when $default != null:
return $default(_that.id,_that.customerId,_that.invoiceId,_that.creditNoteNumber,_that.issueDate,_that.amount,_that.reason,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditNote implements CreditNote {
  const _CreditNote({required this.id, required this.customerId, this.invoiceId, required this.creditNoteNumber, required this.issueDate, @AmountConverter() required this.amount, this.reason, required this.status});
  factory _CreditNote.fromJson(Map<String, dynamic> json) => _$CreditNoteFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  String? invoiceId;
@override final  String creditNoteNumber;
@override final  String issueDate;
@override@AmountConverter() final  String amount;
@override final  String? reason;
@override final  CreditNoteStatus status;

/// Create a copy of CreditNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditNoteCopyWith<_CreditNote> get copyWith => __$CreditNoteCopyWithImpl<_CreditNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditNote&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.creditNoteNumber, creditNoteNumber) || other.creditNoteNumber == creditNoteNumber)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,invoiceId,creditNoteNumber,issueDate,amount,reason,status);

@override
String toString() {
  return 'CreditNote(id: $id, customerId: $customerId, invoiceId: $invoiceId, creditNoteNumber: $creditNoteNumber, issueDate: $issueDate, amount: $amount, reason: $reason, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CreditNoteCopyWith<$Res> implements $CreditNoteCopyWith<$Res> {
  factory _$CreditNoteCopyWith(_CreditNote value, $Res Function(_CreditNote) _then) = __$CreditNoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, String? invoiceId, String creditNoteNumber, String issueDate,@AmountConverter() String amount, String? reason, CreditNoteStatus status
});




}
/// @nodoc
class __$CreditNoteCopyWithImpl<$Res>
    implements _$CreditNoteCopyWith<$Res> {
  __$CreditNoteCopyWithImpl(this._self, this._then);

  final _CreditNote _self;
  final $Res Function(_CreditNote) _then;

/// Create a copy of CreditNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? invoiceId = freezed,Object? creditNoteNumber = null,Object? issueDate = null,Object? amount = null,Object? reason = freezed,Object? status = null,}) {
  return _then(_CreditNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,invoiceId: freezed == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String?,creditNoteNumber: null == creditNoteNumber ? _self.creditNoteNumber : creditNoteNumber // ignore: cast_nullable_to_non_nullable
as String,issueDate: null == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CreditNoteStatus,
  ));
}


}


/// @nodoc
mixin _$EInvoiceDocument {

 String get id; String get invoiceId; EInvoiceStatus get status; String? get submissionUid; String? get documentUuid; String? get longId; String? get validatedAt; String? get invalidReason; String? get cancelledAt; String? get cancellationReason; String? get rejectedAt; String? get rejectionReason; String get createdAt;
/// Create a copy of EInvoiceDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EInvoiceDocumentCopyWith<EInvoiceDocument> get copyWith => _$EInvoiceDocumentCopyWithImpl<EInvoiceDocument>(this as EInvoiceDocument, _$identity);

  /// Serializes this EInvoiceDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EInvoiceDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.submissionUid, submissionUid) || other.submissionUid == submissionUid)&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.longId, longId) || other.longId == longId)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&(identical(other.invalidReason, invalidReason) || other.invalidReason == invalidReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceId,status,submissionUid,documentUuid,longId,validatedAt,invalidReason,cancelledAt,cancellationReason,rejectedAt,rejectionReason,createdAt);

@override
String toString() {
  return 'EInvoiceDocument(id: $id, invoiceId: $invoiceId, status: $status, submissionUid: $submissionUid, documentUuid: $documentUuid, longId: $longId, validatedAt: $validatedAt, invalidReason: $invalidReason, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, rejectedAt: $rejectedAt, rejectionReason: $rejectionReason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EInvoiceDocumentCopyWith<$Res>  {
  factory $EInvoiceDocumentCopyWith(EInvoiceDocument value, $Res Function(EInvoiceDocument) _then) = _$EInvoiceDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String invoiceId, EInvoiceStatus status, String? submissionUid, String? documentUuid, String? longId, String? validatedAt, String? invalidReason, String? cancelledAt, String? cancellationReason, String? rejectedAt, String? rejectionReason, String createdAt
});




}
/// @nodoc
class _$EInvoiceDocumentCopyWithImpl<$Res>
    implements $EInvoiceDocumentCopyWith<$Res> {
  _$EInvoiceDocumentCopyWithImpl(this._self, this._then);

  final EInvoiceDocument _self;
  final $Res Function(EInvoiceDocument) _then;

/// Create a copy of EInvoiceDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoiceId = null,Object? status = null,Object? submissionUid = freezed,Object? documentUuid = freezed,Object? longId = freezed,Object? validatedAt = freezed,Object? invalidReason = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? rejectedAt = freezed,Object? rejectionReason = freezed,Object? createdAt = null,}) {
  return _then(EInvoiceDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EInvoiceStatus,submissionUid: freezed == submissionUid ? _self.submissionUid : submissionUid // ignore: cast_nullable_to_non_nullable
as String?,documentUuid: freezed == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String?,longId: freezed == longId ? _self.longId : longId // ignore: cast_nullable_to_non_nullable
as String?,validatedAt: freezed == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as String?,invalidReason: freezed == invalidReason ? _self.invalidReason : invalidReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EInvoiceDocument].
extension EInvoiceDocumentPatterns on EInvoiceDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EInvoiceDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EInvoiceDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EInvoiceDocument value)  $default,){
final _that = this;
switch (_that) {
case _EInvoiceDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EInvoiceDocument value)?  $default,){
final _that = this;
switch (_that) {
case _EInvoiceDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String invoiceId,  EInvoiceStatus status,  String? submissionUid,  String? documentUuid,  String? longId,  String? validatedAt,  String? invalidReason,  String? cancelledAt,  String? cancellationReason,  String? rejectedAt,  String? rejectionReason,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EInvoiceDocument() when $default != null:
return $default(_that.id,_that.invoiceId,_that.status,_that.submissionUid,_that.documentUuid,_that.longId,_that.validatedAt,_that.invalidReason,_that.cancelledAt,_that.cancellationReason,_that.rejectedAt,_that.rejectionReason,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String invoiceId,  EInvoiceStatus status,  String? submissionUid,  String? documentUuid,  String? longId,  String? validatedAt,  String? invalidReason,  String? cancelledAt,  String? cancellationReason,  String? rejectedAt,  String? rejectionReason,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _EInvoiceDocument():
return $default(_that.id,_that.invoiceId,_that.status,_that.submissionUid,_that.documentUuid,_that.longId,_that.validatedAt,_that.invalidReason,_that.cancelledAt,_that.cancellationReason,_that.rejectedAt,_that.rejectionReason,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String invoiceId,  EInvoiceStatus status,  String? submissionUid,  String? documentUuid,  String? longId,  String? validatedAt,  String? invalidReason,  String? cancelledAt,  String? cancellationReason,  String? rejectedAt,  String? rejectionReason,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EInvoiceDocument() when $default != null:
return $default(_that.id,_that.invoiceId,_that.status,_that.submissionUid,_that.documentUuid,_that.longId,_that.validatedAt,_that.invalidReason,_that.cancelledAt,_that.cancellationReason,_that.rejectedAt,_that.rejectionReason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EInvoiceDocument implements EInvoiceDocument {
  const _EInvoiceDocument({required this.id, required this.invoiceId, required this.status, this.submissionUid, this.documentUuid, this.longId, this.validatedAt, this.invalidReason, this.cancelledAt, this.cancellationReason, this.rejectedAt, this.rejectionReason, required this.createdAt});
  factory _EInvoiceDocument.fromJson(Map<String, dynamic> json) => _$EInvoiceDocumentFromJson(json);

@override final  String id;
@override final  String invoiceId;
@override final  EInvoiceStatus status;
@override final  String? submissionUid;
@override final  String? documentUuid;
@override final  String? longId;
@override final  String? validatedAt;
@override final  String? invalidReason;
@override final  String? cancelledAt;
@override final  String? cancellationReason;
@override final  String? rejectedAt;
@override final  String? rejectionReason;
@override final  String createdAt;

/// Create a copy of EInvoiceDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EInvoiceDocumentCopyWith<_EInvoiceDocument> get copyWith => __$EInvoiceDocumentCopyWithImpl<_EInvoiceDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EInvoiceDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EInvoiceDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.submissionUid, submissionUid) || other.submissionUid == submissionUid)&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.longId, longId) || other.longId == longId)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&(identical(other.invalidReason, invalidReason) || other.invalidReason == invalidReason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceId,status,submissionUid,documentUuid,longId,validatedAt,invalidReason,cancelledAt,cancellationReason,rejectedAt,rejectionReason,createdAt);

@override
String toString() {
  return 'EInvoiceDocument(id: $id, invoiceId: $invoiceId, status: $status, submissionUid: $submissionUid, documentUuid: $documentUuid, longId: $longId, validatedAt: $validatedAt, invalidReason: $invalidReason, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, rejectedAt: $rejectedAt, rejectionReason: $rejectionReason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EInvoiceDocumentCopyWith<$Res> implements $EInvoiceDocumentCopyWith<$Res> {
  factory _$EInvoiceDocumentCopyWith(_EInvoiceDocument value, $Res Function(_EInvoiceDocument) _then) = __$EInvoiceDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String invoiceId, EInvoiceStatus status, String? submissionUid, String? documentUuid, String? longId, String? validatedAt, String? invalidReason, String? cancelledAt, String? cancellationReason, String? rejectedAt, String? rejectionReason, String createdAt
});




}
/// @nodoc
class __$EInvoiceDocumentCopyWithImpl<$Res>
    implements _$EInvoiceDocumentCopyWith<$Res> {
  __$EInvoiceDocumentCopyWithImpl(this._self, this._then);

  final _EInvoiceDocument _self;
  final $Res Function(_EInvoiceDocument) _then;

/// Create a copy of EInvoiceDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoiceId = null,Object? status = null,Object? submissionUid = freezed,Object? documentUuid = freezed,Object? longId = freezed,Object? validatedAt = freezed,Object? invalidReason = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? rejectedAt = freezed,Object? rejectionReason = freezed,Object? createdAt = null,}) {
  return _then(_EInvoiceDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EInvoiceStatus,submissionUid: freezed == submissionUid ? _self.submissionUid : submissionUid // ignore: cast_nullable_to_non_nullable
as String?,documentUuid: freezed == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String?,longId: freezed == longId ? _self.longId : longId // ignore: cast_nullable_to_non_nullable
as String?,validatedAt: freezed == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as String?,invalidReason: freezed == invalidReason ? _self.invalidReason : invalidReason // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$EInvoiceLogEntry {

 String get id; EInvoiceOperation get operation; String? get providerName; bool get success; String? get detail; String get createdAt;
/// Create a copy of EInvoiceLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EInvoiceLogEntryCopyWith<EInvoiceLogEntry> get copyWith => _$EInvoiceLogEntryCopyWithImpl<EInvoiceLogEntry>(this as EInvoiceLogEntry, _$identity);

  /// Serializes this EInvoiceLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EInvoiceLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.success, success) || other.success == success)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operation,providerName,success,detail,createdAt);

@override
String toString() {
  return 'EInvoiceLogEntry(id: $id, operation: $operation, providerName: $providerName, success: $success, detail: $detail, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EInvoiceLogEntryCopyWith<$Res>  {
  factory $EInvoiceLogEntryCopyWith(EInvoiceLogEntry value, $Res Function(EInvoiceLogEntry) _then) = _$EInvoiceLogEntryCopyWithImpl;
@useResult
$Res call({
 String id, EInvoiceOperation operation, String? providerName, bool success, String? detail, String createdAt
});




}
/// @nodoc
class _$EInvoiceLogEntryCopyWithImpl<$Res>
    implements $EInvoiceLogEntryCopyWith<$Res> {
  _$EInvoiceLogEntryCopyWithImpl(this._self, this._then);

  final EInvoiceLogEntry _self;
  final $Res Function(EInvoiceLogEntry) _then;

/// Create a copy of EInvoiceLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? operation = null,Object? providerName = freezed,Object? success = null,Object? detail = freezed,Object? createdAt = null,}) {
  return _then(EInvoiceLogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as EInvoiceOperation,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EInvoiceLogEntry].
extension EInvoiceLogEntryPatterns on EInvoiceLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EInvoiceLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EInvoiceLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EInvoiceLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _EInvoiceLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EInvoiceLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _EInvoiceLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EInvoiceOperation operation,  String? providerName,  bool success,  String? detail,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EInvoiceLogEntry() when $default != null:
return $default(_that.id,_that.operation,_that.providerName,_that.success,_that.detail,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EInvoiceOperation operation,  String? providerName,  bool success,  String? detail,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _EInvoiceLogEntry():
return $default(_that.id,_that.operation,_that.providerName,_that.success,_that.detail,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EInvoiceOperation operation,  String? providerName,  bool success,  String? detail,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EInvoiceLogEntry() when $default != null:
return $default(_that.id,_that.operation,_that.providerName,_that.success,_that.detail,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EInvoiceLogEntry implements EInvoiceLogEntry {
  const _EInvoiceLogEntry({required this.id, required this.operation, this.providerName, required this.success, this.detail, required this.createdAt});
  factory _EInvoiceLogEntry.fromJson(Map<String, dynamic> json) => _$EInvoiceLogEntryFromJson(json);

@override final  String id;
@override final  EInvoiceOperation operation;
@override final  String? providerName;
@override final  bool success;
@override final  String? detail;
@override final  String createdAt;

/// Create a copy of EInvoiceLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EInvoiceLogEntryCopyWith<_EInvoiceLogEntry> get copyWith => __$EInvoiceLogEntryCopyWithImpl<_EInvoiceLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EInvoiceLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EInvoiceLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.success, success) || other.success == success)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operation,providerName,success,detail,createdAt);

@override
String toString() {
  return 'EInvoiceLogEntry(id: $id, operation: $operation, providerName: $providerName, success: $success, detail: $detail, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EInvoiceLogEntryCopyWith<$Res> implements $EInvoiceLogEntryCopyWith<$Res> {
  factory _$EInvoiceLogEntryCopyWith(_EInvoiceLogEntry value, $Res Function(_EInvoiceLogEntry) _then) = __$EInvoiceLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, EInvoiceOperation operation, String? providerName, bool success, String? detail, String createdAt
});




}
/// @nodoc
class __$EInvoiceLogEntryCopyWithImpl<$Res>
    implements _$EInvoiceLogEntryCopyWith<$Res> {
  __$EInvoiceLogEntryCopyWithImpl(this._self, this._then);

  final _EInvoiceLogEntry _self;
  final $Res Function(_EInvoiceLogEntry) _then;

/// Create a copy of EInvoiceLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operation = null,Object? providerName = freezed,Object? success = null,Object? detail = freezed,Object? createdAt = null,}) {
  return _then(_EInvoiceLogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as EInvoiceOperation,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
