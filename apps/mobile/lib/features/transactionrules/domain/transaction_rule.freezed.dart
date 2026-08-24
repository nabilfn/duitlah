// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionRule {

 String get id; MatchType get matchType; String get matchValue; String get categoryId; int get priority; bool get active;/// True when the backend auto-created this rule itself
/// (`TransactionRuleService.learnFromConfirmation`, upserted every time a candidate at this
/// merchant is confirmed with a category) rather than the user authoring it directly — still
/// exactly as editable/deletable as a hand-written rule, just labeled differently in the UI.
 bool get learned;
/// Create a copy of TransactionRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionRuleCopyWith<TransactionRule> get copyWith => _$TransactionRuleCopyWithImpl<TransactionRule>(this as TransactionRule, _$identity);

  /// Serializes this TransactionRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionRule&&(identical(other.id, id) || other.id == id)&&(identical(other.matchType, matchType) || other.matchType == matchType)&&(identical(other.matchValue, matchValue) || other.matchValue == matchValue)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.active, active) || other.active == active)&&(identical(other.learned, learned) || other.learned == learned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,matchType,matchValue,categoryId,priority,active,learned);

@override
String toString() {
  return 'TransactionRule(id: $id, matchType: $matchType, matchValue: $matchValue, categoryId: $categoryId, priority: $priority, active: $active, learned: $learned)';
}


}

/// @nodoc
abstract mixin class $TransactionRuleCopyWith<$Res>  {
  factory $TransactionRuleCopyWith(TransactionRule value, $Res Function(TransactionRule) _then) = _$TransactionRuleCopyWithImpl;
@useResult
$Res call({
 String id, MatchType matchType, String matchValue, String categoryId, int priority, bool active, bool learned
});




}
/// @nodoc
class _$TransactionRuleCopyWithImpl<$Res>
    implements $TransactionRuleCopyWith<$Res> {
  _$TransactionRuleCopyWithImpl(this._self, this._then);

  final TransactionRule _self;
  final $Res Function(TransactionRule) _then;

/// Create a copy of TransactionRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? matchType = null,Object? matchValue = null,Object? categoryId = null,Object? priority = null,Object? active = null,Object? learned = null,}) {
  return _then(TransactionRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matchType: null == matchType ? _self.matchType : matchType // ignore: cast_nullable_to_non_nullable
as MatchType,matchValue: null == matchValue ? _self.matchValue : matchValue // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,learned: null == learned ? _self.learned : learned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionRule].
extension TransactionRulePatterns on TransactionRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionRule value)  $default,){
final _that = this;
switch (_that) {
case _TransactionRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionRule value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MatchType matchType,  String matchValue,  String categoryId,  int priority,  bool active,  bool learned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionRule() when $default != null:
return $default(_that.id,_that.matchType,_that.matchValue,_that.categoryId,_that.priority,_that.active,_that.learned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MatchType matchType,  String matchValue,  String categoryId,  int priority,  bool active,  bool learned)  $default,) {final _that = this;
switch (_that) {
case _TransactionRule():
return $default(_that.id,_that.matchType,_that.matchValue,_that.categoryId,_that.priority,_that.active,_that.learned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MatchType matchType,  String matchValue,  String categoryId,  int priority,  bool active,  bool learned)?  $default,) {final _that = this;
switch (_that) {
case _TransactionRule() when $default != null:
return $default(_that.id,_that.matchType,_that.matchValue,_that.categoryId,_that.priority,_that.active,_that.learned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionRule implements TransactionRule {
  const _TransactionRule({required this.id, required this.matchType, required this.matchValue, required this.categoryId, required this.priority, required this.active, required this.learned});
  factory _TransactionRule.fromJson(Map<String, dynamic> json) => _$TransactionRuleFromJson(json);

@override final  String id;
@override final  MatchType matchType;
@override final  String matchValue;
@override final  String categoryId;
@override final  int priority;
@override final  bool active;
/// True when the backend auto-created this rule itself
/// (`TransactionRuleService.learnFromConfirmation`, upserted every time a candidate at this
/// merchant is confirmed with a category) rather than the user authoring it directly — still
/// exactly as editable/deletable as a hand-written rule, just labeled differently in the UI.
@override final  bool learned;

/// Create a copy of TransactionRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionRuleCopyWith<_TransactionRule> get copyWith => __$TransactionRuleCopyWithImpl<_TransactionRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionRule&&(identical(other.id, id) || other.id == id)&&(identical(other.matchType, matchType) || other.matchType == matchType)&&(identical(other.matchValue, matchValue) || other.matchValue == matchValue)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.active, active) || other.active == active)&&(identical(other.learned, learned) || other.learned == learned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,matchType,matchValue,categoryId,priority,active,learned);

@override
String toString() {
  return 'TransactionRule(id: $id, matchType: $matchType, matchValue: $matchValue, categoryId: $categoryId, priority: $priority, active: $active, learned: $learned)';
}


}

/// @nodoc
abstract mixin class _$TransactionRuleCopyWith<$Res> implements $TransactionRuleCopyWith<$Res> {
  factory _$TransactionRuleCopyWith(_TransactionRule value, $Res Function(_TransactionRule) _then) = __$TransactionRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, MatchType matchType, String matchValue, String categoryId, int priority, bool active, bool learned
});




}
/// @nodoc
class __$TransactionRuleCopyWithImpl<$Res>
    implements _$TransactionRuleCopyWith<$Res> {
  __$TransactionRuleCopyWithImpl(this._self, this._then);

  final _TransactionRule _self;
  final $Res Function(_TransactionRule) _then;

/// Create a copy of TransactionRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? matchType = null,Object? matchValue = null,Object? categoryId = null,Object? priority = null,Object? active = null,Object? learned = null,}) {
  return _then(_TransactionRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matchType: null == matchType ? _self.matchType : matchType // ignore: cast_nullable_to_non_nullable
as MatchType,matchValue: null == matchValue ? _self.matchValue : matchValue // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,learned: null == learned ? _self.learned : learned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
