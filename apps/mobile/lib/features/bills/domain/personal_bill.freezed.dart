// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonalBill {

 String get id; String get name; String? get provider; String get dueDate;@AmountConverter() String get expectedAmount; BillRecurrence get recurrence; BillStatus get status; String? get linkedTransactionId; String? get receiptId; String? get notes;
/// Create a copy of PersonalBill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalBillCopyWith<PersonalBill> get copyWith => _$PersonalBillCopyWithImpl<PersonalBill>(this as PersonalBill, _$identity);

  /// Serializes this PersonalBill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalBill&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedTransactionId, linkedTransactionId) || other.linkedTransactionId == linkedTransactionId)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,provider,dueDate,expectedAmount,recurrence,status,linkedTransactionId,receiptId,notes);

@override
String toString() {
  return 'PersonalBill(id: $id, name: $name, provider: $provider, dueDate: $dueDate, expectedAmount: $expectedAmount, recurrence: $recurrence, status: $status, linkedTransactionId: $linkedTransactionId, receiptId: $receiptId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $PersonalBillCopyWith<$Res>  {
  factory $PersonalBillCopyWith(PersonalBill value, $Res Function(PersonalBill) _then) = _$PersonalBillCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? provider, String dueDate,@AmountConverter() String expectedAmount, BillRecurrence recurrence, BillStatus status, String? linkedTransactionId, String? receiptId, String? notes
});




}
/// @nodoc
class _$PersonalBillCopyWithImpl<$Res>
    implements $PersonalBillCopyWith<$Res> {
  _$PersonalBillCopyWithImpl(this._self, this._then);

  final PersonalBill _self;
  final $Res Function(PersonalBill) _then;

/// Create a copy of PersonalBill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? provider = freezed,Object? dueDate = null,Object? expectedAmount = null,Object? recurrence = null,Object? status = null,Object? linkedTransactionId = freezed,Object? receiptId = freezed,Object? notes = freezed,}) {
  return _then(PersonalBill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as String,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as BillRecurrence,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BillStatus,linkedTransactionId: freezed == linkedTransactionId ? _self.linkedTransactionId : linkedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalBill].
extension PersonalBillPatterns on PersonalBill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalBill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalBill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalBill value)  $default,){
final _that = this;
switch (_that) {
case _PersonalBill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalBill value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalBill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? provider,  String dueDate, @AmountConverter()  String expectedAmount,  BillRecurrence recurrence,  BillStatus status,  String? linkedTransactionId,  String? receiptId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalBill() when $default != null:
return $default(_that.id,_that.name,_that.provider,_that.dueDate,_that.expectedAmount,_that.recurrence,_that.status,_that.linkedTransactionId,_that.receiptId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? provider,  String dueDate, @AmountConverter()  String expectedAmount,  BillRecurrence recurrence,  BillStatus status,  String? linkedTransactionId,  String? receiptId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _PersonalBill():
return $default(_that.id,_that.name,_that.provider,_that.dueDate,_that.expectedAmount,_that.recurrence,_that.status,_that.linkedTransactionId,_that.receiptId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? provider,  String dueDate, @AmountConverter()  String expectedAmount,  BillRecurrence recurrence,  BillStatus status,  String? linkedTransactionId,  String? receiptId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _PersonalBill() when $default != null:
return $default(_that.id,_that.name,_that.provider,_that.dueDate,_that.expectedAmount,_that.recurrence,_that.status,_that.linkedTransactionId,_that.receiptId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonalBill implements PersonalBill {
  const _PersonalBill({required this.id, required this.name, this.provider, required this.dueDate, @AmountConverter() required this.expectedAmount, required this.recurrence, required this.status, this.linkedTransactionId, this.receiptId, this.notes});
  factory _PersonalBill.fromJson(Map<String, dynamic> json) => _$PersonalBillFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? provider;
@override final  String dueDate;
@override@AmountConverter() final  String expectedAmount;
@override final  BillRecurrence recurrence;
@override final  BillStatus status;
@override final  String? linkedTransactionId;
@override final  String? receiptId;
@override final  String? notes;

/// Create a copy of PersonalBill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalBillCopyWith<_PersonalBill> get copyWith => __$PersonalBillCopyWithImpl<_PersonalBill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonalBillToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalBill&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.expectedAmount, expectedAmount) || other.expectedAmount == expectedAmount)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedTransactionId, linkedTransactionId) || other.linkedTransactionId == linkedTransactionId)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,provider,dueDate,expectedAmount,recurrence,status,linkedTransactionId,receiptId,notes);

@override
String toString() {
  return 'PersonalBill(id: $id, name: $name, provider: $provider, dueDate: $dueDate, expectedAmount: $expectedAmount, recurrence: $recurrence, status: $status, linkedTransactionId: $linkedTransactionId, receiptId: $receiptId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$PersonalBillCopyWith<$Res> implements $PersonalBillCopyWith<$Res> {
  factory _$PersonalBillCopyWith(_PersonalBill value, $Res Function(_PersonalBill) _then) = __$PersonalBillCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? provider, String dueDate,@AmountConverter() String expectedAmount, BillRecurrence recurrence, BillStatus status, String? linkedTransactionId, String? receiptId, String? notes
});




}
/// @nodoc
class __$PersonalBillCopyWithImpl<$Res>
    implements _$PersonalBillCopyWith<$Res> {
  __$PersonalBillCopyWithImpl(this._self, this._then);

  final _PersonalBill _self;
  final $Res Function(_PersonalBill) _then;

/// Create a copy of PersonalBill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? provider = freezed,Object? dueDate = null,Object? expectedAmount = null,Object? recurrence = null,Object? status = null,Object? linkedTransactionId = freezed,Object? receiptId = freezed,Object? notes = freezed,}) {
  return _then(_PersonalBill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,expectedAmount: null == expectedAmount ? _self.expectedAmount : expectedAmount // ignore: cast_nullable_to_non_nullable
as String,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as BillRecurrence,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BillStatus,linkedTransactionId: freezed == linkedTransactionId ? _self.linkedTransactionId : linkedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
