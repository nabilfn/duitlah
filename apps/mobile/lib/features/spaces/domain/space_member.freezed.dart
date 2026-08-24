// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'space_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpaceMember {

 String get id; String get userId; String? get displayName; String? get email; SpaceRole get role; MemberStatus get status;
/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceMemberCopyWith<SpaceMember> get copyWith => _$SpaceMemberCopyWithImpl<SpaceMember>(this as SpaceMember, _$identity);

  /// Serializes this SpaceMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceMember&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,displayName,email,role,status);

@override
String toString() {
  return 'SpaceMember(id: $id, userId: $userId, displayName: $displayName, email: $email, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class $SpaceMemberCopyWith<$Res>  {
  factory $SpaceMemberCopyWith(SpaceMember value, $Res Function(SpaceMember) _then) = _$SpaceMemberCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? displayName, String? email, SpaceRole role, MemberStatus status
});




}
/// @nodoc
class _$SpaceMemberCopyWithImpl<$Res>
    implements $SpaceMemberCopyWith<$Res> {
  _$SpaceMemberCopyWithImpl(this._self, this._then);

  final SpaceMember _self;
  final $Res Function(SpaceMember) _then;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? displayName = freezed,Object? email = freezed,Object? role = null,Object? status = null,}) {
  return _then(SpaceMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SpaceRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceMember].
extension SpaceMemberPatterns on SpaceMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceMember value)  $default,){
final _that = this;
switch (_that) {
case _SpaceMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceMember value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? displayName,  String? email,  SpaceRole role,  MemberStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that.id,_that.userId,_that.displayName,_that.email,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? displayName,  String? email,  SpaceRole role,  MemberStatus status)  $default,) {final _that = this;
switch (_that) {
case _SpaceMember():
return $default(_that.id,_that.userId,_that.displayName,_that.email,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? displayName,  String? email,  SpaceRole role,  MemberStatus status)?  $default,) {final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that.id,_that.userId,_that.displayName,_that.email,_that.role,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceMember implements SpaceMember {
  const _SpaceMember({required this.id, required this.userId, this.displayName, this.email, required this.role, required this.status});
  factory _SpaceMember.fromJson(Map<String, dynamic> json) => _$SpaceMemberFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? displayName;
@override final  String? email;
@override final  SpaceRole role;
@override final  MemberStatus status;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceMemberCopyWith<_SpaceMember> get copyWith => __$SpaceMemberCopyWithImpl<_SpaceMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceMember&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,displayName,email,role,status);

@override
String toString() {
  return 'SpaceMember(id: $id, userId: $userId, displayName: $displayName, email: $email, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SpaceMemberCopyWith<$Res> implements $SpaceMemberCopyWith<$Res> {
  factory _$SpaceMemberCopyWith(_SpaceMember value, $Res Function(_SpaceMember) _then) = __$SpaceMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? displayName, String? email, SpaceRole role, MemberStatus status
});




}
/// @nodoc
class __$SpaceMemberCopyWithImpl<$Res>
    implements _$SpaceMemberCopyWith<$Res> {
  __$SpaceMemberCopyWithImpl(this._self, this._then);

  final _SpaceMember _self;
  final $Res Function(_SpaceMember) _then;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? displayName = freezed,Object? email = freezed,Object? role = null,Object? status = null,}) {
  return _then(_SpaceMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SpaceRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,
  ));
}


}

// dart format on
