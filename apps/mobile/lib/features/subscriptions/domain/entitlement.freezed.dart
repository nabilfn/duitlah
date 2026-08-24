// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entitlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Entitlement {

 SubscriptionTier get tier; SubscriptionStatus? get status; String? get expiresAt; int? get maxActiveGroups; int get activeGroupCount; int? get maxReceiptScansPerMonth; int get receiptScansThisMonth;
/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementCopyWith<Entitlement> get copyWith => _$EntitlementCopyWithImpl<Entitlement>(this as Entitlement, _$identity);

  /// Serializes this Entitlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entitlement&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.maxActiveGroups, maxActiveGroups) || other.maxActiveGroups == maxActiveGroups)&&(identical(other.activeGroupCount, activeGroupCount) || other.activeGroupCount == activeGroupCount)&&(identical(other.maxReceiptScansPerMonth, maxReceiptScansPerMonth) || other.maxReceiptScansPerMonth == maxReceiptScansPerMonth)&&(identical(other.receiptScansThisMonth, receiptScansThisMonth) || other.receiptScansThisMonth == receiptScansThisMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tier,status,expiresAt,maxActiveGroups,activeGroupCount,maxReceiptScansPerMonth,receiptScansThisMonth);

@override
String toString() {
  return 'Entitlement(tier: $tier, status: $status, expiresAt: $expiresAt, maxActiveGroups: $maxActiveGroups, activeGroupCount: $activeGroupCount, maxReceiptScansPerMonth: $maxReceiptScansPerMonth, receiptScansThisMonth: $receiptScansThisMonth)';
}


}

