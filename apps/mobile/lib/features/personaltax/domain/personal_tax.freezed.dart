// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_tax.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonalIncomeRecord {

 String get id; int get yearOfAssessment; IncomeType get incomeType;@AmountConverter() String get amount; String? get description;
/// Create a copy of PersonalIncomeRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalIncomeRecordCopyWith<PersonalIncomeRecord> get copyWith => _$PersonalIncomeRecordCopyWithImpl<PersonalIncomeRecord>(this as PersonalIncomeRecord, _$identity);

  /// Serializes this PersonalIncomeRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalIncomeRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.incomeType, incomeType) || other.incomeType == incomeType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,incomeType,amount,description);

@override
String toString() {
  return 'PersonalIncomeRecord(id: $id, yearOfAssessment: $yearOfAssessment, incomeType: $incomeType, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class $PersonalIncomeRecordCopyWith<$Res>  {
  factory $PersonalIncomeRecordCopyWith(PersonalIncomeRecord value, $Res Function(PersonalIncomeRecord) _then) = _$PersonalIncomeRecordCopyWithImpl;
@useResult
$Res call({
 String id, int yearOfAssessment, IncomeType incomeType,@AmountConverter() String amount, String? description
});




}
/// @nodoc
class _$PersonalIncomeRecordCopyWithImpl<$Res>
    implements $PersonalIncomeRecordCopyWith<$Res> {
  _$PersonalIncomeRecordCopyWithImpl(this._self, this._then);

  final PersonalIncomeRecord _self;
  final $Res Function(PersonalIncomeRecord) _then;

/// Create a copy of PersonalIncomeRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearOfAssessment = null,Object? incomeType = null,Object? amount = null,Object? description = freezed,}) {
  return _then(PersonalIncomeRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,incomeType: null == incomeType ? _self.incomeType : incomeType // ignore: cast_nullable_to_non_nullable
as IncomeType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalIncomeRecord].
extension PersonalIncomeRecordPatterns on PersonalIncomeRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalIncomeRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalIncomeRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalIncomeRecord value)  $default,){
final _that = this;
switch (_that) {
case _PersonalIncomeRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalIncomeRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalIncomeRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  IncomeType incomeType, @AmountConverter()  String amount,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalIncomeRecord() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.incomeType,_that.amount,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  IncomeType incomeType, @AmountConverter()  String amount,  String? description)  $default,) {final _that = this;
switch (_that) {
case _PersonalIncomeRecord():
return $default(_that.id,_that.yearOfAssessment,_that.incomeType,_that.amount,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearOfAssessment,  IncomeType incomeType, @AmountConverter()  String amount,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _PersonalIncomeRecord() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.incomeType,_that.amount,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonalIncomeRecord implements PersonalIncomeRecord {
  const _PersonalIncomeRecord({required this.id, required this.yearOfAssessment, required this.incomeType, @AmountConverter() required this.amount, this.description});
  factory _PersonalIncomeRecord.fromJson(Map<String, dynamic> json) => _$PersonalIncomeRecordFromJson(json);

@override final  String id;
@override final  int yearOfAssessment;
@override final  IncomeType incomeType;
@override@AmountConverter() final  String amount;
@override final  String? description;

/// Create a copy of PersonalIncomeRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalIncomeRecordCopyWith<_PersonalIncomeRecord> get copyWith => __$PersonalIncomeRecordCopyWithImpl<_PersonalIncomeRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonalIncomeRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalIncomeRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.incomeType, incomeType) || other.incomeType == incomeType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,incomeType,amount,description);

@override
String toString() {
  return 'PersonalIncomeRecord(id: $id, yearOfAssessment: $yearOfAssessment, incomeType: $incomeType, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PersonalIncomeRecordCopyWith<$Res> implements $PersonalIncomeRecordCopyWith<$Res> {
  factory _$PersonalIncomeRecordCopyWith(_PersonalIncomeRecord value, $Res Function(_PersonalIncomeRecord) _then) = __$PersonalIncomeRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearOfAssessment, IncomeType incomeType,@AmountConverter() String amount, String? description
});




}
/// @nodoc
class __$PersonalIncomeRecordCopyWithImpl<$Res>
    implements _$PersonalIncomeRecordCopyWith<$Res> {
  __$PersonalIncomeRecordCopyWithImpl(this._self, this._then);

  final _PersonalIncomeRecord _self;
  final $Res Function(_PersonalIncomeRecord) _then;

/// Create a copy of PersonalIncomeRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearOfAssessment = null,Object? incomeType = null,Object? amount = null,Object? description = freezed,}) {
  return _then(_PersonalIncomeRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,incomeType: null == incomeType ? _self.incomeType : incomeType // ignore: cast_nullable_to_non_nullable
as IncomeType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PcbPayment {

 String get id; int get yearOfAssessment; int get month;@AmountConverter() String get amount; String? get notes;
/// Create a copy of PcbPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PcbPaymentCopyWith<PcbPayment> get copyWith => _$PcbPaymentCopyWithImpl<PcbPayment>(this as PcbPayment, _$identity);

  /// Serializes this PcbPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PcbPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.month, month) || other.month == month)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,month,amount,notes);

@override
String toString() {
  return 'PcbPayment(id: $id, yearOfAssessment: $yearOfAssessment, month: $month, amount: $amount, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $PcbPaymentCopyWith<$Res>  {
  factory $PcbPaymentCopyWith(PcbPayment value, $Res Function(PcbPayment) _then) = _$PcbPaymentCopyWithImpl;
@useResult
$Res call({
 String id, int yearOfAssessment, int month,@AmountConverter() String amount, String? notes
});




}
/// @nodoc
class _$PcbPaymentCopyWithImpl<$Res>
    implements $PcbPaymentCopyWith<$Res> {
  _$PcbPaymentCopyWithImpl(this._self, this._then);

  final PcbPayment _self;
  final $Res Function(PcbPayment) _then;

/// Create a copy of PcbPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearOfAssessment = null,Object? month = null,Object? amount = null,Object? notes = freezed,}) {
  return _then(PcbPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PcbPayment].
extension PcbPaymentPatterns on PcbPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PcbPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PcbPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PcbPayment value)  $default,){
final _that = this;
switch (_that) {
case _PcbPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PcbPayment value)?  $default,){
final _that = this;
switch (_that) {
case _PcbPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  int month, @AmountConverter()  String amount,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PcbPayment() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.month,_that.amount,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  int month, @AmountConverter()  String amount,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _PcbPayment():
return $default(_that.id,_that.yearOfAssessment,_that.month,_that.amount,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearOfAssessment,  int month, @AmountConverter()  String amount,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _PcbPayment() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.month,_that.amount,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PcbPayment implements PcbPayment {
  const _PcbPayment({required this.id, required this.yearOfAssessment, required this.month, @AmountConverter() required this.amount, this.notes});
  factory _PcbPayment.fromJson(Map<String, dynamic> json) => _$PcbPaymentFromJson(json);

@override final  String id;
@override final  int yearOfAssessment;
@override final  int month;
@override@AmountConverter() final  String amount;
@override final  String? notes;

/// Create a copy of PcbPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PcbPaymentCopyWith<_PcbPayment> get copyWith => __$PcbPaymentCopyWithImpl<_PcbPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PcbPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PcbPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.month, month) || other.month == month)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,month,amount,notes);

@override
String toString() {
  return 'PcbPayment(id: $id, yearOfAssessment: $yearOfAssessment, month: $month, amount: $amount, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$PcbPaymentCopyWith<$Res> implements $PcbPaymentCopyWith<$Res> {
  factory _$PcbPaymentCopyWith(_PcbPayment value, $Res Function(_PcbPayment) _then) = __$PcbPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearOfAssessment, int month,@AmountConverter() String amount, String? notes
});




}
/// @nodoc
class __$PcbPaymentCopyWithImpl<$Res>
    implements _$PcbPaymentCopyWith<$Res> {
  __$PcbPaymentCopyWithImpl(this._self, this._then);

  final _PcbPayment _self;
  final $Res Function(_PcbPayment) _then;

/// Create a copy of PcbPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearOfAssessment = null,Object? month = null,Object? amount = null,Object? notes = freezed,}) {
  return _then(_PcbPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ZakatPayment {

 String get id; int get yearOfAssessment;@AmountConverter() String get amount; String get paidOn; String? get receiptId; String? get notes;
/// Create a copy of ZakatPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZakatPaymentCopyWith<ZakatPayment> get copyWith => _$ZakatPaymentCopyWithImpl<ZakatPayment>(this as ZakatPayment, _$identity);

  /// Serializes this ZakatPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZakatPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,amount,paidOn,receiptId,notes);

@override
String toString() {
  return 'ZakatPayment(id: $id, yearOfAssessment: $yearOfAssessment, amount: $amount, paidOn: $paidOn, receiptId: $receiptId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ZakatPaymentCopyWith<$Res>  {
  factory $ZakatPaymentCopyWith(ZakatPayment value, $Res Function(ZakatPayment) _then) = _$ZakatPaymentCopyWithImpl;
@useResult
$Res call({
 String id, int yearOfAssessment,@AmountConverter() String amount, String paidOn, String? receiptId, String? notes
});




}
/// @nodoc
class _$ZakatPaymentCopyWithImpl<$Res>
    implements $ZakatPaymentCopyWith<$Res> {
  _$ZakatPaymentCopyWithImpl(this._self, this._then);

  final ZakatPayment _self;
  final $Res Function(ZakatPayment) _then;

/// Create a copy of ZakatPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearOfAssessment = null,Object? amount = null,Object? paidOn = null,Object? receiptId = freezed,Object? notes = freezed,}) {
  return _then(ZakatPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ZakatPayment].
extension ZakatPaymentPatterns on ZakatPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZakatPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZakatPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZakatPayment value)  $default,){
final _that = this;
switch (_that) {
case _ZakatPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZakatPayment value)?  $default,){
final _that = this;
switch (_that) {
case _ZakatPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment, @AmountConverter()  String amount,  String paidOn,  String? receiptId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZakatPayment() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.amount,_that.paidOn,_that.receiptId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment, @AmountConverter()  String amount,  String paidOn,  String? receiptId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ZakatPayment():
return $default(_that.id,_that.yearOfAssessment,_that.amount,_that.paidOn,_that.receiptId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearOfAssessment, @AmountConverter()  String amount,  String paidOn,  String? receiptId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ZakatPayment() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.amount,_that.paidOn,_that.receiptId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZakatPayment implements ZakatPayment {
  const _ZakatPayment({required this.id, required this.yearOfAssessment, @AmountConverter() required this.amount, required this.paidOn, this.receiptId, this.notes});
  factory _ZakatPayment.fromJson(Map<String, dynamic> json) => _$ZakatPaymentFromJson(json);

@override final  String id;
@override final  int yearOfAssessment;
@override@AmountConverter() final  String amount;
@override final  String paidOn;
@override final  String? receiptId;
@override final  String? notes;

/// Create a copy of ZakatPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZakatPaymentCopyWith<_ZakatPayment> get copyWith => __$ZakatPaymentCopyWithImpl<_ZakatPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZakatPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZakatPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,amount,paidOn,receiptId,notes);

@override
String toString() {
  return 'ZakatPayment(id: $id, yearOfAssessment: $yearOfAssessment, amount: $amount, paidOn: $paidOn, receiptId: $receiptId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ZakatPaymentCopyWith<$Res> implements $ZakatPaymentCopyWith<$Res> {
  factory _$ZakatPaymentCopyWith(_ZakatPayment value, $Res Function(_ZakatPayment) _then) = __$ZakatPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearOfAssessment,@AmountConverter() String amount, String paidOn, String? receiptId, String? notes
});




}
/// @nodoc
class __$ZakatPaymentCopyWithImpl<$Res>
    implements _$ZakatPaymentCopyWith<$Res> {
  __$ZakatPaymentCopyWithImpl(this._self, this._then);

  final _ZakatPayment _self;
  final $Res Function(_ZakatPayment) _then;

/// Create a copy of ZakatPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearOfAssessment = null,Object? amount = null,Object? paidOn = null,Object? receiptId = freezed,Object? notes = freezed,}) {
  return _then(_ZakatPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PersonalTaxDocument {

 String get id; int get yearOfAssessment; TaxDocumentType get type; String? get receiptId; bool get hasFile; String? get notes;
/// Create a copy of PersonalTaxDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalTaxDocumentCopyWith<PersonalTaxDocument> get copyWith => _$PersonalTaxDocumentCopyWithImpl<PersonalTaxDocument>(this as PersonalTaxDocument, _$identity);

  /// Serializes this PersonalTaxDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalTaxDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.type, type) || other.type == type)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,type,receiptId,hasFile,notes);

@override
String toString() {
  return 'PersonalTaxDocument(id: $id, yearOfAssessment: $yearOfAssessment, type: $type, receiptId: $receiptId, hasFile: $hasFile, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $PersonalTaxDocumentCopyWith<$Res>  {
  factory $PersonalTaxDocumentCopyWith(PersonalTaxDocument value, $Res Function(PersonalTaxDocument) _then) = _$PersonalTaxDocumentCopyWithImpl;
@useResult
$Res call({
 String id, int yearOfAssessment, TaxDocumentType type, String? receiptId, bool hasFile, String? notes
});




}
/// @nodoc
class _$PersonalTaxDocumentCopyWithImpl<$Res>
    implements $PersonalTaxDocumentCopyWith<$Res> {
  _$PersonalTaxDocumentCopyWithImpl(this._self, this._then);

  final PersonalTaxDocument _self;
  final $Res Function(PersonalTaxDocument) _then;

/// Create a copy of PersonalTaxDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearOfAssessment = null,Object? type = null,Object? receiptId = freezed,Object? hasFile = null,Object? notes = freezed,}) {
  return _then(PersonalTaxDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaxDocumentType,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalTaxDocument].
extension PersonalTaxDocumentPatterns on PersonalTaxDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalTaxDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalTaxDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalTaxDocument value)  $default,){
final _that = this;
switch (_that) {
case _PersonalTaxDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalTaxDocument value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalTaxDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  TaxDocumentType type,  String? receiptId,  bool hasFile,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalTaxDocument() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.type,_that.receiptId,_that.hasFile,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  TaxDocumentType type,  String? receiptId,  bool hasFile,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _PersonalTaxDocument():
return $default(_that.id,_that.yearOfAssessment,_that.type,_that.receiptId,_that.hasFile,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearOfAssessment,  TaxDocumentType type,  String? receiptId,  bool hasFile,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _PersonalTaxDocument() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.type,_that.receiptId,_that.hasFile,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonalTaxDocument implements PersonalTaxDocument {
  const _PersonalTaxDocument({required this.id, required this.yearOfAssessment, required this.type, this.receiptId, required this.hasFile, this.notes});
  factory _PersonalTaxDocument.fromJson(Map<String, dynamic> json) => _$PersonalTaxDocumentFromJson(json);

@override final  String id;
@override final  int yearOfAssessment;
@override final  TaxDocumentType type;
@override final  String? receiptId;
@override final  bool hasFile;
@override final  String? notes;

/// Create a copy of PersonalTaxDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalTaxDocumentCopyWith<_PersonalTaxDocument> get copyWith => __$PersonalTaxDocumentCopyWithImpl<_PersonalTaxDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonalTaxDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalTaxDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.type, type) || other.type == type)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.hasFile, hasFile) || other.hasFile == hasFile)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,type,receiptId,hasFile,notes);

@override
String toString() {
  return 'PersonalTaxDocument(id: $id, yearOfAssessment: $yearOfAssessment, type: $type, receiptId: $receiptId, hasFile: $hasFile, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$PersonalTaxDocumentCopyWith<$Res> implements $PersonalTaxDocumentCopyWith<$Res> {
  factory _$PersonalTaxDocumentCopyWith(_PersonalTaxDocument value, $Res Function(_PersonalTaxDocument) _then) = __$PersonalTaxDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearOfAssessment, TaxDocumentType type, String? receiptId, bool hasFile, String? notes
});




}
/// @nodoc
class __$PersonalTaxDocumentCopyWithImpl<$Res>
    implements _$PersonalTaxDocumentCopyWith<$Res> {
  __$PersonalTaxDocumentCopyWithImpl(this._self, this._then);

  final _PersonalTaxDocument _self;
  final $Res Function(_PersonalTaxDocument) _then;

/// Create a copy of PersonalTaxDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearOfAssessment = null,Object? type = null,Object? receiptId = freezed,Object? hasFile = null,Object? notes = freezed,}) {
  return _then(_PersonalTaxDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaxDocumentType,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,hasFile: null == hasFile ? _self.hasFile : hasFile // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TaxReliefCandidate {

 String get id; int get yearOfAssessment; PersonalTaxReliefCategory? get category; String? get sourceReceiptId;@AmountConverter() String get suggestedAmount; TaxReliefCandidateStatus get status; String? get notes;
/// Create a copy of TaxReliefCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaxReliefCandidateCopyWith<TaxReliefCandidate> get copyWith => _$TaxReliefCandidateCopyWithImpl<TaxReliefCandidate>(this as TaxReliefCandidate, _$identity);

  /// Serializes this TaxReliefCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxReliefCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.category, category) || other.category == category)&&(identical(other.sourceReceiptId, sourceReceiptId) || other.sourceReceiptId == sourceReceiptId)&&(identical(other.suggestedAmount, suggestedAmount) || other.suggestedAmount == suggestedAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,category,sourceReceiptId,suggestedAmount,status,notes);

@override
String toString() {
  return 'TaxReliefCandidate(id: $id, yearOfAssessment: $yearOfAssessment, category: $category, sourceReceiptId: $sourceReceiptId, suggestedAmount: $suggestedAmount, status: $status, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $TaxReliefCandidateCopyWith<$Res>  {
  factory $TaxReliefCandidateCopyWith(TaxReliefCandidate value, $Res Function(TaxReliefCandidate) _then) = _$TaxReliefCandidateCopyWithImpl;
@useResult
$Res call({
 String id, int yearOfAssessment, PersonalTaxReliefCategory? category, String? sourceReceiptId,@AmountConverter() String suggestedAmount, TaxReliefCandidateStatus status, String? notes
});




}
/// @nodoc
class _$TaxReliefCandidateCopyWithImpl<$Res>
    implements $TaxReliefCandidateCopyWith<$Res> {
  _$TaxReliefCandidateCopyWithImpl(this._self, this._then);

  final TaxReliefCandidate _self;
  final $Res Function(TaxReliefCandidate) _then;

/// Create a copy of TaxReliefCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearOfAssessment = null,Object? category = freezed,Object? sourceReceiptId = freezed,Object? suggestedAmount = null,Object? status = null,Object? notes = freezed,}) {
  return _then(TaxReliefCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PersonalTaxReliefCategory?,sourceReceiptId: freezed == sourceReceiptId ? _self.sourceReceiptId : sourceReceiptId // ignore: cast_nullable_to_non_nullable
as String?,suggestedAmount: null == suggestedAmount ? _self.suggestedAmount : suggestedAmount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaxReliefCandidateStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaxReliefCandidate].
extension TaxReliefCandidatePatterns on TaxReliefCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaxReliefCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaxReliefCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaxReliefCandidate value)  $default,){
final _that = this;
switch (_that) {
case _TaxReliefCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaxReliefCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _TaxReliefCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  PersonalTaxReliefCategory? category,  String? sourceReceiptId, @AmountConverter()  String suggestedAmount,  TaxReliefCandidateStatus status,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaxReliefCandidate() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.category,_that.sourceReceiptId,_that.suggestedAmount,_that.status,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  PersonalTaxReliefCategory? category,  String? sourceReceiptId, @AmountConverter()  String suggestedAmount,  TaxReliefCandidateStatus status,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _TaxReliefCandidate():
return $default(_that.id,_that.yearOfAssessment,_that.category,_that.sourceReceiptId,_that.suggestedAmount,_that.status,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearOfAssessment,  PersonalTaxReliefCategory? category,  String? sourceReceiptId, @AmountConverter()  String suggestedAmount,  TaxReliefCandidateStatus status,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _TaxReliefCandidate() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.category,_that.sourceReceiptId,_that.suggestedAmount,_that.status,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaxReliefCandidate implements TaxReliefCandidate {
  const _TaxReliefCandidate({required this.id, required this.yearOfAssessment, this.category, this.sourceReceiptId, @AmountConverter() required this.suggestedAmount, required this.status, this.notes});
  factory _TaxReliefCandidate.fromJson(Map<String, dynamic> json) => _$TaxReliefCandidateFromJson(json);

@override final  String id;
@override final  int yearOfAssessment;
@override final  PersonalTaxReliefCategory? category;
@override final  String? sourceReceiptId;
@override@AmountConverter() final  String suggestedAmount;
@override final  TaxReliefCandidateStatus status;
@override final  String? notes;

/// Create a copy of TaxReliefCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaxReliefCandidateCopyWith<_TaxReliefCandidate> get copyWith => __$TaxReliefCandidateCopyWithImpl<_TaxReliefCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaxReliefCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaxReliefCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.category, category) || other.category == category)&&(identical(other.sourceReceiptId, sourceReceiptId) || other.sourceReceiptId == sourceReceiptId)&&(identical(other.suggestedAmount, suggestedAmount) || other.suggestedAmount == suggestedAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,category,sourceReceiptId,suggestedAmount,status,notes);

@override
String toString() {
  return 'TaxReliefCandidate(id: $id, yearOfAssessment: $yearOfAssessment, category: $category, sourceReceiptId: $sourceReceiptId, suggestedAmount: $suggestedAmount, status: $status, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$TaxReliefCandidateCopyWith<$Res> implements $TaxReliefCandidateCopyWith<$Res> {
  factory _$TaxReliefCandidateCopyWith(_TaxReliefCandidate value, $Res Function(_TaxReliefCandidate) _then) = __$TaxReliefCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearOfAssessment, PersonalTaxReliefCategory? category, String? sourceReceiptId,@AmountConverter() String suggestedAmount, TaxReliefCandidateStatus status, String? notes
});




}
/// @nodoc
class __$TaxReliefCandidateCopyWithImpl<$Res>
    implements _$TaxReliefCandidateCopyWith<$Res> {
  __$TaxReliefCandidateCopyWithImpl(this._self, this._then);

  final _TaxReliefCandidate _self;
  final $Res Function(_TaxReliefCandidate) _then;

/// Create a copy of TaxReliefCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearOfAssessment = null,Object? category = freezed,Object? sourceReceiptId = freezed,Object? suggestedAmount = null,Object? status = null,Object? notes = freezed,}) {
  return _then(_TaxReliefCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PersonalTaxReliefCategory?,sourceReceiptId: freezed == sourceReceiptId ? _self.sourceReceiptId : sourceReceiptId // ignore: cast_nullable_to_non_nullable
as String?,suggestedAmount: null == suggestedAmount ? _self.suggestedAmount : suggestedAmount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaxReliefCandidateStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ConfirmedTaxRelief {

 String get id; int get yearOfAssessment; PersonalTaxReliefCategory get category;@AmountConverter() String get confirmedAmount;
/// Create a copy of ConfirmedTaxRelief
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmedTaxReliefCopyWith<ConfirmedTaxRelief> get copyWith => _$ConfirmedTaxReliefCopyWithImpl<ConfirmedTaxRelief>(this as ConfirmedTaxRelief, _$identity);

  /// Serializes this ConfirmedTaxRelief to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmedTaxRelief&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.category, category) || other.category == category)&&(identical(other.confirmedAmount, confirmedAmount) || other.confirmedAmount == confirmedAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,category,confirmedAmount);

@override
String toString() {
  return 'ConfirmedTaxRelief(id: $id, yearOfAssessment: $yearOfAssessment, category: $category, confirmedAmount: $confirmedAmount)';
}


}

/// @nodoc
abstract mixin class $ConfirmedTaxReliefCopyWith<$Res>  {
  factory $ConfirmedTaxReliefCopyWith(ConfirmedTaxRelief value, $Res Function(ConfirmedTaxRelief) _then) = _$ConfirmedTaxReliefCopyWithImpl;
@useResult
$Res call({
 String id, int yearOfAssessment, PersonalTaxReliefCategory category,@AmountConverter() String confirmedAmount
});




}
/// @nodoc
class _$ConfirmedTaxReliefCopyWithImpl<$Res>
    implements $ConfirmedTaxReliefCopyWith<$Res> {
  _$ConfirmedTaxReliefCopyWithImpl(this._self, this._then);

  final ConfirmedTaxRelief _self;
  final $Res Function(ConfirmedTaxRelief) _then;

/// Create a copy of ConfirmedTaxRelief
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? yearOfAssessment = null,Object? category = null,Object? confirmedAmount = null,}) {
  return _then(ConfirmedTaxRelief(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PersonalTaxReliefCategory,confirmedAmount: null == confirmedAmount ? _self.confirmedAmount : confirmedAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfirmedTaxRelief].
extension ConfirmedTaxReliefPatterns on ConfirmedTaxRelief {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfirmedTaxRelief value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfirmedTaxRelief() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfirmedTaxRelief value)  $default,){
final _that = this;
switch (_that) {
case _ConfirmedTaxRelief():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfirmedTaxRelief value)?  $default,){
final _that = this;
switch (_that) {
case _ConfirmedTaxRelief() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  PersonalTaxReliefCategory category, @AmountConverter()  String confirmedAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfirmedTaxRelief() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.category,_that.confirmedAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int yearOfAssessment,  PersonalTaxReliefCategory category, @AmountConverter()  String confirmedAmount)  $default,) {final _that = this;
switch (_that) {
case _ConfirmedTaxRelief():
return $default(_that.id,_that.yearOfAssessment,_that.category,_that.confirmedAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int yearOfAssessment,  PersonalTaxReliefCategory category, @AmountConverter()  String confirmedAmount)?  $default,) {final _that = this;
switch (_that) {
case _ConfirmedTaxRelief() when $default != null:
return $default(_that.id,_that.yearOfAssessment,_that.category,_that.confirmedAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfirmedTaxRelief implements ConfirmedTaxRelief {
  const _ConfirmedTaxRelief({required this.id, required this.yearOfAssessment, required this.category, @AmountConverter() required this.confirmedAmount});
  factory _ConfirmedTaxRelief.fromJson(Map<String, dynamic> json) => _$ConfirmedTaxReliefFromJson(json);

@override final  String id;
@override final  int yearOfAssessment;
@override final  PersonalTaxReliefCategory category;
@override@AmountConverter() final  String confirmedAmount;

/// Create a copy of ConfirmedTaxRelief
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmedTaxReliefCopyWith<_ConfirmedTaxRelief> get copyWith => __$ConfirmedTaxReliefCopyWithImpl<_ConfirmedTaxRelief>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfirmedTaxReliefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmedTaxRelief&&(identical(other.id, id) || other.id == id)&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.category, category) || other.category == category)&&(identical(other.confirmedAmount, confirmedAmount) || other.confirmedAmount == confirmedAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,yearOfAssessment,category,confirmedAmount);

@override
String toString() {
  return 'ConfirmedTaxRelief(id: $id, yearOfAssessment: $yearOfAssessment, category: $category, confirmedAmount: $confirmedAmount)';
}


}

/// @nodoc
abstract mixin class _$ConfirmedTaxReliefCopyWith<$Res> implements $ConfirmedTaxReliefCopyWith<$Res> {
  factory _$ConfirmedTaxReliefCopyWith(_ConfirmedTaxRelief value, $Res Function(_ConfirmedTaxRelief) _then) = __$ConfirmedTaxReliefCopyWithImpl;
@override @useResult
$Res call({
 String id, int yearOfAssessment, PersonalTaxReliefCategory category,@AmountConverter() String confirmedAmount
});




}
/// @nodoc
class __$ConfirmedTaxReliefCopyWithImpl<$Res>
    implements _$ConfirmedTaxReliefCopyWith<$Res> {
  __$ConfirmedTaxReliefCopyWithImpl(this._self, this._then);

  final _ConfirmedTaxRelief _self;
  final $Res Function(_ConfirmedTaxRelief) _then;

/// Create a copy of ConfirmedTaxRelief
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? yearOfAssessment = null,Object? category = null,Object? confirmedAmount = null,}) {
  return _then(_ConfirmedTaxRelief(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PersonalTaxReliefCategory,confirmedAmount: null == confirmedAmount ? _self.confirmedAmount : confirmedAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TaxReliefLine {

 String get label;@AmountConverter() String get claimedAmount;@AmountConverter() String get maxAmount;
/// Create a copy of TaxReliefLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaxReliefLineCopyWith<TaxReliefLine> get copyWith => _$TaxReliefLineCopyWithImpl<TaxReliefLine>(this as TaxReliefLine, _$identity);

  /// Serializes this TaxReliefLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxReliefLine&&(identical(other.label, label) || other.label == label)&&(identical(other.claimedAmount, claimedAmount) || other.claimedAmount == claimedAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,claimedAmount,maxAmount);

@override
String toString() {
  return 'TaxReliefLine(label: $label, claimedAmount: $claimedAmount, maxAmount: $maxAmount)';
}


}

/// @nodoc
abstract mixin class $TaxReliefLineCopyWith<$Res>  {
  factory $TaxReliefLineCopyWith(TaxReliefLine value, $Res Function(TaxReliefLine) _then) = _$TaxReliefLineCopyWithImpl;
@useResult
$Res call({
 String label,@AmountConverter() String claimedAmount,@AmountConverter() String maxAmount
});




}
/// @nodoc
class _$TaxReliefLineCopyWithImpl<$Res>
    implements $TaxReliefLineCopyWith<$Res> {
  _$TaxReliefLineCopyWithImpl(this._self, this._then);

  final TaxReliefLine _self;
  final $Res Function(TaxReliefLine) _then;

/// Create a copy of TaxReliefLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? claimedAmount = null,Object? maxAmount = null,}) {
  return _then(TaxReliefLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,claimedAmount: null == claimedAmount ? _self.claimedAmount : claimedAmount // ignore: cast_nullable_to_non_nullable
as String,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaxReliefLine].
extension TaxReliefLinePatterns on TaxReliefLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaxReliefLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaxReliefLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaxReliefLine value)  $default,){
final _that = this;
switch (_that) {
case _TaxReliefLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaxReliefLine value)?  $default,){
final _that = this;
switch (_that) {
case _TaxReliefLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label, @AmountConverter()  String claimedAmount, @AmountConverter()  String maxAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaxReliefLine() when $default != null:
return $default(_that.label,_that.claimedAmount,_that.maxAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label, @AmountConverter()  String claimedAmount, @AmountConverter()  String maxAmount)  $default,) {final _that = this;
switch (_that) {
case _TaxReliefLine():
return $default(_that.label,_that.claimedAmount,_that.maxAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label, @AmountConverter()  String claimedAmount, @AmountConverter()  String maxAmount)?  $default,) {final _that = this;
switch (_that) {
case _TaxReliefLine() when $default != null:
return $default(_that.label,_that.claimedAmount,_that.maxAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaxReliefLine implements TaxReliefLine {
  const _TaxReliefLine({required this.label, @AmountConverter() required this.claimedAmount, @AmountConverter() required this.maxAmount});
  factory _TaxReliefLine.fromJson(Map<String, dynamic> json) => _$TaxReliefLineFromJson(json);

@override final  String label;
@override@AmountConverter() final  String claimedAmount;
@override@AmountConverter() final  String maxAmount;

/// Create a copy of TaxReliefLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaxReliefLineCopyWith<_TaxReliefLine> get copyWith => __$TaxReliefLineCopyWithImpl<_TaxReliefLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaxReliefLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaxReliefLine&&(identical(other.label, label) || other.label == label)&&(identical(other.claimedAmount, claimedAmount) || other.claimedAmount == claimedAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,claimedAmount,maxAmount);

@override
String toString() {
  return 'TaxReliefLine(label: $label, claimedAmount: $claimedAmount, maxAmount: $maxAmount)';
}


}

/// @nodoc
abstract mixin class _$TaxReliefLineCopyWith<$Res> implements $TaxReliefLineCopyWith<$Res> {
  factory _$TaxReliefLineCopyWith(_TaxReliefLine value, $Res Function(_TaxReliefLine) _then) = __$TaxReliefLineCopyWithImpl;
@override @useResult
$Res call({
 String label,@AmountConverter() String claimedAmount,@AmountConverter() String maxAmount
});




}
/// @nodoc
class __$TaxReliefLineCopyWithImpl<$Res>
    implements _$TaxReliefLineCopyWith<$Res> {
  __$TaxReliefLineCopyWithImpl(this._self, this._then);

  final _TaxReliefLine _self;
  final $Res Function(_TaxReliefLine) _then;

/// Create a copy of TaxReliefLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? claimedAmount = null,Object? maxAmount = null,}) {
  return _then(_TaxReliefLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,claimedAmount: null == claimedAmount ? _self.claimedAmount : claimedAmount // ignore: cast_nullable_to_non_nullable
as String,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PersonalTaxCalculation {

 int get yearOfAssessment;@AmountConverter() String get totalIncome;@AmountConverter() String get residentIndividualRelief; List<TaxReliefLine> get reliefs;@AmountConverter() String get totalReliefs;@AmountConverter() String get chargeableIncome;@AmountConverter() String get grossTaxPayable;@AmountConverter() String get rebate;@AmountConverter() String get zakatPaid;@AmountConverter() String get zakatRebate;@AmountConverter() String get taxAfterRebatesAndZakat;@AmountConverter() String get pcbPaid;@AmountConverter() String get estimatedPayableOrRefund; String get disclaimer;
/// Create a copy of PersonalTaxCalculation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalTaxCalculationCopyWith<PersonalTaxCalculation> get copyWith => _$PersonalTaxCalculationCopyWithImpl<PersonalTaxCalculation>(this as PersonalTaxCalculation, _$identity);

  /// Serializes this PersonalTaxCalculation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalTaxCalculation&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.residentIndividualRelief, residentIndividualRelief) || other.residentIndividualRelief == residentIndividualRelief)&&const DeepCollectionEquality().equals(other.reliefs, reliefs)&&(identical(other.totalReliefs, totalReliefs) || other.totalReliefs == totalReliefs)&&(identical(other.chargeableIncome, chargeableIncome) || other.chargeableIncome == chargeableIncome)&&(identical(other.grossTaxPayable, grossTaxPayable) || other.grossTaxPayable == grossTaxPayable)&&(identical(other.rebate, rebate) || other.rebate == rebate)&&(identical(other.zakatPaid, zakatPaid) || other.zakatPaid == zakatPaid)&&(identical(other.zakatRebate, zakatRebate) || other.zakatRebate == zakatRebate)&&(identical(other.taxAfterRebatesAndZakat, taxAfterRebatesAndZakat) || other.taxAfterRebatesAndZakat == taxAfterRebatesAndZakat)&&(identical(other.pcbPaid, pcbPaid) || other.pcbPaid == pcbPaid)&&(identical(other.estimatedPayableOrRefund, estimatedPayableOrRefund) || other.estimatedPayableOrRefund == estimatedPayableOrRefund)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearOfAssessment,totalIncome,residentIndividualRelief,const DeepCollectionEquality().hash(reliefs),totalReliefs,chargeableIncome,grossTaxPayable,rebate,zakatPaid,zakatRebate,taxAfterRebatesAndZakat,pcbPaid,estimatedPayableOrRefund,disclaimer);

@override
String toString() {
  return 'PersonalTaxCalculation(yearOfAssessment: $yearOfAssessment, totalIncome: $totalIncome, residentIndividualRelief: $residentIndividualRelief, reliefs: $reliefs, totalReliefs: $totalReliefs, chargeableIncome: $chargeableIncome, grossTaxPayable: $grossTaxPayable, rebate: $rebate, zakatPaid: $zakatPaid, zakatRebate: $zakatRebate, taxAfterRebatesAndZakat: $taxAfterRebatesAndZakat, pcbPaid: $pcbPaid, estimatedPayableOrRefund: $estimatedPayableOrRefund, disclaimer: $disclaimer)';
}


}

/// @nodoc
abstract mixin class $PersonalTaxCalculationCopyWith<$Res>  {
  factory $PersonalTaxCalculationCopyWith(PersonalTaxCalculation value, $Res Function(PersonalTaxCalculation) _then) = _$PersonalTaxCalculationCopyWithImpl;
@useResult
$Res call({
 int yearOfAssessment,@AmountConverter() String totalIncome,@AmountConverter() String residentIndividualRelief, List<TaxReliefLine> reliefs,@AmountConverter() String totalReliefs,@AmountConverter() String chargeableIncome,@AmountConverter() String grossTaxPayable,@AmountConverter() String rebate,@AmountConverter() String zakatPaid,@AmountConverter() String zakatRebate,@AmountConverter() String taxAfterRebatesAndZakat,@AmountConverter() String pcbPaid,@AmountConverter() String estimatedPayableOrRefund, String disclaimer
});




}
/// @nodoc
class _$PersonalTaxCalculationCopyWithImpl<$Res>
    implements $PersonalTaxCalculationCopyWith<$Res> {
  _$PersonalTaxCalculationCopyWithImpl(this._self, this._then);

  final PersonalTaxCalculation _self;
  final $Res Function(PersonalTaxCalculation) _then;

/// Create a copy of PersonalTaxCalculation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? yearOfAssessment = null,Object? totalIncome = null,Object? residentIndividualRelief = null,Object? reliefs = null,Object? totalReliefs = null,Object? chargeableIncome = null,Object? grossTaxPayable = null,Object? rebate = null,Object? zakatPaid = null,Object? zakatRebate = null,Object? taxAfterRebatesAndZakat = null,Object? pcbPaid = null,Object? estimatedPayableOrRefund = null,Object? disclaimer = null,}) {
  return _then(PersonalTaxCalculation(
yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,residentIndividualRelief: null == residentIndividualRelief ? _self.residentIndividualRelief : residentIndividualRelief // ignore: cast_nullable_to_non_nullable
as String,reliefs: null == reliefs ? _self.reliefs : reliefs // ignore: cast_nullable_to_non_nullable
as List<TaxReliefLine>,totalReliefs: null == totalReliefs ? _self.totalReliefs : totalReliefs // ignore: cast_nullable_to_non_nullable
as String,chargeableIncome: null == chargeableIncome ? _self.chargeableIncome : chargeableIncome // ignore: cast_nullable_to_non_nullable
as String,grossTaxPayable: null == grossTaxPayable ? _self.grossTaxPayable : grossTaxPayable // ignore: cast_nullable_to_non_nullable
as String,rebate: null == rebate ? _self.rebate : rebate // ignore: cast_nullable_to_non_nullable
as String,zakatPaid: null == zakatPaid ? _self.zakatPaid : zakatPaid // ignore: cast_nullable_to_non_nullable
as String,zakatRebate: null == zakatRebate ? _self.zakatRebate : zakatRebate // ignore: cast_nullable_to_non_nullable
as String,taxAfterRebatesAndZakat: null == taxAfterRebatesAndZakat ? _self.taxAfterRebatesAndZakat : taxAfterRebatesAndZakat // ignore: cast_nullable_to_non_nullable
as String,pcbPaid: null == pcbPaid ? _self.pcbPaid : pcbPaid // ignore: cast_nullable_to_non_nullable
as String,estimatedPayableOrRefund: null == estimatedPayableOrRefund ? _self.estimatedPayableOrRefund : estimatedPayableOrRefund // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalTaxCalculation].
extension PersonalTaxCalculationPatterns on PersonalTaxCalculation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalTaxCalculation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalTaxCalculation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalTaxCalculation value)  $default,){
final _that = this;
switch (_that) {
case _PersonalTaxCalculation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalTaxCalculation value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalTaxCalculation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int yearOfAssessment, @AmountConverter()  String totalIncome, @AmountConverter()  String residentIndividualRelief,  List<TaxReliefLine> reliefs, @AmountConverter()  String totalReliefs, @AmountConverter()  String chargeableIncome, @AmountConverter()  String grossTaxPayable, @AmountConverter()  String rebate, @AmountConverter()  String zakatPaid, @AmountConverter()  String zakatRebate, @AmountConverter()  String taxAfterRebatesAndZakat, @AmountConverter()  String pcbPaid, @AmountConverter()  String estimatedPayableOrRefund,  String disclaimer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalTaxCalculation() when $default != null:
return $default(_that.yearOfAssessment,_that.totalIncome,_that.residentIndividualRelief,_that.reliefs,_that.totalReliefs,_that.chargeableIncome,_that.grossTaxPayable,_that.rebate,_that.zakatPaid,_that.zakatRebate,_that.taxAfterRebatesAndZakat,_that.pcbPaid,_that.estimatedPayableOrRefund,_that.disclaimer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int yearOfAssessment, @AmountConverter()  String totalIncome, @AmountConverter()  String residentIndividualRelief,  List<TaxReliefLine> reliefs, @AmountConverter()  String totalReliefs, @AmountConverter()  String chargeableIncome, @AmountConverter()  String grossTaxPayable, @AmountConverter()  String rebate, @AmountConverter()  String zakatPaid, @AmountConverter()  String zakatRebate, @AmountConverter()  String taxAfterRebatesAndZakat, @AmountConverter()  String pcbPaid, @AmountConverter()  String estimatedPayableOrRefund,  String disclaimer)  $default,) {final _that = this;
switch (_that) {
case _PersonalTaxCalculation():
return $default(_that.yearOfAssessment,_that.totalIncome,_that.residentIndividualRelief,_that.reliefs,_that.totalReliefs,_that.chargeableIncome,_that.grossTaxPayable,_that.rebate,_that.zakatPaid,_that.zakatRebate,_that.taxAfterRebatesAndZakat,_that.pcbPaid,_that.estimatedPayableOrRefund,_that.disclaimer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int yearOfAssessment, @AmountConverter()  String totalIncome, @AmountConverter()  String residentIndividualRelief,  List<TaxReliefLine> reliefs, @AmountConverter()  String totalReliefs, @AmountConverter()  String chargeableIncome, @AmountConverter()  String grossTaxPayable, @AmountConverter()  String rebate, @AmountConverter()  String zakatPaid, @AmountConverter()  String zakatRebate, @AmountConverter()  String taxAfterRebatesAndZakat, @AmountConverter()  String pcbPaid, @AmountConverter()  String estimatedPayableOrRefund,  String disclaimer)?  $default,) {final _that = this;
switch (_that) {
case _PersonalTaxCalculation() when $default != null:
return $default(_that.yearOfAssessment,_that.totalIncome,_that.residentIndividualRelief,_that.reliefs,_that.totalReliefs,_that.chargeableIncome,_that.grossTaxPayable,_that.rebate,_that.zakatPaid,_that.zakatRebate,_that.taxAfterRebatesAndZakat,_that.pcbPaid,_that.estimatedPayableOrRefund,_that.disclaimer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonalTaxCalculation implements PersonalTaxCalculation {
  const _PersonalTaxCalculation({required this.yearOfAssessment, @AmountConverter() required this.totalIncome, @AmountConverter() required this.residentIndividualRelief, required  List<TaxReliefLine> reliefs, @AmountConverter() required this.totalReliefs, @AmountConverter() required this.chargeableIncome, @AmountConverter() required this.grossTaxPayable, @AmountConverter() required this.rebate, @AmountConverter() required this.zakatPaid, @AmountConverter() required this.zakatRebate, @AmountConverter() required this.taxAfterRebatesAndZakat, @AmountConverter() required this.pcbPaid, @AmountConverter() required this.estimatedPayableOrRefund, required this.disclaimer}): _reliefs = reliefs;
  factory _PersonalTaxCalculation.fromJson(Map<String, dynamic> json) => _$PersonalTaxCalculationFromJson(json);

@override final  int yearOfAssessment;
@override@AmountConverter() final  String totalIncome;
@override@AmountConverter() final  String residentIndividualRelief;
 final  List<TaxReliefLine> _reliefs;
@override List<TaxReliefLine> get reliefs {
  if (_reliefs is EqualUnmodifiableListView) return _reliefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reliefs);
}

@override@AmountConverter() final  String totalReliefs;
@override@AmountConverter() final  String chargeableIncome;
@override@AmountConverter() final  String grossTaxPayable;
@override@AmountConverter() final  String rebate;
@override@AmountConverter() final  String zakatPaid;
@override@AmountConverter() final  String zakatRebate;
@override@AmountConverter() final  String taxAfterRebatesAndZakat;
@override@AmountConverter() final  String pcbPaid;
@override@AmountConverter() final  String estimatedPayableOrRefund;
@override final  String disclaimer;

/// Create a copy of PersonalTaxCalculation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalTaxCalculationCopyWith<_PersonalTaxCalculation> get copyWith => __$PersonalTaxCalculationCopyWithImpl<_PersonalTaxCalculation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonalTaxCalculationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalTaxCalculation&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.residentIndividualRelief, residentIndividualRelief) || other.residentIndividualRelief == residentIndividualRelief)&&const DeepCollectionEquality().equals(other._reliefs, _reliefs)&&(identical(other.totalReliefs, totalReliefs) || other.totalReliefs == totalReliefs)&&(identical(other.chargeableIncome, chargeableIncome) || other.chargeableIncome == chargeableIncome)&&(identical(other.grossTaxPayable, grossTaxPayable) || other.grossTaxPayable == grossTaxPayable)&&(identical(other.rebate, rebate) || other.rebate == rebate)&&(identical(other.zakatPaid, zakatPaid) || other.zakatPaid == zakatPaid)&&(identical(other.zakatRebate, zakatRebate) || other.zakatRebate == zakatRebate)&&(identical(other.taxAfterRebatesAndZakat, taxAfterRebatesAndZakat) || other.taxAfterRebatesAndZakat == taxAfterRebatesAndZakat)&&(identical(other.pcbPaid, pcbPaid) || other.pcbPaid == pcbPaid)&&(identical(other.estimatedPayableOrRefund, estimatedPayableOrRefund) || other.estimatedPayableOrRefund == estimatedPayableOrRefund)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearOfAssessment,totalIncome,residentIndividualRelief,const DeepCollectionEquality().hash(_reliefs),totalReliefs,chargeableIncome,grossTaxPayable,rebate,zakatPaid,zakatRebate,taxAfterRebatesAndZakat,pcbPaid,estimatedPayableOrRefund,disclaimer);

@override
String toString() {
  return 'PersonalTaxCalculation(yearOfAssessment: $yearOfAssessment, totalIncome: $totalIncome, residentIndividualRelief: $residentIndividualRelief, reliefs: $reliefs, totalReliefs: $totalReliefs, chargeableIncome: $chargeableIncome, grossTaxPayable: $grossTaxPayable, rebate: $rebate, zakatPaid: $zakatPaid, zakatRebate: $zakatRebate, taxAfterRebatesAndZakat: $taxAfterRebatesAndZakat, pcbPaid: $pcbPaid, estimatedPayableOrRefund: $estimatedPayableOrRefund, disclaimer: $disclaimer)';
}


}

/// @nodoc
abstract mixin class _$PersonalTaxCalculationCopyWith<$Res> implements $PersonalTaxCalculationCopyWith<$Res> {
  factory _$PersonalTaxCalculationCopyWith(_PersonalTaxCalculation value, $Res Function(_PersonalTaxCalculation) _then) = __$PersonalTaxCalculationCopyWithImpl;
@override @useResult
$Res call({
 int yearOfAssessment,@AmountConverter() String totalIncome,@AmountConverter() String residentIndividualRelief, List<TaxReliefLine> reliefs,@AmountConverter() String totalReliefs,@AmountConverter() String chargeableIncome,@AmountConverter() String grossTaxPayable,@AmountConverter() String rebate,@AmountConverter() String zakatPaid,@AmountConverter() String zakatRebate,@AmountConverter() String taxAfterRebatesAndZakat,@AmountConverter() String pcbPaid,@AmountConverter() String estimatedPayableOrRefund, String disclaimer
});




}
/// @nodoc
class __$PersonalTaxCalculationCopyWithImpl<$Res>
    implements _$PersonalTaxCalculationCopyWith<$Res> {
  __$PersonalTaxCalculationCopyWithImpl(this._self, this._then);

  final _PersonalTaxCalculation _self;
  final $Res Function(_PersonalTaxCalculation) _then;

/// Create a copy of PersonalTaxCalculation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? yearOfAssessment = null,Object? totalIncome = null,Object? residentIndividualRelief = null,Object? reliefs = null,Object? totalReliefs = null,Object? chargeableIncome = null,Object? grossTaxPayable = null,Object? rebate = null,Object? zakatPaid = null,Object? zakatRebate = null,Object? taxAfterRebatesAndZakat = null,Object? pcbPaid = null,Object? estimatedPayableOrRefund = null,Object? disclaimer = null,}) {
  return _then(_PersonalTaxCalculation(
yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,residentIndividualRelief: null == residentIndividualRelief ? _self.residentIndividualRelief : residentIndividualRelief // ignore: cast_nullable_to_non_nullable
as String,reliefs: null == reliefs ? _self._reliefs : reliefs // ignore: cast_nullable_to_non_nullable
as List<TaxReliefLine>,totalReliefs: null == totalReliefs ? _self.totalReliefs : totalReliefs // ignore: cast_nullable_to_non_nullable
as String,chargeableIncome: null == chargeableIncome ? _self.chargeableIncome : chargeableIncome // ignore: cast_nullable_to_non_nullable
as String,grossTaxPayable: null == grossTaxPayable ? _self.grossTaxPayable : grossTaxPayable // ignore: cast_nullable_to_non_nullable
as String,rebate: null == rebate ? _self.rebate : rebate // ignore: cast_nullable_to_non_nullable
as String,zakatPaid: null == zakatPaid ? _self.zakatPaid : zakatPaid // ignore: cast_nullable_to_non_nullable
as String,zakatRebate: null == zakatRebate ? _self.zakatRebate : zakatRebate // ignore: cast_nullable_to_non_nullable
as String,taxAfterRebatesAndZakat: null == taxAfterRebatesAndZakat ? _self.taxAfterRebatesAndZakat : taxAfterRebatesAndZakat // ignore: cast_nullable_to_non_nullable
as String,pcbPaid: null == pcbPaid ? _self.pcbPaid : pcbPaid // ignore: cast_nullable_to_non_nullable
as String,estimatedPayableOrRefund: null == estimatedPayableOrRefund ? _self.estimatedPayableOrRefund : estimatedPayableOrRefund // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FilingReadinessItem {

 String get key; String get label; bool get ready; String get explanation;
/// Create a copy of FilingReadinessItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilingReadinessItemCopyWith<FilingReadinessItem> get copyWith => _$FilingReadinessItemCopyWithImpl<FilingReadinessItem>(this as FilingReadinessItem, _$identity);

  /// Serializes this FilingReadinessItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilingReadinessItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,ready,explanation);

@override
String toString() {
  return 'FilingReadinessItem(key: $key, label: $label, ready: $ready, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $FilingReadinessItemCopyWith<$Res>  {
  factory $FilingReadinessItemCopyWith(FilingReadinessItem value, $Res Function(FilingReadinessItem) _then) = _$FilingReadinessItemCopyWithImpl;
@useResult
$Res call({
 String key, String label, bool ready, String explanation
});




}
/// @nodoc
class _$FilingReadinessItemCopyWithImpl<$Res>
    implements $FilingReadinessItemCopyWith<$Res> {
  _$FilingReadinessItemCopyWithImpl(this._self, this._then);

  final FilingReadinessItem _self;
  final $Res Function(FilingReadinessItem) _then;

/// Create a copy of FilingReadinessItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? ready = null,Object? explanation = null,}) {
  return _then(FilingReadinessItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FilingReadinessItem].
extension FilingReadinessItemPatterns on FilingReadinessItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilingReadinessItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilingReadinessItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilingReadinessItem value)  $default,){
final _that = this;
switch (_that) {
case _FilingReadinessItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilingReadinessItem value)?  $default,){
final _that = this;
switch (_that) {
case _FilingReadinessItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  bool ready,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilingReadinessItem() when $default != null:
return $default(_that.key,_that.label,_that.ready,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  bool ready,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _FilingReadinessItem():
return $default(_that.key,_that.label,_that.ready,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  bool ready,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _FilingReadinessItem() when $default != null:
return $default(_that.key,_that.label,_that.ready,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilingReadinessItem implements FilingReadinessItem {
  const _FilingReadinessItem({required this.key, required this.label, required this.ready, required this.explanation});
  factory _FilingReadinessItem.fromJson(Map<String, dynamic> json) => _$FilingReadinessItemFromJson(json);

@override final  String key;
@override final  String label;
@override final  bool ready;
@override final  String explanation;

/// Create a copy of FilingReadinessItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilingReadinessItemCopyWith<_FilingReadinessItem> get copyWith => __$FilingReadinessItemCopyWithImpl<_FilingReadinessItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilingReadinessItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilingReadinessItem&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,ready,explanation);

@override
String toString() {
  return 'FilingReadinessItem(key: $key, label: $label, ready: $ready, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$FilingReadinessItemCopyWith<$Res> implements $FilingReadinessItemCopyWith<$Res> {
  factory _$FilingReadinessItemCopyWith(_FilingReadinessItem value, $Res Function(_FilingReadinessItem) _then) = __$FilingReadinessItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, bool ready, String explanation
});




}
/// @nodoc
class __$FilingReadinessItemCopyWithImpl<$Res>
    implements _$FilingReadinessItemCopyWith<$Res> {
  __$FilingReadinessItemCopyWithImpl(this._self, this._then);

  final _FilingReadinessItem _self;
  final $Res Function(_FilingReadinessItem) _then;

/// Create a copy of FilingReadinessItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? ready = null,Object? explanation = null,}) {
  return _then(_FilingReadinessItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FilingReadiness {

 int get yearOfAssessment;@AmountConverter() String get readyPercent; List<FilingReadinessItem> get items;
/// Create a copy of FilingReadiness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilingReadinessCopyWith<FilingReadiness> get copyWith => _$FilingReadinessCopyWithImpl<FilingReadiness>(this as FilingReadiness, _$identity);

  /// Serializes this FilingReadiness to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilingReadiness&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.readyPercent, readyPercent) || other.readyPercent == readyPercent)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearOfAssessment,readyPercent,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'FilingReadiness(yearOfAssessment: $yearOfAssessment, readyPercent: $readyPercent, items: $items)';
}


}

/// @nodoc
abstract mixin class $FilingReadinessCopyWith<$Res>  {
  factory $FilingReadinessCopyWith(FilingReadiness value, $Res Function(FilingReadiness) _then) = _$FilingReadinessCopyWithImpl;
@useResult
$Res call({
 int yearOfAssessment,@AmountConverter() String readyPercent, List<FilingReadinessItem> items
});




}
/// @nodoc
class _$FilingReadinessCopyWithImpl<$Res>
    implements $FilingReadinessCopyWith<$Res> {
  _$FilingReadinessCopyWithImpl(this._self, this._then);

  final FilingReadiness _self;
  final $Res Function(FilingReadiness) _then;

/// Create a copy of FilingReadiness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? yearOfAssessment = null,Object? readyPercent = null,Object? items = null,}) {
  return _then(FilingReadiness(
yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,readyPercent: null == readyPercent ? _self.readyPercent : readyPercent // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FilingReadinessItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [FilingReadiness].
extension FilingReadinessPatterns on FilingReadiness {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilingReadiness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilingReadiness() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilingReadiness value)  $default,){
final _that = this;
switch (_that) {
case _FilingReadiness():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilingReadiness value)?  $default,){
final _that = this;
switch (_that) {
case _FilingReadiness() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int yearOfAssessment, @AmountConverter()  String readyPercent,  List<FilingReadinessItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilingReadiness() when $default != null:
return $default(_that.yearOfAssessment,_that.readyPercent,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int yearOfAssessment, @AmountConverter()  String readyPercent,  List<FilingReadinessItem> items)  $default,) {final _that = this;
switch (_that) {
case _FilingReadiness():
return $default(_that.yearOfAssessment,_that.readyPercent,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int yearOfAssessment, @AmountConverter()  String readyPercent,  List<FilingReadinessItem> items)?  $default,) {final _that = this;
switch (_that) {
case _FilingReadiness() when $default != null:
return $default(_that.yearOfAssessment,_that.readyPercent,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilingReadiness implements FilingReadiness {
  const _FilingReadiness({required this.yearOfAssessment, @AmountConverter() required this.readyPercent, required  List<FilingReadinessItem> items}): _items = items;
  factory _FilingReadiness.fromJson(Map<String, dynamic> json) => _$FilingReadinessFromJson(json);

@override final  int yearOfAssessment;
@override@AmountConverter() final  String readyPercent;
 final  List<FilingReadinessItem> _items;
@override List<FilingReadinessItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of FilingReadiness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilingReadinessCopyWith<_FilingReadiness> get copyWith => __$FilingReadinessCopyWithImpl<_FilingReadiness>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilingReadinessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilingReadiness&&(identical(other.yearOfAssessment, yearOfAssessment) || other.yearOfAssessment == yearOfAssessment)&&(identical(other.readyPercent, readyPercent) || other.readyPercent == readyPercent)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,yearOfAssessment,readyPercent,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'FilingReadiness(yearOfAssessment: $yearOfAssessment, readyPercent: $readyPercent, items: $items)';
}


}

/// @nodoc
abstract mixin class _$FilingReadinessCopyWith<$Res> implements $FilingReadinessCopyWith<$Res> {
  factory _$FilingReadinessCopyWith(_FilingReadiness value, $Res Function(_FilingReadiness) _then) = __$FilingReadinessCopyWithImpl;
@override @useResult
$Res call({
 int yearOfAssessment,@AmountConverter() String readyPercent, List<FilingReadinessItem> items
});




}
/// @nodoc
class __$FilingReadinessCopyWithImpl<$Res>
    implements _$FilingReadinessCopyWith<$Res> {
  __$FilingReadinessCopyWithImpl(this._self, this._then);

  final _FilingReadiness _self;
  final $Res Function(_FilingReadiness) _then;

/// Create a copy of FilingReadiness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? yearOfAssessment = null,Object? readyPercent = null,Object? items = null,}) {
  return _then(_FilingReadiness(
yearOfAssessment: null == yearOfAssessment ? _self.yearOfAssessment : yearOfAssessment // ignore: cast_nullable_to_non_nullable
as int,readyPercent: null == readyPercent ? _self.readyPercent : readyPercent // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FilingReadinessItem>,
  ));
}


}

// dart format on
