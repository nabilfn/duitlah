// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_tax.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SstRate {

 TaxType get taxType;@AmountConverter() String get ratePercent; String get effectiveFrom; String? get effectiveTo; String? get description;
/// Create a copy of SstRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SstRateCopyWith<SstRate> get copyWith => _$SstRateCopyWithImpl<SstRate>(this as SstRate, _$identity);

  /// Serializes this SstRate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SstRate&&(identical(other.taxType, taxType) || other.taxType == taxType)&&(identical(other.ratePercent, ratePercent) || other.ratePercent == ratePercent)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taxType,ratePercent,effectiveFrom,effectiveTo,description);

@override
String toString() {
  return 'SstRate(taxType: $taxType, ratePercent: $ratePercent, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, description: $description)';
}


}

/// @nodoc
abstract mixin class $SstRateCopyWith<$Res>  {
  factory $SstRateCopyWith(SstRate value, $Res Function(SstRate) _then) = _$SstRateCopyWithImpl;
@useResult
$Res call({
 TaxType taxType,@AmountConverter() String ratePercent, String effectiveFrom, String? effectiveTo, String? description
});




}
/// @nodoc
class _$SstRateCopyWithImpl<$Res>
    implements $SstRateCopyWith<$Res> {
  _$SstRateCopyWithImpl(this._self, this._then);

  final SstRate _self;
  final $Res Function(SstRate) _then;

/// Create a copy of SstRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taxType = null,Object? ratePercent = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? description = freezed,}) {
  return _then(SstRate(
taxType: null == taxType ? _self.taxType : taxType // ignore: cast_nullable_to_non_nullable
as TaxType,ratePercent: null == ratePercent ? _self.ratePercent : ratePercent // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as String,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SstRate].
extension SstRatePatterns on SstRate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SstRate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SstRate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SstRate value)  $default,){
final _that = this;
switch (_that) {
case _SstRate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SstRate value)?  $default,){
final _that = this;
switch (_that) {
case _SstRate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaxType taxType, @AmountConverter()  String ratePercent,  String effectiveFrom,  String? effectiveTo,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SstRate() when $default != null:
return $default(_that.taxType,_that.ratePercent,_that.effectiveFrom,_that.effectiveTo,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaxType taxType, @AmountConverter()  String ratePercent,  String effectiveFrom,  String? effectiveTo,  String? description)  $default,) {final _that = this;
switch (_that) {
case _SstRate():
return $default(_that.taxType,_that.ratePercent,_that.effectiveFrom,_that.effectiveTo,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaxType taxType, @AmountConverter()  String ratePercent,  String effectiveFrom,  String? effectiveTo,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _SstRate() when $default != null:
return $default(_that.taxType,_that.ratePercent,_that.effectiveFrom,_that.effectiveTo,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SstRate implements SstRate {
  const _SstRate({required this.taxType, @AmountConverter() required this.ratePercent, required this.effectiveFrom, this.effectiveTo, this.description});
  factory _SstRate.fromJson(Map<String, dynamic> json) => _$SstRateFromJson(json);

@override final  TaxType taxType;
@override@AmountConverter() final  String ratePercent;
@override final  String effectiveFrom;
@override final  String? effectiveTo;
@override final  String? description;

/// Create a copy of SstRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SstRateCopyWith<_SstRate> get copyWith => __$SstRateCopyWithImpl<_SstRate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SstRateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SstRate&&(identical(other.taxType, taxType) || other.taxType == taxType)&&(identical(other.ratePercent, ratePercent) || other.ratePercent == ratePercent)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taxType,ratePercent,effectiveFrom,effectiveTo,description);

@override
String toString() {
  return 'SstRate(taxType: $taxType, ratePercent: $ratePercent, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, description: $description)';
}


}

/// @nodoc
abstract mixin class _$SstRateCopyWith<$Res> implements $SstRateCopyWith<$Res> {
  factory _$SstRateCopyWith(_SstRate value, $Res Function(_SstRate) _then) = __$SstRateCopyWithImpl;
@override @useResult
$Res call({
 TaxType taxType,@AmountConverter() String ratePercent, String effectiveFrom, String? effectiveTo, String? description
});




}
/// @nodoc
class __$SstRateCopyWithImpl<$Res>
    implements _$SstRateCopyWith<$Res> {
  __$SstRateCopyWithImpl(this._self, this._then);

  final _SstRate _self;
  final $Res Function(_SstRate) _then;

/// Create a copy of SstRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taxType = null,Object? ratePercent = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? description = freezed,}) {
  return _then(_SstRate(
taxType: null == taxType ? _self.taxType : taxType // ignore: cast_nullable_to_non_nullable
as TaxType,ratePercent: null == ratePercent ? _self.ratePercent : ratePercent // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as String,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SstReport {

 String get from; String get to;@AmountConverter() String get collectedTax;@AmountConverter() String get payableTax;
/// Create a copy of SstReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SstReportCopyWith<SstReport> get copyWith => _$SstReportCopyWithImpl<SstReport>(this as SstReport, _$identity);

  /// Serializes this SstReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SstReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.collectedTax, collectedTax) || other.collectedTax == collectedTax)&&(identical(other.payableTax, payableTax) || other.payableTax == payableTax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,collectedTax,payableTax);

@override
String toString() {
  return 'SstReport(from: $from, to: $to, collectedTax: $collectedTax, payableTax: $payableTax)';
}


}

/// @nodoc
abstract mixin class $SstReportCopyWith<$Res>  {
  factory $SstReportCopyWith(SstReport value, $Res Function(SstReport) _then) = _$SstReportCopyWithImpl;
@useResult
$Res call({
 String from, String to,@AmountConverter() String collectedTax,@AmountConverter() String payableTax
});




}
/// @nodoc
class _$SstReportCopyWithImpl<$Res>
    implements $SstReportCopyWith<$Res> {
  _$SstReportCopyWithImpl(this._self, this._then);

  final SstReport _self;
  final $Res Function(SstReport) _then;

/// Create a copy of SstReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? collectedTax = null,Object? payableTax = null,}) {
  return _then(SstReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,collectedTax: null == collectedTax ? _self.collectedTax : collectedTax // ignore: cast_nullable_to_non_nullable
as String,payableTax: null == payableTax ? _self.payableTax : payableTax // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SstReport].
extension SstReportPatterns on SstReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SstReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SstReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SstReport value)  $default,){
final _that = this;
switch (_that) {
case _SstReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SstReport value)?  $default,){
final _that = this;
switch (_that) {
case _SstReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to, @AmountConverter()  String collectedTax, @AmountConverter()  String payableTax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SstReport() when $default != null:
return $default(_that.from,_that.to,_that.collectedTax,_that.payableTax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to, @AmountConverter()  String collectedTax, @AmountConverter()  String payableTax)  $default,) {final _that = this;
switch (_that) {
case _SstReport():
return $default(_that.from,_that.to,_that.collectedTax,_that.payableTax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to, @AmountConverter()  String collectedTax, @AmountConverter()  String payableTax)?  $default,) {final _that = this;
switch (_that) {
case _SstReport() when $default != null:
return $default(_that.from,_that.to,_that.collectedTax,_that.payableTax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SstReport implements SstReport {
  const _SstReport({required this.from, required this.to, @AmountConverter() required this.collectedTax, @AmountConverter() required this.payableTax});
  factory _SstReport.fromJson(Map<String, dynamic> json) => _$SstReportFromJson(json);

@override final  String from;
@override final  String to;
@override@AmountConverter() final  String collectedTax;
@override@AmountConverter() final  String payableTax;

/// Create a copy of SstReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SstReportCopyWith<_SstReport> get copyWith => __$SstReportCopyWithImpl<_SstReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SstReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SstReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.collectedTax, collectedTax) || other.collectedTax == collectedTax)&&(identical(other.payableTax, payableTax) || other.payableTax == payableTax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,collectedTax,payableTax);

@override
String toString() {
  return 'SstReport(from: $from, to: $to, collectedTax: $collectedTax, payableTax: $payableTax)';
}


}

/// @nodoc
abstract mixin class _$SstReportCopyWith<$Res> implements $SstReportCopyWith<$Res> {
  factory _$SstReportCopyWith(_SstReport value, $Res Function(_SstReport) _then) = __$SstReportCopyWithImpl;
@override @useResult
$Res call({
 String from, String to,@AmountConverter() String collectedTax,@AmountConverter() String payableTax
});




}
/// @nodoc
class __$SstReportCopyWithImpl<$Res>
    implements _$SstReportCopyWith<$Res> {
  __$SstReportCopyWithImpl(this._self, this._then);

  final _SstReport _self;
  final $Res Function(_SstReport) _then;

/// Create a copy of SstReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? collectedTax = null,Object? payableTax = null,}) {
  return _then(_SstReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,collectedTax: null == collectedTax ? _self.collectedTax : collectedTax // ignore: cast_nullable_to_non_nullable
as String,payableTax: null == payableTax ? _self.payableTax : payableTax // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$EInvoiceReadiness {

 bool get mandated; String? get currentRuleEffectiveDate;@NullableAmountConverter() String? get currentRuleThreshold; List<String> get missingFields; bool get ready;
/// Create a copy of EInvoiceReadiness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EInvoiceReadinessCopyWith<EInvoiceReadiness> get copyWith => _$EInvoiceReadinessCopyWithImpl<EInvoiceReadiness>(this as EInvoiceReadiness, _$identity);

  /// Serializes this EInvoiceReadiness to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EInvoiceReadiness&&(identical(other.mandated, mandated) || other.mandated == mandated)&&(identical(other.currentRuleEffectiveDate, currentRuleEffectiveDate) || other.currentRuleEffectiveDate == currentRuleEffectiveDate)&&(identical(other.currentRuleThreshold, currentRuleThreshold) || other.currentRuleThreshold == currentRuleThreshold)&&const DeepCollectionEquality().equals(other.missingFields, missingFields)&&(identical(other.ready, ready) || other.ready == ready));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mandated,currentRuleEffectiveDate,currentRuleThreshold,const DeepCollectionEquality().hash(missingFields),ready);

@override
String toString() {
  return 'EInvoiceReadiness(mandated: $mandated, currentRuleEffectiveDate: $currentRuleEffectiveDate, currentRuleThreshold: $currentRuleThreshold, missingFields: $missingFields, ready: $ready)';
}


}

/// @nodoc
abstract mixin class $EInvoiceReadinessCopyWith<$Res>  {
  factory $EInvoiceReadinessCopyWith(EInvoiceReadiness value, $Res Function(EInvoiceReadiness) _then) = _$EInvoiceReadinessCopyWithImpl;
@useResult
$Res call({
 bool mandated, String? currentRuleEffectiveDate,@NullableAmountConverter() String? currentRuleThreshold, List<String> missingFields, bool ready
});




}
/// @nodoc
class _$EInvoiceReadinessCopyWithImpl<$Res>
    implements $EInvoiceReadinessCopyWith<$Res> {
  _$EInvoiceReadinessCopyWithImpl(this._self, this._then);

  final EInvoiceReadiness _self;
  final $Res Function(EInvoiceReadiness) _then;

/// Create a copy of EInvoiceReadiness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mandated = null,Object? currentRuleEffectiveDate = freezed,Object? currentRuleThreshold = freezed,Object? missingFields = null,Object? ready = null,}) {
  return _then(EInvoiceReadiness(
mandated: null == mandated ? _self.mandated : mandated // ignore: cast_nullable_to_non_nullable
as bool,currentRuleEffectiveDate: freezed == currentRuleEffectiveDate ? _self.currentRuleEffectiveDate : currentRuleEffectiveDate // ignore: cast_nullable_to_non_nullable
as String?,currentRuleThreshold: freezed == currentRuleThreshold ? _self.currentRuleThreshold : currentRuleThreshold // ignore: cast_nullable_to_non_nullable
as String?,missingFields: null == missingFields ? _self.missingFields : missingFields // ignore: cast_nullable_to_non_nullable
as List<String>,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EInvoiceReadiness].
extension EInvoiceReadinessPatterns on EInvoiceReadiness {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EInvoiceReadiness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EInvoiceReadiness() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EInvoiceReadiness value)  $default,){
final _that = this;
switch (_that) {
case _EInvoiceReadiness():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EInvoiceReadiness value)?  $default,){
final _that = this;
switch (_that) {
case _EInvoiceReadiness() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool mandated,  String? currentRuleEffectiveDate, @NullableAmountConverter()  String? currentRuleThreshold,  List<String> missingFields,  bool ready)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EInvoiceReadiness() when $default != null:
return $default(_that.mandated,_that.currentRuleEffectiveDate,_that.currentRuleThreshold,_that.missingFields,_that.ready);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool mandated,  String? currentRuleEffectiveDate, @NullableAmountConverter()  String? currentRuleThreshold,  List<String> missingFields,  bool ready)  $default,) {final _that = this;
switch (_that) {
case _EInvoiceReadiness():
return $default(_that.mandated,_that.currentRuleEffectiveDate,_that.currentRuleThreshold,_that.missingFields,_that.ready);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool mandated,  String? currentRuleEffectiveDate, @NullableAmountConverter()  String? currentRuleThreshold,  List<String> missingFields,  bool ready)?  $default,) {final _that = this;
switch (_that) {
case _EInvoiceReadiness() when $default != null:
return $default(_that.mandated,_that.currentRuleEffectiveDate,_that.currentRuleThreshold,_that.missingFields,_that.ready);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EInvoiceReadiness implements EInvoiceReadiness {
  const _EInvoiceReadiness({required this.mandated, this.currentRuleEffectiveDate, @NullableAmountConverter() this.currentRuleThreshold, required  List<String> missingFields, required this.ready}): _missingFields = missingFields;
  factory _EInvoiceReadiness.fromJson(Map<String, dynamic> json) => _$EInvoiceReadinessFromJson(json);

@override final  bool mandated;
@override final  String? currentRuleEffectiveDate;
@override@NullableAmountConverter() final  String? currentRuleThreshold;
 final  List<String> _missingFields;
@override List<String> get missingFields {
  if (_missingFields is EqualUnmodifiableListView) return _missingFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingFields);
}

@override final  bool ready;

/// Create a copy of EInvoiceReadiness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EInvoiceReadinessCopyWith<_EInvoiceReadiness> get copyWith => __$EInvoiceReadinessCopyWithImpl<_EInvoiceReadiness>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EInvoiceReadinessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EInvoiceReadiness&&(identical(other.mandated, mandated) || other.mandated == mandated)&&(identical(other.currentRuleEffectiveDate, currentRuleEffectiveDate) || other.currentRuleEffectiveDate == currentRuleEffectiveDate)&&(identical(other.currentRuleThreshold, currentRuleThreshold) || other.currentRuleThreshold == currentRuleThreshold)&&const DeepCollectionEquality().equals(other._missingFields, _missingFields)&&(identical(other.ready, ready) || other.ready == ready));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mandated,currentRuleEffectiveDate,currentRuleThreshold,const DeepCollectionEquality().hash(_missingFields),ready);

@override
String toString() {
  return 'EInvoiceReadiness(mandated: $mandated, currentRuleEffectiveDate: $currentRuleEffectiveDate, currentRuleThreshold: $currentRuleThreshold, missingFields: $missingFields, ready: $ready)';
}


}

/// @nodoc
abstract mixin class _$EInvoiceReadinessCopyWith<$Res> implements $EInvoiceReadinessCopyWith<$Res> {
  factory _$EInvoiceReadinessCopyWith(_EInvoiceReadiness value, $Res Function(_EInvoiceReadiness) _then) = __$EInvoiceReadinessCopyWithImpl;
@override @useResult
$Res call({
 bool mandated, String? currentRuleEffectiveDate,@NullableAmountConverter() String? currentRuleThreshold, List<String> missingFields, bool ready
});




}
/// @nodoc
class __$EInvoiceReadinessCopyWithImpl<$Res>
    implements _$EInvoiceReadinessCopyWith<$Res> {
  __$EInvoiceReadinessCopyWithImpl(this._self, this._then);

  final _EInvoiceReadiness _self;
  final $Res Function(_EInvoiceReadiness) _then;

/// Create a copy of EInvoiceReadiness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mandated = null,Object? currentRuleEffectiveDate = freezed,Object? currentRuleThreshold = freezed,Object? missingFields = null,Object? ready = null,}) {
  return _then(_EInvoiceReadiness(
mandated: null == mandated ? _self.mandated : mandated // ignore: cast_nullable_to_non_nullable
as bool,currentRuleEffectiveDate: freezed == currentRuleEffectiveDate ? _self.currentRuleEffectiveDate : currentRuleEffectiveDate // ignore: cast_nullable_to_non_nullable
as String?,currentRuleThreshold: freezed == currentRuleThreshold ? _self.currentRuleThreshold : currentRuleThreshold // ignore: cast_nullable_to_non_nullable
as String?,missingFields: null == missingFields ? _self._missingFields : missingFields // ignore: cast_nullable_to_non_nullable
as List<String>,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
