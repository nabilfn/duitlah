// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Liability {

 String get id; LiabilityType get type; String get name; String? get lender;@AmountConverter() String get originalAmount;@AmountConverter() String get outstandingPrincipal;@NullableAmountConverter() String? get interestRatePercent;@NullableAmountConverter() String? get instalmentAmount; String? get nextDueDate; String? get maturityDate; LiabilityStatus get status;
/// Create a copy of Liability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiabilityCopyWith<Liability> get copyWith => _$LiabilityCopyWithImpl<Liability>(this as Liability, _$identity);

  /// Serializes this Liability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Liability&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.lender, lender) || other.lender == lender)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.outstandingPrincipal, outstandingPrincipal) || other.outstandingPrincipal == outstandingPrincipal)&&(identical(other.interestRatePercent, interestRatePercent) || other.interestRatePercent == interestRatePercent)&&(identical(other.instalmentAmount, instalmentAmount) || other.instalmentAmount == instalmentAmount)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.maturityDate, maturityDate) || other.maturityDate == maturityDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,lender,originalAmount,outstandingPrincipal,interestRatePercent,instalmentAmount,nextDueDate,maturityDate,status);

@override
String toString() {
  return 'Liability(id: $id, type: $type, name: $name, lender: $lender, originalAmount: $originalAmount, outstandingPrincipal: $outstandingPrincipal, interestRatePercent: $interestRatePercent, instalmentAmount: $instalmentAmount, nextDueDate: $nextDueDate, maturityDate: $maturityDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $LiabilityCopyWith<$Res>  {
  factory $LiabilityCopyWith(Liability value, $Res Function(Liability) _then) = _$LiabilityCopyWithImpl;
@useResult
$Res call({
 String id, LiabilityType type, String name, String? lender,@AmountConverter() String originalAmount,@AmountConverter() String outstandingPrincipal,@NullableAmountConverter() String? interestRatePercent,@NullableAmountConverter() String? instalmentAmount, String? nextDueDate, String? maturityDate, LiabilityStatus status
});




}
/// @nodoc
class _$LiabilityCopyWithImpl<$Res>
    implements $LiabilityCopyWith<$Res> {
  _$LiabilityCopyWithImpl(this._self, this._then);

  final Liability _self;
  final $Res Function(Liability) _then;

/// Create a copy of Liability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? lender = freezed,Object? originalAmount = null,Object? outstandingPrincipal = null,Object? interestRatePercent = freezed,Object? instalmentAmount = freezed,Object? nextDueDate = freezed,Object? maturityDate = freezed,Object? status = null,}) {
  return _then(Liability(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LiabilityType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lender: freezed == lender ? _self.lender : lender // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: null == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as String,outstandingPrincipal: null == outstandingPrincipal ? _self.outstandingPrincipal : outstandingPrincipal // ignore: cast_nullable_to_non_nullable
as String,interestRatePercent: freezed == interestRatePercent ? _self.interestRatePercent : interestRatePercent // ignore: cast_nullable_to_non_nullable
as String?,instalmentAmount: freezed == instalmentAmount ? _self.instalmentAmount : instalmentAmount // ignore: cast_nullable_to_non_nullable
as String?,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as String?,maturityDate: freezed == maturityDate ? _self.maturityDate : maturityDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LiabilityStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Liability].
extension LiabilityPatterns on Liability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Liability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Liability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Liability value)  $default,){
final _that = this;
switch (_that) {
case _Liability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Liability value)?  $default,){
final _that = this;
switch (_that) {
case _Liability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LiabilityType type,  String name,  String? lender, @AmountConverter()  String originalAmount, @AmountConverter()  String outstandingPrincipal, @NullableAmountConverter()  String? interestRatePercent, @NullableAmountConverter()  String? instalmentAmount,  String? nextDueDate,  String? maturityDate,  LiabilityStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Liability() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.lender,_that.originalAmount,_that.outstandingPrincipal,_that.interestRatePercent,_that.instalmentAmount,_that.nextDueDate,_that.maturityDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LiabilityType type,  String name,  String? lender, @AmountConverter()  String originalAmount, @AmountConverter()  String outstandingPrincipal, @NullableAmountConverter()  String? interestRatePercent, @NullableAmountConverter()  String? instalmentAmount,  String? nextDueDate,  String? maturityDate,  LiabilityStatus status)  $default,) {final _that = this;
switch (_that) {
case _Liability():
return $default(_that.id,_that.type,_that.name,_that.lender,_that.originalAmount,_that.outstandingPrincipal,_that.interestRatePercent,_that.instalmentAmount,_that.nextDueDate,_that.maturityDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LiabilityType type,  String name,  String? lender, @AmountConverter()  String originalAmount, @AmountConverter()  String outstandingPrincipal, @NullableAmountConverter()  String? interestRatePercent, @NullableAmountConverter()  String? instalmentAmount,  String? nextDueDate,  String? maturityDate,  LiabilityStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Liability() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.lender,_that.originalAmount,_that.outstandingPrincipal,_that.interestRatePercent,_that.instalmentAmount,_that.nextDueDate,_that.maturityDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Liability implements Liability {
  const _Liability({required this.id, required this.type, required this.name, this.lender, @AmountConverter() required this.originalAmount, @AmountConverter() required this.outstandingPrincipal, @NullableAmountConverter() this.interestRatePercent, @NullableAmountConverter() this.instalmentAmount, this.nextDueDate, this.maturityDate, required this.status});
  factory _Liability.fromJson(Map<String, dynamic> json) => _$LiabilityFromJson(json);

@override final  String id;
@override final  LiabilityType type;
@override final  String name;
@override final  String? lender;
@override@AmountConverter() final  String originalAmount;
@override@AmountConverter() final  String outstandingPrincipal;
@override@NullableAmountConverter() final  String? interestRatePercent;
@override@NullableAmountConverter() final  String? instalmentAmount;
@override final  String? nextDueDate;
@override final  String? maturityDate;
@override final  LiabilityStatus status;

/// Create a copy of Liability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiabilityCopyWith<_Liability> get copyWith => __$LiabilityCopyWithImpl<_Liability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Liability&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.lender, lender) || other.lender == lender)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.outstandingPrincipal, outstandingPrincipal) || other.outstandingPrincipal == outstandingPrincipal)&&(identical(other.interestRatePercent, interestRatePercent) || other.interestRatePercent == interestRatePercent)&&(identical(other.instalmentAmount, instalmentAmount) || other.instalmentAmount == instalmentAmount)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.maturityDate, maturityDate) || other.maturityDate == maturityDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,lender,originalAmount,outstandingPrincipal,interestRatePercent,instalmentAmount,nextDueDate,maturityDate,status);

@override
String toString() {
  return 'Liability(id: $id, type: $type, name: $name, lender: $lender, originalAmount: $originalAmount, outstandingPrincipal: $outstandingPrincipal, interestRatePercent: $interestRatePercent, instalmentAmount: $instalmentAmount, nextDueDate: $nextDueDate, maturityDate: $maturityDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$LiabilityCopyWith<$Res> implements $LiabilityCopyWith<$Res> {
  factory _$LiabilityCopyWith(_Liability value, $Res Function(_Liability) _then) = __$LiabilityCopyWithImpl;
@override @useResult
$Res call({
 String id, LiabilityType type, String name, String? lender,@AmountConverter() String originalAmount,@AmountConverter() String outstandingPrincipal,@NullableAmountConverter() String? interestRatePercent,@NullableAmountConverter() String? instalmentAmount, String? nextDueDate, String? maturityDate, LiabilityStatus status
});




}
/// @nodoc
class __$LiabilityCopyWithImpl<$Res>
    implements _$LiabilityCopyWith<$Res> {
  __$LiabilityCopyWithImpl(this._self, this._then);

  final _Liability _self;
  final $Res Function(_Liability) _then;

/// Create a copy of Liability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? lender = freezed,Object? originalAmount = null,Object? outstandingPrincipal = null,Object? interestRatePercent = freezed,Object? instalmentAmount = freezed,Object? nextDueDate = freezed,Object? maturityDate = freezed,Object? status = null,}) {
  return _then(_Liability(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LiabilityType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lender: freezed == lender ? _self.lender : lender // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: null == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as String,outstandingPrincipal: null == outstandingPrincipal ? _self.outstandingPrincipal : outstandingPrincipal // ignore: cast_nullable_to_non_nullable
as String,interestRatePercent: freezed == interestRatePercent ? _self.interestRatePercent : interestRatePercent // ignore: cast_nullable_to_non_nullable
as String?,instalmentAmount: freezed == instalmentAmount ? _self.instalmentAmount : instalmentAmount // ignore: cast_nullable_to_non_nullable
as String?,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as String?,maturityDate: freezed == maturityDate ? _self.maturityDate : maturityDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LiabilityStatus,
  ));
}


}


/// @nodoc
mixin _$LiabilityPayment {

 String get id;@AmountConverter() String get amount;@AmountConverter() String get principalPortion;@AmountConverter() String get interestPortion; String get paidOn; String? get linkedTransactionId;
/// Create a copy of LiabilityPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiabilityPaymentCopyWith<LiabilityPayment> get copyWith => _$LiabilityPaymentCopyWithImpl<LiabilityPayment>(this as LiabilityPayment, _$identity);

  /// Serializes this LiabilityPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiabilityPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.principalPortion, principalPortion) || other.principalPortion == principalPortion)&&(identical(other.interestPortion, interestPortion) || other.interestPortion == interestPortion)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.linkedTransactionId, linkedTransactionId) || other.linkedTransactionId == linkedTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,principalPortion,interestPortion,paidOn,linkedTransactionId);

@override
String toString() {
  return 'LiabilityPayment(id: $id, amount: $amount, principalPortion: $principalPortion, interestPortion: $interestPortion, paidOn: $paidOn, linkedTransactionId: $linkedTransactionId)';
}


}

/// @nodoc
abstract mixin class $LiabilityPaymentCopyWith<$Res>  {
  factory $LiabilityPaymentCopyWith(LiabilityPayment value, $Res Function(LiabilityPayment) _then) = _$LiabilityPaymentCopyWithImpl;
@useResult
$Res call({
 String id,@AmountConverter() String amount,@AmountConverter() String principalPortion,@AmountConverter() String interestPortion, String paidOn, String? linkedTransactionId
});




}
/// @nodoc
class _$LiabilityPaymentCopyWithImpl<$Res>
    implements $LiabilityPaymentCopyWith<$Res> {
  _$LiabilityPaymentCopyWithImpl(this._self, this._then);

  final LiabilityPayment _self;
  final $Res Function(LiabilityPayment) _then;

/// Create a copy of LiabilityPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? principalPortion = null,Object? interestPortion = null,Object? paidOn = null,Object? linkedTransactionId = freezed,}) {
  return _then(LiabilityPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,principalPortion: null == principalPortion ? _self.principalPortion : principalPortion // ignore: cast_nullable_to_non_nullable
as String,interestPortion: null == interestPortion ? _self.interestPortion : interestPortion // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,linkedTransactionId: freezed == linkedTransactionId ? _self.linkedTransactionId : linkedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiabilityPayment].
extension LiabilityPaymentPatterns on LiabilityPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiabilityPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiabilityPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiabilityPayment value)  $default,){
final _that = this;
switch (_that) {
case _LiabilityPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiabilityPayment value)?  $default,){
final _that = this;
switch (_that) {
case _LiabilityPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @AmountConverter()  String amount, @AmountConverter()  String principalPortion, @AmountConverter()  String interestPortion,  String paidOn,  String? linkedTransactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiabilityPayment() when $default != null:
return $default(_that.id,_that.amount,_that.principalPortion,_that.interestPortion,_that.paidOn,_that.linkedTransactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @AmountConverter()  String amount, @AmountConverter()  String principalPortion, @AmountConverter()  String interestPortion,  String paidOn,  String? linkedTransactionId)  $default,) {final _that = this;
switch (_that) {
case _LiabilityPayment():
return $default(_that.id,_that.amount,_that.principalPortion,_that.interestPortion,_that.paidOn,_that.linkedTransactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @AmountConverter()  String amount, @AmountConverter()  String principalPortion, @AmountConverter()  String interestPortion,  String paidOn,  String? linkedTransactionId)?  $default,) {final _that = this;
switch (_that) {
case _LiabilityPayment() when $default != null:
return $default(_that.id,_that.amount,_that.principalPortion,_that.interestPortion,_that.paidOn,_that.linkedTransactionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiabilityPayment implements LiabilityPayment {
  const _LiabilityPayment({required this.id, @AmountConverter() required this.amount, @AmountConverter() required this.principalPortion, @AmountConverter() required this.interestPortion, required this.paidOn, this.linkedTransactionId});
  factory _LiabilityPayment.fromJson(Map<String, dynamic> json) => _$LiabilityPaymentFromJson(json);

@override final  String id;
@override@AmountConverter() final  String amount;
@override@AmountConverter() final  String principalPortion;
@override@AmountConverter() final  String interestPortion;
@override final  String paidOn;
@override final  String? linkedTransactionId;

/// Create a copy of LiabilityPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiabilityPaymentCopyWith<_LiabilityPayment> get copyWith => __$LiabilityPaymentCopyWithImpl<_LiabilityPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiabilityPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiabilityPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.principalPortion, principalPortion) || other.principalPortion == principalPortion)&&(identical(other.interestPortion, interestPortion) || other.interestPortion == interestPortion)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.linkedTransactionId, linkedTransactionId) || other.linkedTransactionId == linkedTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,principalPortion,interestPortion,paidOn,linkedTransactionId);

@override
String toString() {
  return 'LiabilityPayment(id: $id, amount: $amount, principalPortion: $principalPortion, interestPortion: $interestPortion, paidOn: $paidOn, linkedTransactionId: $linkedTransactionId)';
}


}

/// @nodoc
abstract mixin class _$LiabilityPaymentCopyWith<$Res> implements $LiabilityPaymentCopyWith<$Res> {
  factory _$LiabilityPaymentCopyWith(_LiabilityPayment value, $Res Function(_LiabilityPayment) _then) = __$LiabilityPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id,@AmountConverter() String amount,@AmountConverter() String principalPortion,@AmountConverter() String interestPortion, String paidOn, String? linkedTransactionId
});




}
/// @nodoc
class __$LiabilityPaymentCopyWithImpl<$Res>
    implements _$LiabilityPaymentCopyWith<$Res> {
  __$LiabilityPaymentCopyWithImpl(this._self, this._then);

  final _LiabilityPayment _self;
  final $Res Function(_LiabilityPayment) _then;

/// Create a copy of LiabilityPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? principalPortion = null,Object? interestPortion = null,Object? paidOn = null,Object? linkedTransactionId = freezed,}) {
  return _then(_LiabilityPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,principalPortion: null == principalPortion ? _self.principalPortion : principalPortion // ignore: cast_nullable_to_non_nullable
as String,interestPortion: null == interestPortion ? _self.interestPortion : interestPortion // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,linkedTransactionId: freezed == linkedTransactionId ? _self.linkedTransactionId : linkedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreditCardDetails {

 String get accountId;@AmountConverter() String get creditLimit; int get statementDay; int get paymentDueDay;@AmountConverter() String get minimumPaymentPercent;@AmountConverter() String get currentOutstanding;@AmountConverter() String get availableCredit;@AmountConverter() String get utilization;@AmountConverter() String get statementBalance;@AmountConverter() String get minimumPaymentDue;
/// Create a copy of CreditCardDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditCardDetailsCopyWith<CreditCardDetails> get copyWith => _$CreditCardDetailsCopyWithImpl<CreditCardDetails>(this as CreditCardDetails, _$identity);

  /// Serializes this CreditCardDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditCardDetails&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.statementDay, statementDay) || other.statementDay == statementDay)&&(identical(other.paymentDueDay, paymentDueDay) || other.paymentDueDay == paymentDueDay)&&(identical(other.minimumPaymentPercent, minimumPaymentPercent) || other.minimumPaymentPercent == minimumPaymentPercent)&&(identical(other.currentOutstanding, currentOutstanding) || other.currentOutstanding == currentOutstanding)&&(identical(other.availableCredit, availableCredit) || other.availableCredit == availableCredit)&&(identical(other.utilization, utilization) || other.utilization == utilization)&&(identical(other.statementBalance, statementBalance) || other.statementBalance == statementBalance)&&(identical(other.minimumPaymentDue, minimumPaymentDue) || other.minimumPaymentDue == minimumPaymentDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,creditLimit,statementDay,paymentDueDay,minimumPaymentPercent,currentOutstanding,availableCredit,utilization,statementBalance,minimumPaymentDue);

@override
String toString() {
  return 'CreditCardDetails(accountId: $accountId, creditLimit: $creditLimit, statementDay: $statementDay, paymentDueDay: $paymentDueDay, minimumPaymentPercent: $minimumPaymentPercent, currentOutstanding: $currentOutstanding, availableCredit: $availableCredit, utilization: $utilization, statementBalance: $statementBalance, minimumPaymentDue: $minimumPaymentDue)';
}


}

/// @nodoc
abstract mixin class $CreditCardDetailsCopyWith<$Res>  {
  factory $CreditCardDetailsCopyWith(CreditCardDetails value, $Res Function(CreditCardDetails) _then) = _$CreditCardDetailsCopyWithImpl;
@useResult
$Res call({
 String accountId,@AmountConverter() String creditLimit, int statementDay, int paymentDueDay,@AmountConverter() String minimumPaymentPercent,@AmountConverter() String currentOutstanding,@AmountConverter() String availableCredit,@AmountConverter() String utilization,@AmountConverter() String statementBalance,@AmountConverter() String minimumPaymentDue
});




}
/// @nodoc
class _$CreditCardDetailsCopyWithImpl<$Res>
    implements $CreditCardDetailsCopyWith<$Res> {
  _$CreditCardDetailsCopyWithImpl(this._self, this._then);

  final CreditCardDetails _self;
  final $Res Function(CreditCardDetails) _then;

/// Create a copy of CreditCardDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? creditLimit = null,Object? statementDay = null,Object? paymentDueDay = null,Object? minimumPaymentPercent = null,Object? currentOutstanding = null,Object? availableCredit = null,Object? utilization = null,Object? statementBalance = null,Object? minimumPaymentDue = null,}) {
  return _then(CreditCardDetails(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,creditLimit: null == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as String,statementDay: null == statementDay ? _self.statementDay : statementDay // ignore: cast_nullable_to_non_nullable
as int,paymentDueDay: null == paymentDueDay ? _self.paymentDueDay : paymentDueDay // ignore: cast_nullable_to_non_nullable
as int,minimumPaymentPercent: null == minimumPaymentPercent ? _self.minimumPaymentPercent : minimumPaymentPercent // ignore: cast_nullable_to_non_nullable
as String,currentOutstanding: null == currentOutstanding ? _self.currentOutstanding : currentOutstanding // ignore: cast_nullable_to_non_nullable
as String,availableCredit: null == availableCredit ? _self.availableCredit : availableCredit // ignore: cast_nullable_to_non_nullable
as String,utilization: null == utilization ? _self.utilization : utilization // ignore: cast_nullable_to_non_nullable
as String,statementBalance: null == statementBalance ? _self.statementBalance : statementBalance // ignore: cast_nullable_to_non_nullable
as String,minimumPaymentDue: null == minimumPaymentDue ? _self.minimumPaymentDue : minimumPaymentDue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditCardDetails].
extension CreditCardDetailsPatterns on CreditCardDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditCardDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditCardDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditCardDetails value)  $default,){
final _that = this;
switch (_that) {
case _CreditCardDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditCardDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CreditCardDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId, @AmountConverter()  String creditLimit,  int statementDay,  int paymentDueDay, @AmountConverter()  String minimumPaymentPercent, @AmountConverter()  String currentOutstanding, @AmountConverter()  String availableCredit, @AmountConverter()  String utilization, @AmountConverter()  String statementBalance, @AmountConverter()  String minimumPaymentDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditCardDetails() when $default != null:
return $default(_that.accountId,_that.creditLimit,_that.statementDay,_that.paymentDueDay,_that.minimumPaymentPercent,_that.currentOutstanding,_that.availableCredit,_that.utilization,_that.statementBalance,_that.minimumPaymentDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId, @AmountConverter()  String creditLimit,  int statementDay,  int paymentDueDay, @AmountConverter()  String minimumPaymentPercent, @AmountConverter()  String currentOutstanding, @AmountConverter()  String availableCredit, @AmountConverter()  String utilization, @AmountConverter()  String statementBalance, @AmountConverter()  String minimumPaymentDue)  $default,) {final _that = this;
switch (_that) {
case _CreditCardDetails():
return $default(_that.accountId,_that.creditLimit,_that.statementDay,_that.paymentDueDay,_that.minimumPaymentPercent,_that.currentOutstanding,_that.availableCredit,_that.utilization,_that.statementBalance,_that.minimumPaymentDue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId, @AmountConverter()  String creditLimit,  int statementDay,  int paymentDueDay, @AmountConverter()  String minimumPaymentPercent, @AmountConverter()  String currentOutstanding, @AmountConverter()  String availableCredit, @AmountConverter()  String utilization, @AmountConverter()  String statementBalance, @AmountConverter()  String minimumPaymentDue)?  $default,) {final _that = this;
switch (_that) {
case _CreditCardDetails() when $default != null:
return $default(_that.accountId,_that.creditLimit,_that.statementDay,_that.paymentDueDay,_that.minimumPaymentPercent,_that.currentOutstanding,_that.availableCredit,_that.utilization,_that.statementBalance,_that.minimumPaymentDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditCardDetails implements CreditCardDetails {
  const _CreditCardDetails({required this.accountId, @AmountConverter() required this.creditLimit, required this.statementDay, required this.paymentDueDay, @AmountConverter() required this.minimumPaymentPercent, @AmountConverter() required this.currentOutstanding, @AmountConverter() required this.availableCredit, @AmountConverter() required this.utilization, @AmountConverter() required this.statementBalance, @AmountConverter() required this.minimumPaymentDue});
  factory _CreditCardDetails.fromJson(Map<String, dynamic> json) => _$CreditCardDetailsFromJson(json);

@override final  String accountId;
@override@AmountConverter() final  String creditLimit;
@override final  int statementDay;
@override final  int paymentDueDay;
@override@AmountConverter() final  String minimumPaymentPercent;
@override@AmountConverter() final  String currentOutstanding;
@override@AmountConverter() final  String availableCredit;
@override@AmountConverter() final  String utilization;
@override@AmountConverter() final  String statementBalance;
@override@AmountConverter() final  String minimumPaymentDue;

/// Create a copy of CreditCardDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditCardDetailsCopyWith<_CreditCardDetails> get copyWith => __$CreditCardDetailsCopyWithImpl<_CreditCardDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditCardDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditCardDetails&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.statementDay, statementDay) || other.statementDay == statementDay)&&(identical(other.paymentDueDay, paymentDueDay) || other.paymentDueDay == paymentDueDay)&&(identical(other.minimumPaymentPercent, minimumPaymentPercent) || other.minimumPaymentPercent == minimumPaymentPercent)&&(identical(other.currentOutstanding, currentOutstanding) || other.currentOutstanding == currentOutstanding)&&(identical(other.availableCredit, availableCredit) || other.availableCredit == availableCredit)&&(identical(other.utilization, utilization) || other.utilization == utilization)&&(identical(other.statementBalance, statementBalance) || other.statementBalance == statementBalance)&&(identical(other.minimumPaymentDue, minimumPaymentDue) || other.minimumPaymentDue == minimumPaymentDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,creditLimit,statementDay,paymentDueDay,minimumPaymentPercent,currentOutstanding,availableCredit,utilization,statementBalance,minimumPaymentDue);

@override
String toString() {
  return 'CreditCardDetails(accountId: $accountId, creditLimit: $creditLimit, statementDay: $statementDay, paymentDueDay: $paymentDueDay, minimumPaymentPercent: $minimumPaymentPercent, currentOutstanding: $currentOutstanding, availableCredit: $availableCredit, utilization: $utilization, statementBalance: $statementBalance, minimumPaymentDue: $minimumPaymentDue)';
}


}

/// @nodoc
abstract mixin class _$CreditCardDetailsCopyWith<$Res> implements $CreditCardDetailsCopyWith<$Res> {
  factory _$CreditCardDetailsCopyWith(_CreditCardDetails value, $Res Function(_CreditCardDetails) _then) = __$CreditCardDetailsCopyWithImpl;
@override @useResult
$Res call({
 String accountId,@AmountConverter() String creditLimit, int statementDay, int paymentDueDay,@AmountConverter() String minimumPaymentPercent,@AmountConverter() String currentOutstanding,@AmountConverter() String availableCredit,@AmountConverter() String utilization,@AmountConverter() String statementBalance,@AmountConverter() String minimumPaymentDue
});




}
/// @nodoc
class __$CreditCardDetailsCopyWithImpl<$Res>
    implements _$CreditCardDetailsCopyWith<$Res> {
  __$CreditCardDetailsCopyWithImpl(this._self, this._then);

  final _CreditCardDetails _self;
  final $Res Function(_CreditCardDetails) _then;

/// Create a copy of CreditCardDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? creditLimit = null,Object? statementDay = null,Object? paymentDueDay = null,Object? minimumPaymentPercent = null,Object? currentOutstanding = null,Object? availableCredit = null,Object? utilization = null,Object? statementBalance = null,Object? minimumPaymentDue = null,}) {
  return _then(_CreditCardDetails(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,creditLimit: null == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as String,statementDay: null == statementDay ? _self.statementDay : statementDay // ignore: cast_nullable_to_non_nullable
as int,paymentDueDay: null == paymentDueDay ? _self.paymentDueDay : paymentDueDay // ignore: cast_nullable_to_non_nullable
as int,minimumPaymentPercent: null == minimumPaymentPercent ? _self.minimumPaymentPercent : minimumPaymentPercent // ignore: cast_nullable_to_non_nullable
as String,currentOutstanding: null == currentOutstanding ? _self.currentOutstanding : currentOutstanding // ignore: cast_nullable_to_non_nullable
as String,availableCredit: null == availableCredit ? _self.availableCredit : availableCredit // ignore: cast_nullable_to_non_nullable
as String,utilization: null == utilization ? _self.utilization : utilization // ignore: cast_nullable_to_non_nullable
as String,statementBalance: null == statementBalance ? _self.statementBalance : statementBalance // ignore: cast_nullable_to_non_nullable
as String,minimumPaymentDue: null == minimumPaymentDue ? _self.minimumPaymentDue : minimumPaymentDue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
