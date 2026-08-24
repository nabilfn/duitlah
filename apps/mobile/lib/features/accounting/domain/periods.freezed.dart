// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'periods.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountingPeriod {

 String get id; String get periodStart; String get periodEnd; AccountingPeriodStatus get status;
/// Create a copy of AccountingPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingPeriodCopyWith<AccountingPeriod> get copyWith => _$AccountingPeriodCopyWithImpl<AccountingPeriod>(this as AccountingPeriod, _$identity);

  /// Serializes this AccountingPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodStart,periodEnd,status);

@override
String toString() {
  return 'AccountingPeriod(id: $id, periodStart: $periodStart, periodEnd: $periodEnd, status: $status)';
}


}

/// @nodoc
abstract mixin class $AccountingPeriodCopyWith<$Res>  {
  factory $AccountingPeriodCopyWith(AccountingPeriod value, $Res Function(AccountingPeriod) _then) = _$AccountingPeriodCopyWithImpl;
@useResult
$Res call({
 String id, String periodStart, String periodEnd, AccountingPeriodStatus status
});




}
/// @nodoc
class _$AccountingPeriodCopyWithImpl<$Res>
    implements $AccountingPeriodCopyWith<$Res> {
  _$AccountingPeriodCopyWithImpl(this._self, this._then);

  final AccountingPeriod _self;
  final $Res Function(AccountingPeriod) _then;

/// Create a copy of AccountingPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? periodStart = null,Object? periodEnd = null,Object? status = null,}) {
  return _then(AccountingPeriod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as String,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountingPeriodStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingPeriod].
extension AccountingPeriodPatterns on AccountingPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingPeriod value)  $default,){
final _that = this;
switch (_that) {
case _AccountingPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String periodStart,  String periodEnd,  AccountingPeriodStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingPeriod() when $default != null:
return $default(_that.id,_that.periodStart,_that.periodEnd,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String periodStart,  String periodEnd,  AccountingPeriodStatus status)  $default,) {final _that = this;
switch (_that) {
case _AccountingPeriod():
return $default(_that.id,_that.periodStart,_that.periodEnd,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String periodStart,  String periodEnd,  AccountingPeriodStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AccountingPeriod() when $default != null:
return $default(_that.id,_that.periodStart,_that.periodEnd,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountingPeriod implements AccountingPeriod {
  const _AccountingPeriod({required this.id, required this.periodStart, required this.periodEnd, required this.status});
  factory _AccountingPeriod.fromJson(Map<String, dynamic> json) => _$AccountingPeriodFromJson(json);

@override final  String id;
@override final  String periodStart;
@override final  String periodEnd;
@override final  AccountingPeriodStatus status;

/// Create a copy of AccountingPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingPeriodCopyWith<_AccountingPeriod> get copyWith => __$AccountingPeriodCopyWithImpl<_AccountingPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountingPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodStart,periodEnd,status);

@override
String toString() {
  return 'AccountingPeriod(id: $id, periodStart: $periodStart, periodEnd: $periodEnd, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AccountingPeriodCopyWith<$Res> implements $AccountingPeriodCopyWith<$Res> {
  factory _$AccountingPeriodCopyWith(_AccountingPeriod value, $Res Function(_AccountingPeriod) _then) = __$AccountingPeriodCopyWithImpl;
@override @useResult
$Res call({
 String id, String periodStart, String periodEnd, AccountingPeriodStatus status
});




}
/// @nodoc
class __$AccountingPeriodCopyWithImpl<$Res>
    implements _$AccountingPeriodCopyWith<$Res> {
  __$AccountingPeriodCopyWithImpl(this._self, this._then);

  final _AccountingPeriod _self;
  final $Res Function(_AccountingPeriod) _then;

/// Create a copy of AccountingPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? periodStart = null,Object? periodEnd = null,Object? status = null,}) {
  return _then(_AccountingPeriod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as String,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountingPeriodStatus,
  ));
}


}

// dart format on
