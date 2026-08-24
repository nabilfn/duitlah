// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationRule {

 NotificationRuleType get type; bool get enabled;/// Only meaningful for [NotificationRuleType.LOW_BALANCE] — the balance
/// below which the alert fires. Null for every other type.
@NullableAmountConverter() String? get thresholdAmount;
/// Create a copy of NotificationRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationRuleCopyWith<NotificationRule> get copyWith => _$NotificationRuleCopyWithImpl<NotificationRule>(this as NotificationRule, _$identity);

  /// Serializes this NotificationRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationRule&&(identical(other.type, type) || other.type == type)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.thresholdAmount, thresholdAmount) || other.thresholdAmount == thresholdAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,enabled,thresholdAmount);

@override
String toString() {
  return 'NotificationRule(type: $type, enabled: $enabled, thresholdAmount: $thresholdAmount)';
}


}

/// @nodoc
abstract mixin class $NotificationRuleCopyWith<$Res>  {
  factory $NotificationRuleCopyWith(NotificationRule value, $Res Function(NotificationRule) _then) = _$NotificationRuleCopyWithImpl;
@useResult
$Res call({
 NotificationRuleType type, bool enabled,@NullableAmountConverter() String? thresholdAmount
});




}
/// @nodoc
class _$NotificationRuleCopyWithImpl<$Res>
    implements $NotificationRuleCopyWith<$Res> {
  _$NotificationRuleCopyWithImpl(this._self, this._then);

  final NotificationRule _self;
  final $Res Function(NotificationRule) _then;

/// Create a copy of NotificationRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? enabled = null,Object? thresholdAmount = freezed,}) {
  return _then(NotificationRule(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationRuleType,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,thresholdAmount: freezed == thresholdAmount ? _self.thresholdAmount : thresholdAmount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationRule].
extension NotificationRulePatterns on NotificationRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationRule value)  $default,){
final _that = this;
switch (_that) {
case _NotificationRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationRule value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationRuleType type,  bool enabled, @NullableAmountConverter()  String? thresholdAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationRule() when $default != null:
return $default(_that.type,_that.enabled,_that.thresholdAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationRuleType type,  bool enabled, @NullableAmountConverter()  String? thresholdAmount)  $default,) {final _that = this;
switch (_that) {
case _NotificationRule():
return $default(_that.type,_that.enabled,_that.thresholdAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationRuleType type,  bool enabled, @NullableAmountConverter()  String? thresholdAmount)?  $default,) {final _that = this;
switch (_that) {
case _NotificationRule() when $default != null:
return $default(_that.type,_that.enabled,_that.thresholdAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationRule implements NotificationRule {
  const _NotificationRule({required this.type, required this.enabled, @NullableAmountConverter() this.thresholdAmount});
  factory _NotificationRule.fromJson(Map<String, dynamic> json) => _$NotificationRuleFromJson(json);

@override final  NotificationRuleType type;
@override final  bool enabled;
/// Only meaningful for [NotificationRuleType.LOW_BALANCE] — the balance
/// below which the alert fires. Null for every other type.
@override@NullableAmountConverter() final  String? thresholdAmount;

/// Create a copy of NotificationRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationRuleCopyWith<_NotificationRule> get copyWith => __$NotificationRuleCopyWithImpl<_NotificationRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationRule&&(identical(other.type, type) || other.type == type)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.thresholdAmount, thresholdAmount) || other.thresholdAmount == thresholdAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,enabled,thresholdAmount);

@override
String toString() {
  return 'NotificationRule(type: $type, enabled: $enabled, thresholdAmount: $thresholdAmount)';
}


}

/// @nodoc
abstract mixin class _$NotificationRuleCopyWith<$Res> implements $NotificationRuleCopyWith<$Res> {
  factory _$NotificationRuleCopyWith(_NotificationRule value, $Res Function(_NotificationRule) _then) = __$NotificationRuleCopyWithImpl;
@override @useResult
$Res call({
 NotificationRuleType type, bool enabled,@NullableAmountConverter() String? thresholdAmount
});




}
/// @nodoc
class __$NotificationRuleCopyWithImpl<$Res>
    implements _$NotificationRuleCopyWith<$Res> {
  __$NotificationRuleCopyWithImpl(this._self, this._then);

  final _NotificationRule _self;
  final $Res Function(_NotificationRule) _then;

/// Create a copy of NotificationRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? enabled = null,Object? thresholdAmount = freezed,}) {
  return _then(_NotificationRule(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationRuleType,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,thresholdAmount: freezed == thresholdAmount ? _self.thresholdAmount : thresholdAmount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
