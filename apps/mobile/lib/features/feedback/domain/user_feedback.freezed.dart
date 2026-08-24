// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserFeedback {

 String get id; FeedbackCategory get category; String get message; String get createdAt;
/// Create a copy of UserFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFeedbackCopyWith<UserFeedback> get copyWith => _$UserFeedbackCopyWithImpl<UserFeedback>(this as UserFeedback, _$identity);

  /// Serializes this UserFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,message,createdAt);

@override
String toString() {
  return 'UserFeedback(id: $id, category: $category, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserFeedbackCopyWith<$Res>  {
  factory $UserFeedbackCopyWith(UserFeedback value, $Res Function(UserFeedback) _then) = _$UserFeedbackCopyWithImpl;
@useResult
$Res call({
 String id, FeedbackCategory category, String message, String createdAt
});




}
/// @nodoc
class _$UserFeedbackCopyWithImpl<$Res>
    implements $UserFeedbackCopyWith<$Res> {
  _$UserFeedbackCopyWithImpl(this._self, this._then);

  final UserFeedback _self;
  final $Res Function(UserFeedback) _then;

/// Create a copy of UserFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? message = null,Object? createdAt = null,}) {
  return _then(UserFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeedbackCategory,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFeedback].
extension UserFeedbackPatterns on UserFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFeedback value)  $default,){
final _that = this;
switch (_that) {
case _UserFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _UserFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FeedbackCategory category,  String message,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFeedback() when $default != null:
return $default(_that.id,_that.category,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FeedbackCategory category,  String message,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserFeedback():
return $default(_that.id,_that.category,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FeedbackCategory category,  String message,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserFeedback() when $default != null:
return $default(_that.id,_that.category,_that.message,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserFeedback implements UserFeedback {
  const _UserFeedback({required this.id, required this.category, required this.message, required this.createdAt});
  factory _UserFeedback.fromJson(Map<String, dynamic> json) => _$UserFeedbackFromJson(json);

@override final  String id;
@override final  FeedbackCategory category;
@override final  String message;
@override final  String createdAt;

/// Create a copy of UserFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFeedbackCopyWith<_UserFeedback> get copyWith => __$UserFeedbackCopyWithImpl<_UserFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,message,createdAt);

@override
String toString() {
  return 'UserFeedback(id: $id, category: $category, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserFeedbackCopyWith<$Res> implements $UserFeedbackCopyWith<$Res> {
  factory _$UserFeedbackCopyWith(_UserFeedback value, $Res Function(_UserFeedback) _then) = __$UserFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String id, FeedbackCategory category, String message, String createdAt
});




}
/// @nodoc
class __$UserFeedbackCopyWithImpl<$Res>
    implements _$UserFeedbackCopyWith<$Res> {
  __$UserFeedbackCopyWithImpl(this._self, this._then);

  final _UserFeedback _self;
  final $Res Function(_UserFeedback) _then;

/// Create a copy of UserFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? message = null,Object? createdAt = null,}) {
  return _then(_UserFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeedbackCategory,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