/// @nodoc
abstract mixin class $EntitlementCopyWith<$Res>  {
  factory $EntitlementCopyWith(Entitlement value, $Res Function(Entitlement) _then) = _$EntitlementCopyWithImpl;
@useResult
$Res call({
 SubscriptionTier tier, SubscriptionStatus? status, String? expiresAt, int? maxActiveGroups, int activeGroupCount, int? maxReceiptScansPerMonth, int receiptScansThisMonth
});




}
/// @nodoc
class _$EntitlementCopyWithImpl<$Res>
    implements $EntitlementCopyWith<$Res> {
  _$EntitlementCopyWithImpl(this._self, this._then);

  final Entitlement _self;
  final $Res Function(Entitlement) _then;

/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = null,Object? status = freezed,Object? expiresAt = freezed,Object? maxActiveGroups = freezed,Object? activeGroupCount = null,Object? maxReceiptScansPerMonth = freezed,Object? receiptScansThisMonth = null,}) {
  return _then(Entitlement(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as SubscriptionTier,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,maxActiveGroups: freezed == maxActiveGroups ? _self.maxActiveGroups : maxActiveGroups // ignore: cast_nullable_to_non_nullable
as int?,activeGroupCount: null == activeGroupCount ? _self.activeGroupCount : activeGroupCount // ignore: cast_nullable_to_non_nullable
as int,maxReceiptScansPerMonth: freezed == maxReceiptScansPerMonth ? _self.maxReceiptScansPerMonth : maxReceiptScansPerMonth // ignore: cast_nullable_to_non_nullable
as int?,receiptScansThisMonth: null == receiptScansThisMonth ? _self.receiptScansThisMonth : receiptScansThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Entitlement].
extension EntitlementPatterns on Entitlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entitlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entitlement value)  $default,){
final _that = this;
switch (_that) {
case _Entitlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entitlement value)?  $default,){
final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubscriptionTier tier,  SubscriptionStatus? status,  String? expiresAt,  int? maxActiveGroups,  int activeGroupCount,  int? maxReceiptScansPerMonth,  int receiptScansThisMonth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
return $default(_that.tier,_that.status,_that.expiresAt,_that.maxActiveGroups,_that.activeGroupCount,_that.maxReceiptScansPerMonth,_that.receiptScansThisMonth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubscriptionTier tier,  SubscriptionStatus? status,  String? expiresAt,  int? maxActiveGroups,  int activeGroupCount,  int? maxReceiptScansPerMonth,  int receiptScansThisMonth)  $default,) {final _that = this;
switch (_that) {
case _Entitlement():
return $default(_that.tier,_that.status,_that.expiresAt,_that.maxActiveGroups,_that.activeGroupCount,_that.maxReceiptScansPerMonth,_that.receiptScansThisMonth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubscriptionTier tier,  SubscriptionStatus? status,  String? expiresAt,  int? maxActiveGroups,  int activeGroupCount,  int? maxReceiptScansPerMonth,  int receiptScansThisMonth)?  $default,) {final _that = this;
switch (_that) {
case _Entitlement() when $default != null:
return $default(_that.tier,_that.status,_that.expiresAt,_that.maxActiveGroups,_that.activeGroupCount,_that.maxReceiptScansPerMonth,_that.receiptScansThisMonth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Entitlement implements Entitlement {
  const _Entitlement({required this.tier, this.status, this.expiresAt, this.maxActiveGroups, required this.activeGroupCount, this.maxReceiptScansPerMonth, required this.receiptScansThisMonth});
  factory _Entitlement.fromJson(Map<String, dynamic> json) => _$EntitlementFromJson(json);

@override final  SubscriptionTier tier;
@override final  SubscriptionStatus? status;
@override final  String? expiresAt;
@override final  int? maxActiveGroups;
@override final  int activeGroupCount;
@override final  int? maxReceiptScansPerMonth;
@override final  int receiptScansThisMonth;

/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementCopyWith<_Entitlement> get copyWith => __$EntitlementCopyWithImpl<_Entitlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entitlement&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.maxActiveGroups, maxActiveGroups) || other.maxActiveGroups == maxActiveGroups)&&(identical(other.activeGroupCount, activeGroupCount) || other.activeGroupCount == activeGroupCount)&&(identical(other.maxReceiptScansPerMonth, maxReceiptScansPerMonth) || other.maxReceiptScansPerMonth == maxReceiptScansPerMonth)&&(identical(other.receiptScansThisMonth, receiptScansThisMonth) || other.receiptScansThisMonth == receiptScansThisMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tier,status,expiresAt,maxActiveGroups,activeGroupCount,maxReceiptScansPerMonth,receiptScansThisMonth);

@override
String toString() {
  return 'Entitlement(tier: $tier, status: $status, expiresAt: $expiresAt, maxActiveGroups: $maxActiveGroups, activeGroupCount: $activeGroupCount, maxReceiptScansPerMonth: $maxReceiptScansPerMonth, receiptScansThisMonth: $receiptScansThisMonth)';
}


}

/// @nodoc
abstract mixin class _$EntitlementCopyWith<$Res> implements $EntitlementCopyWith<$Res> {
  factory _$EntitlementCopyWith(_Entitlement value, $Res Function(_Entitlement) _then) = __$EntitlementCopyWithImpl;
@override @useResult
$Res call({
 SubscriptionTier tier, SubscriptionStatus? status, String? expiresAt, int? maxActiveGroups, int activeGroupCount, int? maxReceiptScansPerMonth, int receiptScansThisMonth
});




}
/// @nodoc
class __$EntitlementCopyWithImpl<$Res>
    implements _$EntitlementCopyWith<$Res> {
  __$EntitlementCopyWithImpl(this._self, this._then);

  final _Entitlement _self;
  final $Res Function(_Entitlement) _then;

/// Create a copy of Entitlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = null,Object? status = freezed,Object? expiresAt = freezed,Object? maxActiveGroups = freezed,Object? activeGroupCount = null,Object? maxReceiptScansPerMonth = freezed,Object? receiptScansThisMonth = null,}) {
  return _then(_Entitlement(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as SubscriptionTier,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,maxActiveGroups: freezed == maxActiveGroups ? _self.maxActiveGroups : maxActiveGroups // ignore: cast_nullable_to_non_nullable
as int?,activeGroupCount: null == activeGroupCount ? _self.activeGroupCount : activeGroupCount // ignore: cast_nullable_to_non_nullable
as int,maxReceiptScansPerMonth: freezed == maxReceiptScansPerMonth ? _self.maxReceiptScansPerMonth : maxReceiptScansPerMonth // ignore: cast_nullable_to_non_nullable
as int?,receiptScansThisMonth: null == receiptScansThisMonth ? _self.receiptScansThisMonth : receiptScansThisMonth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
