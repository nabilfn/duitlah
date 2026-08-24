// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Group {

 String get id; String get name; GroupType get type; GroupMemberRole get yourRole; int get memberCount; bool get archived;
/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCopyWith<Group> get copyWith => _$GroupCopyWithImpl<Group>(this as Group, _$identity);

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Group&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.yourRole, yourRole) || other.yourRole == yourRole)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,yourRole,memberCount,archived);

@override
String toString() {
  return 'Group(id: $id, name: $name, type: $type, yourRole: $yourRole, memberCount: $memberCount, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $GroupCopyWith<$Res>  {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) = _$GroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, GroupType type, GroupMemberRole yourRole, int memberCount, bool archived
});




}
/// @nodoc
class _$GroupCopyWithImpl<$Res>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? yourRole = null,Object? memberCount = null,Object? archived = null,}) {
  return _then(Group(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GroupType,yourRole: null == yourRole ? _self.yourRole : yourRole // ignore: cast_nullable_to_non_nullable
as GroupMemberRole,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Group].
extension GroupPatterns on Group {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Group value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Group value)  $default,){
final _that = this;
switch (_that) {
case _Group():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Group value)?  $default,){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  GroupType type,  GroupMemberRole yourRole,  int memberCount,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.yourRole,_that.memberCount,_that.archived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  GroupType type,  GroupMemberRole yourRole,  int memberCount,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _Group():
return $default(_that.id,_that.name,_that.type,_that.yourRole,_that.memberCount,_that.archived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  GroupType type,  GroupMemberRole yourRole,  int memberCount,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.yourRole,_that.memberCount,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Group implements Group {
  const _Group({required this.id, required this.name, required this.type, required this.yourRole, required this.memberCount, required this.archived});
  factory _Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  GroupType type;
@override final  GroupMemberRole yourRole;
@override final  int memberCount;
@override final  bool archived;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupCopyWith<_Group> get copyWith => __$GroupCopyWithImpl<_Group>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Group&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.yourRole, yourRole) || other.yourRole == yourRole)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,yourRole,memberCount,archived);

@override
String toString() {
  return 'Group(id: $id, name: $name, type: $type, yourRole: $yourRole, memberCount: $memberCount, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$GroupCopyWith(_Group value, $Res Function(_Group) _then) = __$GroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, GroupType type, GroupMemberRole yourRole, int memberCount, bool archived
});




}
/// @nodoc
class __$GroupCopyWithImpl<$Res>
    implements _$GroupCopyWith<$Res> {
  __$GroupCopyWithImpl(this._self, this._then);

  final _Group _self;
  final $Res Function(_Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? yourRole = null,Object? memberCount = null,Object? archived = null,}) {
  return _then(_Group(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GroupType,yourRole: null == yourRole ? _self.yourRole : yourRole // ignore: cast_nullable_to_non_nullable
as GroupMemberRole,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GroupMember {

 String get userId; String get displayName; String get email; GroupMemberRole get role; String get joinedAt;
/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberCopyWith<GroupMember> get copyWith => _$GroupMemberCopyWithImpl<GroupMember>(this as GroupMember, _$identity);

  /// Serializes this GroupMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,email,role,joinedAt);

@override
String toString() {
  return 'GroupMember(userId: $userId, displayName: $displayName, email: $email, role: $role, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $GroupMemberCopyWith<$Res>  {
  factory $GroupMemberCopyWith(GroupMember value, $Res Function(GroupMember) _then) = _$GroupMemberCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName, String email, GroupMemberRole role, String joinedAt
});




}
/// @nodoc
class _$GroupMemberCopyWithImpl<$Res>
    implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._self, this._then);

  final GroupMember _self;
  final $Res Function(GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? email = null,Object? role = null,Object? joinedAt = null,}) {
  return _then(GroupMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as GroupMemberRole,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMember].
extension GroupMemberPatterns on GroupMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMember value)  $default,){
final _that = this;
switch (_that) {
case _GroupMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMember value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName,  String email,  GroupMemberRole role,  String joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.userId,_that.displayName,_that.email,_that.role,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName,  String email,  GroupMemberRole role,  String joinedAt)  $default,) {final _that = this;
switch (_that) {
case _GroupMember():
return $default(_that.userId,_that.displayName,_that.email,_that.role,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName,  String email,  GroupMemberRole role,  String joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupMember() when $default != null:
return $default(_that.userId,_that.displayName,_that.email,_that.role,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupMember implements GroupMember {
  const _GroupMember({required this.userId, required this.displayName, required this.email, required this.role, required this.joinedAt});
  factory _GroupMember.fromJson(Map<String, dynamic> json) => _$GroupMemberFromJson(json);

@override final  String userId;
@override final  String displayName;
@override final  String email;
@override final  GroupMemberRole role;
@override final  String joinedAt;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberCopyWith<_GroupMember> get copyWith => __$GroupMemberCopyWithImpl<_GroupMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,email,role,joinedAt);

@override
String toString() {
  return 'GroupMember(userId: $userId, displayName: $displayName, email: $email, role: $role, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberCopyWith<$Res> implements $GroupMemberCopyWith<$Res> {
  factory _$GroupMemberCopyWith(_GroupMember value, $Res Function(_GroupMember) _then) = __$GroupMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName, String email, GroupMemberRole role, String joinedAt
});




}
/// @nodoc
class __$GroupMemberCopyWithImpl<$Res>
    implements _$GroupMemberCopyWith<$Res> {
  __$GroupMemberCopyWithImpl(this._self, this._then);

  final _GroupMember _self;
  final $Res Function(_GroupMember) _then;

/// Create a copy of GroupMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? email = null,Object? role = null,Object? joinedAt = null,}) {
  return _then(_GroupMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as GroupMemberRole,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupExpenseShare {

 String get userId; String get displayName;@AmountConverter() String get amount;
/// Create a copy of GroupExpenseShare
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupExpenseShareCopyWith<GroupExpenseShare> get copyWith => _$GroupExpenseShareCopyWithImpl<GroupExpenseShare>(this as GroupExpenseShare, _$identity);

  /// Serializes this GroupExpenseShare to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupExpenseShare&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,amount);

@override
String toString() {
  return 'GroupExpenseShare(userId: $userId, displayName: $displayName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $GroupExpenseShareCopyWith<$Res>  {
  factory $GroupExpenseShareCopyWith(GroupExpenseShare value, $Res Function(GroupExpenseShare) _then) = _$GroupExpenseShareCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName,@AmountConverter() String amount
});




}
/// @nodoc
class _$GroupExpenseShareCopyWithImpl<$Res>
    implements $GroupExpenseShareCopyWith<$Res> {
  _$GroupExpenseShareCopyWithImpl(this._self, this._then);

  final GroupExpenseShare _self;
  final $Res Function(GroupExpenseShare) _then;

/// Create a copy of GroupExpenseShare
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? amount = null,}) {
  return _then(GroupExpenseShare(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupExpenseShare].
extension GroupExpenseSharePatterns on GroupExpenseShare {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupExpenseShare value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupExpenseShare() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupExpenseShare value)  $default,){
final _that = this;
switch (_that) {
case _GroupExpenseShare():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupExpenseShare value)?  $default,){
final _that = this;
switch (_that) {
case _GroupExpenseShare() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupExpenseShare() when $default != null:
return $default(_that.userId,_that.displayName,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String amount)  $default,) {final _that = this;
switch (_that) {
case _GroupExpenseShare():
return $default(_that.userId,_that.displayName,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName, @AmountConverter()  String amount)?  $default,) {final _that = this;
switch (_that) {
case _GroupExpenseShare() when $default != null:
return $default(_that.userId,_that.displayName,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupExpenseShare implements GroupExpenseShare {
  const _GroupExpenseShare({required this.userId, required this.displayName, @AmountConverter() required this.amount});
  factory _GroupExpenseShare.fromJson(Map<String, dynamic> json) => _$GroupExpenseShareFromJson(json);

@override final  String userId;
@override final  String displayName;
@override@AmountConverter() final  String amount;

/// Create a copy of GroupExpenseShare
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupExpenseShareCopyWith<_GroupExpenseShare> get copyWith => __$GroupExpenseShareCopyWithImpl<_GroupExpenseShare>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupExpenseShareToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupExpenseShare&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,amount);

@override
String toString() {
  return 'GroupExpenseShare(userId: $userId, displayName: $displayName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$GroupExpenseShareCopyWith<$Res> implements $GroupExpenseShareCopyWith<$Res> {
  factory _$GroupExpenseShareCopyWith(_GroupExpenseShare value, $Res Function(_GroupExpenseShare) _then) = __$GroupExpenseShareCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName,@AmountConverter() String amount
});




}
/// @nodoc
class __$GroupExpenseShareCopyWithImpl<$Res>
    implements _$GroupExpenseShareCopyWith<$Res> {
  __$GroupExpenseShareCopyWithImpl(this._self, this._then);

  final _GroupExpenseShare _self;
  final $Res Function(_GroupExpenseShare) _then;

/// Create a copy of GroupExpenseShare
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? amount = null,}) {
  return _then(_GroupExpenseShare(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupExpense {

 String get id; String get description;@AmountConverter() String get amount; String get occurredOn; String get paidByUserId; String get paidByName; List<GroupExpenseShare> get shares; GroupExpenseCategory? get category; String? get originalCurrency;@NullableAmountConverter() String? get originalAmount;@NullableAmountConverter() String? get exchangeRate;
/// Create a copy of GroupExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupExpenseCopyWith<GroupExpense> get copyWith => _$GroupExpenseCopyWithImpl<GroupExpense>(this as GroupExpense, _$identity);

  /// Serializes this GroupExpense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.paidByUserId, paidByUserId) || other.paidByUserId == paidByUserId)&&(identical(other.paidByName, paidByName) || other.paidByName == paidByName)&&const DeepCollectionEquality().equals(other.shares, shares)&&(identical(other.category, category) || other.category == category)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,amount,occurredOn,paidByUserId,paidByName,const DeepCollectionEquality().hash(shares),category,originalCurrency,originalAmount,exchangeRate);

@override
String toString() {
  return 'GroupExpense(id: $id, description: $description, amount: $amount, occurredOn: $occurredOn, paidByUserId: $paidByUserId, paidByName: $paidByName, shares: $shares, category: $category, originalCurrency: $originalCurrency, originalAmount: $originalAmount, exchangeRate: $exchangeRate)';
}


}

/// @nodoc
abstract mixin class $GroupExpenseCopyWith<$Res>  {
  factory $GroupExpenseCopyWith(GroupExpense value, $Res Function(GroupExpense) _then) = _$GroupExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String description,@AmountConverter() String amount, String occurredOn, String paidByUserId, String paidByName, List<GroupExpenseShare> shares, GroupExpenseCategory? category, String? originalCurrency,@NullableAmountConverter() String? originalAmount,@NullableAmountConverter() String? exchangeRate
});




}
/// @nodoc
class _$GroupExpenseCopyWithImpl<$Res>
    implements $GroupExpenseCopyWith<$Res> {
  _$GroupExpenseCopyWithImpl(this._self, this._then);

  final GroupExpense _self;
  final $Res Function(GroupExpense) _then;

/// Create a copy of GroupExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? amount = null,Object? occurredOn = null,Object? paidByUserId = null,Object? paidByName = null,Object? shares = null,Object? category = freezed,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? exchangeRate = freezed,}) {
  return _then(GroupExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,paidByUserId: null == paidByUserId ? _self.paidByUserId : paidByUserId // ignore: cast_nullable_to_non_nullable
as String,paidByName: null == paidByName ? _self.paidByName : paidByName // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as List<GroupExpenseShare>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as GroupExpenseCategory?,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupExpense].
extension GroupExpensePatterns on GroupExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupExpense value)  $default,){
final _that = this;
switch (_that) {
case _GroupExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupExpense value)?  $default,){
final _that = this;
switch (_that) {
case _GroupExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description, @AmountConverter()  String amount,  String occurredOn,  String paidByUserId,  String paidByName,  List<GroupExpenseShare> shares,  GroupExpenseCategory? category,  String? originalCurrency, @NullableAmountConverter()  String? originalAmount, @NullableAmountConverter()  String? exchangeRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupExpense() when $default != null:
return $default(_that.id,_that.description,_that.amount,_that.occurredOn,_that.paidByUserId,_that.paidByName,_that.shares,_that.category,_that.originalCurrency,_that.originalAmount,_that.exchangeRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description, @AmountConverter()  String amount,  String occurredOn,  String paidByUserId,  String paidByName,  List<GroupExpenseShare> shares,  GroupExpenseCategory? category,  String? originalCurrency, @NullableAmountConverter()  String? originalAmount, @NullableAmountConverter()  String? exchangeRate)  $default,) {final _that = this;
switch (_that) {
case _GroupExpense():
return $default(_that.id,_that.description,_that.amount,_that.occurredOn,_that.paidByUserId,_that.paidByName,_that.shares,_that.category,_that.originalCurrency,_that.originalAmount,_that.exchangeRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description, @AmountConverter()  String amount,  String occurredOn,  String paidByUserId,  String paidByName,  List<GroupExpenseShare> shares,  GroupExpenseCategory? category,  String? originalCurrency, @NullableAmountConverter()  String? originalAmount, @NullableAmountConverter()  String? exchangeRate)?  $default,) {final _that = this;
switch (_that) {
case _GroupExpense() when $default != null:
return $default(_that.id,_that.description,_that.amount,_that.occurredOn,_that.paidByUserId,_that.paidByName,_that.shares,_that.category,_that.originalCurrency,_that.originalAmount,_that.exchangeRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupExpense implements GroupExpense {
  const _GroupExpense({required this.id, required this.description, @AmountConverter() required this.amount, required this.occurredOn, required this.paidByUserId, required this.paidByName, required  List<GroupExpenseShare> shares, this.category, this.originalCurrency, @NullableAmountConverter() this.originalAmount, @NullableAmountConverter() this.exchangeRate}): _shares = shares;
  factory _GroupExpense.fromJson(Map<String, dynamic> json) => _$GroupExpenseFromJson(json);

@override final  String id;
@override final  String description;
@override@AmountConverter() final  String amount;
@override final  String occurredOn;
@override final  String paidByUserId;
@override final  String paidByName;
 final  List<GroupExpenseShare> _shares;
@override List<GroupExpenseShare> get shares {
  if (_shares is EqualUnmodifiableListView) return _shares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shares);
}

@override final  GroupExpenseCategory? category;
@override final  String? originalCurrency;
@override@NullableAmountConverter() final  String? originalAmount;
@override@NullableAmountConverter() final  String? exchangeRate;

/// Create a copy of GroupExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupExpenseCopyWith<_GroupExpense> get copyWith => __$GroupExpenseCopyWithImpl<_GroupExpense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.paidByUserId, paidByUserId) || other.paidByUserId == paidByUserId)&&(identical(other.paidByName, paidByName) || other.paidByName == paidByName)&&const DeepCollectionEquality().equals(other._shares, _shares)&&(identical(other.category, category) || other.category == category)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.originalAmount, originalAmount) || other.originalAmount == originalAmount)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,amount,occurredOn,paidByUserId,paidByName,const DeepCollectionEquality().hash(_shares),category,originalCurrency,originalAmount,exchangeRate);

@override
String toString() {
  return 'GroupExpense(id: $id, description: $description, amount: $amount, occurredOn: $occurredOn, paidByUserId: $paidByUserId, paidByName: $paidByName, shares: $shares, category: $category, originalCurrency: $originalCurrency, originalAmount: $originalAmount, exchangeRate: $exchangeRate)';
}


}

/// @nodoc
abstract mixin class _$GroupExpenseCopyWith<$Res> implements $GroupExpenseCopyWith<$Res> {
  factory _$GroupExpenseCopyWith(_GroupExpense value, $Res Function(_GroupExpense) _then) = __$GroupExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String description,@AmountConverter() String amount, String occurredOn, String paidByUserId, String paidByName, List<GroupExpenseShare> shares, GroupExpenseCategory? category, String? originalCurrency,@NullableAmountConverter() String? originalAmount,@NullableAmountConverter() String? exchangeRate
});




}
/// @nodoc
class __$GroupExpenseCopyWithImpl<$Res>
    implements _$GroupExpenseCopyWith<$Res> {
  __$GroupExpenseCopyWithImpl(this._self, this._then);

  final _GroupExpense _self;
  final $Res Function(_GroupExpense) _then;

/// Create a copy of GroupExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? amount = null,Object? occurredOn = null,Object? paidByUserId = null,Object? paidByName = null,Object? shares = null,Object? category = freezed,Object? originalCurrency = freezed,Object? originalAmount = freezed,Object? exchangeRate = freezed,}) {
  return _then(_GroupExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,paidByUserId: null == paidByUserId ? _self.paidByUserId : paidByUserId // ignore: cast_nullable_to_non_nullable
as String,paidByName: null == paidByName ? _self.paidByName : paidByName // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self._shares : shares // ignore: cast_nullable_to_non_nullable
as List<GroupExpenseShare>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as GroupExpenseCategory?,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,originalAmount: freezed == originalAmount ? _self.originalAmount : originalAmount // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GroupBalance {

 String get userId; String get displayName;@AmountConverter() String get totalPaid;@AmountConverter() String get totalShare;@AmountConverter() String get net;
/// Create a copy of GroupBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupBalanceCopyWith<GroupBalance> get copyWith => _$GroupBalanceCopyWithImpl<GroupBalance>(this as GroupBalance, _$identity);

  /// Serializes this GroupBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupBalance&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.totalShare, totalShare) || other.totalShare == totalShare)&&(identical(other.net, net) || other.net == net));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,totalPaid,totalShare,net);

@override
String toString() {
  return 'GroupBalance(userId: $userId, displayName: $displayName, totalPaid: $totalPaid, totalShare: $totalShare, net: $net)';
}


}

/// @nodoc
abstract mixin class $GroupBalanceCopyWith<$Res>  {
  factory $GroupBalanceCopyWith(GroupBalance value, $Res Function(GroupBalance) _then) = _$GroupBalanceCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName,@AmountConverter() String totalPaid,@AmountConverter() String totalShare,@AmountConverter() String net
});




}
/// @nodoc
class _$GroupBalanceCopyWithImpl<$Res>
    implements $GroupBalanceCopyWith<$Res> {
  _$GroupBalanceCopyWithImpl(this._self, this._then);

  final GroupBalance _self;
  final $Res Function(GroupBalance) _then;

/// Create a copy of GroupBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? totalPaid = null,Object? totalShare = null,Object? net = null,}) {
  return _then(GroupBalance(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String,totalShare: null == totalShare ? _self.totalShare : totalShare // ignore: cast_nullable_to_non_nullable
as String,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupBalance].
extension GroupBalancePatterns on GroupBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupBalance value)  $default,){
final _that = this;
switch (_that) {
case _GroupBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupBalance value)?  $default,){
final _that = this;
switch (_that) {
case _GroupBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String totalPaid, @AmountConverter()  String totalShare, @AmountConverter()  String net)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupBalance() when $default != null:
return $default(_that.userId,_that.displayName,_that.totalPaid,_that.totalShare,_that.net);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String totalPaid, @AmountConverter()  String totalShare, @AmountConverter()  String net)  $default,) {final _that = this;
switch (_that) {
case _GroupBalance():
return $default(_that.userId,_that.displayName,_that.totalPaid,_that.totalShare,_that.net);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName, @AmountConverter()  String totalPaid, @AmountConverter()  String totalShare, @AmountConverter()  String net)?  $default,) {final _that = this;
switch (_that) {
case _GroupBalance() when $default != null:
return $default(_that.userId,_that.displayName,_that.totalPaid,_that.totalShare,_that.net);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupBalance implements GroupBalance {
  const _GroupBalance({required this.userId, required this.displayName, @AmountConverter() required this.totalPaid, @AmountConverter() required this.totalShare, @AmountConverter() required this.net});
  factory _GroupBalance.fromJson(Map<String, dynamic> json) => _$GroupBalanceFromJson(json);

@override final  String userId;
@override final  String displayName;
@override@AmountConverter() final  String totalPaid;
@override@AmountConverter() final  String totalShare;
@override@AmountConverter() final  String net;

/// Create a copy of GroupBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupBalanceCopyWith<_GroupBalance> get copyWith => __$GroupBalanceCopyWithImpl<_GroupBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupBalance&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.totalShare, totalShare) || other.totalShare == totalShare)&&(identical(other.net, net) || other.net == net));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,totalPaid,totalShare,net);

@override
String toString() {
  return 'GroupBalance(userId: $userId, displayName: $displayName, totalPaid: $totalPaid, totalShare: $totalShare, net: $net)';
}


}

/// @nodoc
abstract mixin class _$GroupBalanceCopyWith<$Res> implements $GroupBalanceCopyWith<$Res> {
  factory _$GroupBalanceCopyWith(_GroupBalance value, $Res Function(_GroupBalance) _then) = __$GroupBalanceCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName,@AmountConverter() String totalPaid,@AmountConverter() String totalShare,@AmountConverter() String net
});




}
/// @nodoc
class __$GroupBalanceCopyWithImpl<$Res>
    implements _$GroupBalanceCopyWith<$Res> {
  __$GroupBalanceCopyWithImpl(this._self, this._then);

  final _GroupBalance _self;
  final $Res Function(_GroupBalance) _then;

/// Create a copy of GroupBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? totalPaid = null,Object? totalShare = null,Object? net = null,}) {
  return _then(_GroupBalance(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String,totalShare: null == totalShare ? _self.totalShare : totalShare // ignore: cast_nullable_to_non_nullable
as String,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupGoalMemberContribution {

 String get userId; String get displayName;@AmountConverter() String get totalContributed;
/// Create a copy of GroupGoalMemberContribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupGoalMemberContributionCopyWith<GroupGoalMemberContribution> get copyWith => _$GroupGoalMemberContributionCopyWithImpl<GroupGoalMemberContribution>(this as GroupGoalMemberContribution, _$identity);

  /// Serializes this GroupGoalMemberContribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupGoalMemberContribution&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.totalContributed, totalContributed) || other.totalContributed == totalContributed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,totalContributed);

@override
String toString() {
  return 'GroupGoalMemberContribution(userId: $userId, displayName: $displayName, totalContributed: $totalContributed)';
}


}

/// @nodoc
abstract mixin class $GroupGoalMemberContributionCopyWith<$Res>  {
  factory $GroupGoalMemberContributionCopyWith(GroupGoalMemberContribution value, $Res Function(GroupGoalMemberContribution) _then) = _$GroupGoalMemberContributionCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName,@AmountConverter() String totalContributed
});




}
/// @nodoc
class _$GroupGoalMemberContributionCopyWithImpl<$Res>
    implements $GroupGoalMemberContributionCopyWith<$Res> {
  _$GroupGoalMemberContributionCopyWithImpl(this._self, this._then);

  final GroupGoalMemberContribution _self;
  final $Res Function(GroupGoalMemberContribution) _then;

/// Create a copy of GroupGoalMemberContribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? totalContributed = null,}) {
  return _then(GroupGoalMemberContribution(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,totalContributed: null == totalContributed ? _self.totalContributed : totalContributed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupGoalMemberContribution].
extension GroupGoalMemberContributionPatterns on GroupGoalMemberContribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupGoalMemberContribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupGoalMemberContribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupGoalMemberContribution value)  $default,){
final _that = this;
switch (_that) {
case _GroupGoalMemberContribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupGoalMemberContribution value)?  $default,){
final _that = this;
switch (_that) {
case _GroupGoalMemberContribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String totalContributed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupGoalMemberContribution() when $default != null:
return $default(_that.userId,_that.displayName,_that.totalContributed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String totalContributed)  $default,) {final _that = this;
switch (_that) {
case _GroupGoalMemberContribution():
return $default(_that.userId,_that.displayName,_that.totalContributed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName, @AmountConverter()  String totalContributed)?  $default,) {final _that = this;
switch (_that) {
case _GroupGoalMemberContribution() when $default != null:
return $default(_that.userId,_that.displayName,_that.totalContributed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupGoalMemberContribution implements GroupGoalMemberContribution {
  const _GroupGoalMemberContribution({required this.userId, required this.displayName, @AmountConverter() required this.totalContributed});
  factory _GroupGoalMemberContribution.fromJson(Map<String, dynamic> json) => _$GroupGoalMemberContributionFromJson(json);

@override final  String userId;
@override final  String displayName;
@override@AmountConverter() final  String totalContributed;

/// Create a copy of GroupGoalMemberContribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupGoalMemberContributionCopyWith<_GroupGoalMemberContribution> get copyWith => __$GroupGoalMemberContributionCopyWithImpl<_GroupGoalMemberContribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupGoalMemberContributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupGoalMemberContribution&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.totalContributed, totalContributed) || other.totalContributed == totalContributed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,totalContributed);

@override
String toString() {
  return 'GroupGoalMemberContribution(userId: $userId, displayName: $displayName, totalContributed: $totalContributed)';
}


}

/// @nodoc
abstract mixin class _$GroupGoalMemberContributionCopyWith<$Res> implements $GroupGoalMemberContributionCopyWith<$Res> {
  factory _$GroupGoalMemberContributionCopyWith(_GroupGoalMemberContribution value, $Res Function(_GroupGoalMemberContribution) _then) = __$GroupGoalMemberContributionCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName,@AmountConverter() String totalContributed
});




}
/// @nodoc
class __$GroupGoalMemberContributionCopyWithImpl<$Res>
    implements _$GroupGoalMemberContributionCopyWith<$Res> {
  __$GroupGoalMemberContributionCopyWithImpl(this._self, this._then);

  final _GroupGoalMemberContribution _self;
  final $Res Function(_GroupGoalMemberContribution) _then;

/// Create a copy of GroupGoalMemberContribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? totalContributed = null,}) {
  return _then(_GroupGoalMemberContribution(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,totalContributed: null == totalContributed ? _self.totalContributed : totalContributed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GroupGoal {

 String get id; String get name;@AmountConverter() String get targetAmount; String? get targetDate;@AmountConverter() String get currentAmount;@AmountConverter() String get remaining;@AmountConverter() String get percentage; bool get archived; List<GroupGoalMemberContribution> get byMember;
/// Create a copy of GroupGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupGoalCopyWith<GroupGoal> get copyWith => _$GroupGoalCopyWithImpl<GroupGoal>(this as GroupGoal, _$identity);

  /// Serializes this GroupGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.archived, archived) || other.archived == archived)&&const DeepCollectionEquality().equals(other.byMember, byMember));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,targetAmount,targetDate,currentAmount,remaining,percentage,archived,const DeepCollectionEquality().hash(byMember));

@override
String toString() {
  return 'GroupGoal(id: $id, name: $name, targetAmount: $targetAmount, targetDate: $targetDate, currentAmount: $currentAmount, remaining: $remaining, percentage: $percentage, archived: $archived, byMember: $byMember)';
}


}

/// @nodoc
abstract mixin class $GroupGoalCopyWith<$Res>  {
  factory $GroupGoalCopyWith(GroupGoal value, $Res Function(GroupGoal) _then) = _$GroupGoalCopyWithImpl;
@useResult
$Res call({
 String id, String name,@AmountConverter() String targetAmount, String? targetDate,@AmountConverter() String currentAmount,@AmountConverter() String remaining,@AmountConverter() String percentage, bool archived, List<GroupGoalMemberContribution> byMember
});




}
/// @nodoc
class _$GroupGoalCopyWithImpl<$Res>
    implements $GroupGoalCopyWith<$Res> {
  _$GroupGoalCopyWithImpl(this._self, this._then);

  final GroupGoal _self;
  final $Res Function(GroupGoal) _then;

/// Create a copy of GroupGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? targetAmount = null,Object? targetDate = freezed,Object? currentAmount = null,Object? remaining = null,Object? percentage = null,Object? archived = null,Object? byMember = null,}) {
  return _then(GroupGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as String,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as String?,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as String,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as String,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,byMember: null == byMember ? _self.byMember : byMember // ignore: cast_nullable_to_non_nullable
as List<GroupGoalMemberContribution>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupGoal].
extension GroupGoalPatterns on GroupGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupGoal value)  $default,){
final _that = this;
switch (_that) {
case _GroupGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupGoal value)?  $default,){
final _that = this;
switch (_that) {
case _GroupGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @AmountConverter()  String targetAmount,  String? targetDate, @AmountConverter()  String currentAmount, @AmountConverter()  String remaining, @AmountConverter()  String percentage,  bool archived,  List<GroupGoalMemberContribution> byMember)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupGoal() when $default != null:
return $default(_that.id,_that.name,_that.targetAmount,_that.targetDate,_that.currentAmount,_that.remaining,_that.percentage,_that.archived,_that.byMember);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @AmountConverter()  String targetAmount,  String? targetDate, @AmountConverter()  String currentAmount, @AmountConverter()  String remaining, @AmountConverter()  String percentage,  bool archived,  List<GroupGoalMemberContribution> byMember)  $default,) {final _that = this;
switch (_that) {
case _GroupGoal():
return $default(_that.id,_that.name,_that.targetAmount,_that.targetDate,_that.currentAmount,_that.remaining,_that.percentage,_that.archived,_that.byMember);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @AmountConverter()  String targetAmount,  String? targetDate, @AmountConverter()  String currentAmount, @AmountConverter()  String remaining, @AmountConverter()  String percentage,  bool archived,  List<GroupGoalMemberContribution> byMember)?  $default,) {final _that = this;
switch (_that) {
case _GroupGoal() when $default != null:
return $default(_that.id,_that.name,_that.targetAmount,_that.targetDate,_that.currentAmount,_that.remaining,_that.percentage,_that.archived,_that.byMember);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupGoal implements GroupGoal {
  const _GroupGoal({required this.id, required this.name, @AmountConverter() required this.targetAmount, this.targetDate, @AmountConverter() required this.currentAmount, @AmountConverter() required this.remaining, @AmountConverter() required this.percentage, required this.archived, required  List<GroupGoalMemberContribution> byMember}): _byMember = byMember;
  factory _GroupGoal.fromJson(Map<String, dynamic> json) => _$GroupGoalFromJson(json);

@override final  String id;
@override final  String name;
@override@AmountConverter() final  String targetAmount;
@override final  String? targetDate;
@override@AmountConverter() final  String currentAmount;
@override@AmountConverter() final  String remaining;
@override@AmountConverter() final  String percentage;
@override final  bool archived;
 final  List<GroupGoalMemberContribution> _byMember;
@override List<GroupGoalMemberContribution> get byMember {
  if (_byMember is EqualUnmodifiableListView) return _byMember;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byMember);
}


/// Create a copy of GroupGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupGoalCopyWith<_GroupGoal> get copyWith => __$GroupGoalCopyWithImpl<_GroupGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.archived, archived) || other.archived == archived)&&const DeepCollectionEquality().equals(other._byMember, _byMember));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,targetAmount,targetDate,currentAmount,remaining,percentage,archived,const DeepCollectionEquality().hash(_byMember));

@override
String toString() {
  return 'GroupGoal(id: $id, name: $name, targetAmount: $targetAmount, targetDate: $targetDate, currentAmount: $currentAmount, remaining: $remaining, percentage: $percentage, archived: $archived, byMember: $byMember)';
}


}

/// @nodoc
abstract mixin class _$GroupGoalCopyWith<$Res> implements $GroupGoalCopyWith<$Res> {
  factory _$GroupGoalCopyWith(_GroupGoal value, $Res Function(_GroupGoal) _then) = __$GroupGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@AmountConverter() String targetAmount, String? targetDate,@AmountConverter() String currentAmount,@AmountConverter() String remaining,@AmountConverter() String percentage, bool archived, List<GroupGoalMemberContribution> byMember
});




}
/// @nodoc
class __$GroupGoalCopyWithImpl<$Res>
    implements _$GroupGoalCopyWith<$Res> {
  __$GroupGoalCopyWithImpl(this._self, this._then);

  final _GroupGoal _self;
  final $Res Function(_GroupGoal) _then;

/// Create a copy of GroupGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? targetAmount = null,Object? targetDate = freezed,Object? currentAmount = null,Object? remaining = null,Object? percentage = null,Object? archived = null,Object? byMember = null,}) {
  return _then(_GroupGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as String,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as String?,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as String,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as String,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,byMember: null == byMember ? _self._byMember : byMember // ignore: cast_nullable_to_non_nullable
as List<GroupGoalMemberContribution>,
  ));
}


}


/// @nodoc
mixin _$GroupGoalContribution {

 String get id; String get userId; String get userDisplayName;@AmountConverter() String get amount; String get occurredOn; String? get note;
/// Create a copy of GroupGoalContribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupGoalContributionCopyWith<GroupGoalContribution> get copyWith => _$GroupGoalContributionCopyWithImpl<GroupGoalContribution>(this as GroupGoalContribution, _$identity);

  /// Serializes this GroupGoalContribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupGoalContribution&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userDisplayName,amount,occurredOn,note);

@override
String toString() {
  return 'GroupGoalContribution(id: $id, userId: $userId, userDisplayName: $userDisplayName, amount: $amount, occurredOn: $occurredOn, note: $note)';
}


}

/// @nodoc
abstract mixin class $GroupGoalContributionCopyWith<$Res>  {
  factory $GroupGoalContributionCopyWith(GroupGoalContribution value, $Res Function(GroupGoalContribution) _then) = _$GroupGoalContributionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userDisplayName,@AmountConverter() String amount, String occurredOn, String? note
});




}
/// @nodoc
class _$GroupGoalContributionCopyWithImpl<$Res>
    implements $GroupGoalContributionCopyWith<$Res> {
  _$GroupGoalContributionCopyWithImpl(this._self, this._then);

  final GroupGoalContribution _self;
  final $Res Function(GroupGoalContribution) _then;

/// Create a copy of GroupGoalContribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userDisplayName = null,Object? amount = null,Object? occurredOn = null,Object? note = freezed,}) {
  return _then(GroupGoalContribution(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userDisplayName: null == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupGoalContribution].
extension GroupGoalContributionPatterns on GroupGoalContribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupGoalContribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupGoalContribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupGoalContribution value)  $default,){
final _that = this;
switch (_that) {
case _GroupGoalContribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupGoalContribution value)?  $default,){
final _that = this;
switch (_that) {
case _GroupGoalContribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userDisplayName, @AmountConverter()  String amount,  String occurredOn,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupGoalContribution() when $default != null:
return $default(_that.id,_that.userId,_that.userDisplayName,_that.amount,_that.occurredOn,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userDisplayName, @AmountConverter()  String amount,  String occurredOn,  String? note)  $default,) {final _that = this;
switch (_that) {
case _GroupGoalContribution():
return $default(_that.id,_that.userId,_that.userDisplayName,_that.amount,_that.occurredOn,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userDisplayName, @AmountConverter()  String amount,  String occurredOn,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _GroupGoalContribution() when $default != null:
return $default(_that.id,_that.userId,_that.userDisplayName,_that.amount,_that.occurredOn,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupGoalContribution implements GroupGoalContribution {
  const _GroupGoalContribution({required this.id, required this.userId, required this.userDisplayName, @AmountConverter() required this.amount, required this.occurredOn, this.note});
  factory _GroupGoalContribution.fromJson(Map<String, dynamic> json) => _$GroupGoalContributionFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String userDisplayName;
@override@AmountConverter() final  String amount;
@override final  String occurredOn;
@override final  String? note;

/// Create a copy of GroupGoalContribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupGoalContributionCopyWith<_GroupGoalContribution> get copyWith => __$GroupGoalContributionCopyWithImpl<_GroupGoalContribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupGoalContributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupGoalContribution&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userDisplayName, userDisplayName) || other.userDisplayName == userDisplayName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userDisplayName,amount,occurredOn,note);

@override
String toString() {
  return 'GroupGoalContribution(id: $id, userId: $userId, userDisplayName: $userDisplayName, amount: $amount, occurredOn: $occurredOn, note: $note)';
}


}

/// @nodoc
abstract mixin class _$GroupGoalContributionCopyWith<$Res> implements $GroupGoalContributionCopyWith<$Res> {
  factory _$GroupGoalContributionCopyWith(_GroupGoalContribution value, $Res Function(_GroupGoalContribution) _then) = __$GroupGoalContributionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userDisplayName,@AmountConverter() String amount, String occurredOn, String? note
});




}
/// @nodoc
class __$GroupGoalContributionCopyWithImpl<$Res>
    implements _$GroupGoalContributionCopyWith<$Res> {
  __$GroupGoalContributionCopyWithImpl(this._self, this._then);

  final _GroupGoalContribution _self;
  final $Res Function(_GroupGoalContribution) _then;

/// Create a copy of GroupGoalContribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userDisplayName = null,Object? amount = null,Object? occurredOn = null,Object? note = freezed,}) {
  return _then(_GroupGoalContribution(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userDisplayName: null == userDisplayName ? _self.userDisplayName : userDisplayName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GroupBudget {

@AmountConverter() String get amount;@AmountConverter() String get spent;@AmountConverter() String get remaining;
/// Create a copy of GroupBudget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupBudgetCopyWith<GroupBudget> get copyWith => _$GroupBudgetCopyWithImpl<GroupBudget>(this as GroupBudget, _$identity);

  /// Serializes this GroupBudget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupBudget&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,spent,remaining);

@override
String toString() {
  return 'GroupBudget(amount: $amount, spent: $spent, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class $GroupBudgetCopyWith<$Res>  {
  factory $GroupBudgetCopyWith(GroupBudget value, $Res Function(GroupBudget) _then) = _$GroupBudgetCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String amount,@AmountConverter() String spent,@AmountConverter() String remaining
});




}
/// @nodoc
class _$GroupBudgetCopyWithImpl<$Res>
    implements $GroupBudgetCopyWith<$Res> {
  _$GroupBudgetCopyWithImpl(this._self, this._then);

  final GroupBudget _self;
  final $Res Function(GroupBudget) _then;

/// Create a copy of GroupBudget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? spent = null,Object? remaining = null,}) {
  return _then(GroupBudget(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as String,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupBudget].
extension GroupBudgetPatterns on GroupBudget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupBudget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupBudget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupBudget value)  $default,){
final _that = this;
switch (_that) {
case _GroupBudget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupBudget value)?  $default,){
final _that = this;
switch (_that) {
case _GroupBudget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String amount, @AmountConverter()  String spent, @AmountConverter()  String remaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupBudget() when $default != null:
return $default(_that.amount,_that.spent,_that.remaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String amount, @AmountConverter()  String spent, @AmountConverter()  String remaining)  $default,) {final _that = this;
switch (_that) {
case _GroupBudget():
return $default(_that.amount,_that.spent,_that.remaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String amount, @AmountConverter()  String spent, @AmountConverter()  String remaining)?  $default,) {final _that = this;
switch (_that) {
case _GroupBudget() when $default != null:
return $default(_that.amount,_that.spent,_that.remaining);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupBudget implements GroupBudget {
  const _GroupBudget({@AmountConverter() required this.amount, @AmountConverter() required this.spent, @AmountConverter() required this.remaining});
  factory _GroupBudget.fromJson(Map<String, dynamic> json) => _$GroupBudgetFromJson(json);

@override@AmountConverter() final  String amount;
@override@AmountConverter() final  String spent;
@override@AmountConverter() final  String remaining;

/// Create a copy of GroupBudget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupBudgetCopyWith<_GroupBudget> get copyWith => __$GroupBudgetCopyWithImpl<_GroupBudget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupBudgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupBudget&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,spent,remaining);

@override
String toString() {
  return 'GroupBudget(amount: $amount, spent: $spent, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class _$GroupBudgetCopyWith<$Res> implements $GroupBudgetCopyWith<$Res> {
  factory _$GroupBudgetCopyWith(_GroupBudget value, $Res Function(_GroupBudget) _then) = __$GroupBudgetCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String amount,@AmountConverter() String spent,@AmountConverter() String remaining
});




}
/// @nodoc
class __$GroupBudgetCopyWithImpl<$Res>
    implements _$GroupBudgetCopyWith<$Res> {
  __$GroupBudgetCopyWithImpl(this._self, this._then);

  final _GroupBudget _self;
  final $Res Function(_GroupBudget) _then;

/// Create a copy of GroupBudget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? spent = null,Object? remaining = null,}) {
  return _then(_GroupBudget(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as String,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TripCategorySpending {

 GroupExpenseCategory get category;@AmountConverter() String get amount;
/// Create a copy of TripCategorySpending
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCategorySpendingCopyWith<TripCategorySpending> get copyWith => _$TripCategorySpendingCopyWithImpl<TripCategorySpending>(this as TripCategorySpending, _$identity);

  /// Serializes this TripCategorySpending to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripCategorySpending&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,amount);

@override
String toString() {
  return 'TripCategorySpending(category: $category, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $TripCategorySpendingCopyWith<$Res>  {
  factory $TripCategorySpendingCopyWith(TripCategorySpending value, $Res Function(TripCategorySpending) _then) = _$TripCategorySpendingCopyWithImpl;
@useResult
$Res call({
 GroupExpenseCategory category,@AmountConverter() String amount
});




}
/// @nodoc
class _$TripCategorySpendingCopyWithImpl<$Res>
    implements $TripCategorySpendingCopyWith<$Res> {
  _$TripCategorySpendingCopyWithImpl(this._self, this._then);

  final TripCategorySpending _self;
  final $Res Function(TripCategorySpending) _then;

/// Create a copy of TripCategorySpending
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? amount = null,}) {
  return _then(TripCategorySpending(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as GroupExpenseCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TripCategorySpending].
extension TripCategorySpendingPatterns on TripCategorySpending {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripCategorySpending value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripCategorySpending() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripCategorySpending value)  $default,){
final _that = this;
switch (_that) {
case _TripCategorySpending():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripCategorySpending value)?  $default,){
final _that = this;
switch (_that) {
case _TripCategorySpending() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GroupExpenseCategory category, @AmountConverter()  String amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripCategorySpending() when $default != null:
return $default(_that.category,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GroupExpenseCategory category, @AmountConverter()  String amount)  $default,) {final _that = this;
switch (_that) {
case _TripCategorySpending():
return $default(_that.category,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GroupExpenseCategory category, @AmountConverter()  String amount)?  $default,) {final _that = this;
switch (_that) {
case _TripCategorySpending() when $default != null:
return $default(_that.category,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripCategorySpending implements TripCategorySpending {
  const _TripCategorySpending({required this.category, @AmountConverter() required this.amount});
  factory _TripCategorySpending.fromJson(Map<String, dynamic> json) => _$TripCategorySpendingFromJson(json);

@override final  GroupExpenseCategory category;
@override@AmountConverter() final  String amount;

/// Create a copy of TripCategorySpending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCategorySpendingCopyWith<_TripCategorySpending> get copyWith => __$TripCategorySpendingCopyWithImpl<_TripCategorySpending>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripCategorySpendingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripCategorySpending&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,amount);

@override
String toString() {
  return 'TripCategorySpending(category: $category, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$TripCategorySpendingCopyWith<$Res> implements $TripCategorySpendingCopyWith<$Res> {
  factory _$TripCategorySpendingCopyWith(_TripCategorySpending value, $Res Function(_TripCategorySpending) _then) = __$TripCategorySpendingCopyWithImpl;
@override @useResult
$Res call({
 GroupExpenseCategory category,@AmountConverter() String amount
});




}
/// @nodoc
class __$TripCategorySpendingCopyWithImpl<$Res>
    implements _$TripCategorySpendingCopyWith<$Res> {
  __$TripCategorySpendingCopyWithImpl(this._self, this._then);

  final _TripCategorySpending _self;
  final $Res Function(_TripCategorySpending) _then;

/// Create a copy of TripCategorySpending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? amount = null,}) {
  return _then(_TripCategorySpending(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as GroupExpenseCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TripSummary {

@NullableAmountConverter() String? get budgetAmount;@AmountConverter() String get spent;@NullableAmountConverter() String? get remaining; List<TripCategorySpending> get spendingByCategory;
/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripSummaryCopyWith<TripSummary> get copyWith => _$TripSummaryCopyWithImpl<TripSummary>(this as TripSummary, _$identity);

  /// Serializes this TripSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripSummary&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&const DeepCollectionEquality().equals(other.spendingByCategory, spendingByCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,budgetAmount,spent,remaining,const DeepCollectionEquality().hash(spendingByCategory));

@override
String toString() {
  return 'TripSummary(budgetAmount: $budgetAmount, spent: $spent, remaining: $remaining, spendingByCategory: $spendingByCategory)';
}


}

/// @nodoc
abstract mixin class $TripSummaryCopyWith<$Res>  {
  factory $TripSummaryCopyWith(TripSummary value, $Res Function(TripSummary) _then) = _$TripSummaryCopyWithImpl;
@useResult
$Res call({
@NullableAmountConverter() String? budgetAmount,@AmountConverter() String spent,@NullableAmountConverter() String? remaining, List<TripCategorySpending> spendingByCategory
});




}
/// @nodoc
class _$TripSummaryCopyWithImpl<$Res>
    implements $TripSummaryCopyWith<$Res> {
  _$TripSummaryCopyWithImpl(this._self, this._then);

  final TripSummary _self;
  final $Res Function(TripSummary) _then;

/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? budgetAmount = freezed,Object? spent = null,Object? remaining = freezed,Object? spendingByCategory = null,}) {
  return _then(TripSummary(
budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as String?,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as String,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as String?,spendingByCategory: null == spendingByCategory ? _self.spendingByCategory : spendingByCategory // ignore: cast_nullable_to_non_nullable
as List<TripCategorySpending>,
  ));
}

}


/// Adds pattern-matching-related methods to [TripSummary].
extension TripSummaryPatterns on TripSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripSummary value)  $default,){
final _that = this;
switch (_that) {
case _TripSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@NullableAmountConverter()  String? budgetAmount, @AmountConverter()  String spent, @NullableAmountConverter()  String? remaining,  List<TripCategorySpending> spendingByCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
return $default(_that.budgetAmount,_that.spent,_that.remaining,_that.spendingByCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@NullableAmountConverter()  String? budgetAmount, @AmountConverter()  String spent, @NullableAmountConverter()  String? remaining,  List<TripCategorySpending> spendingByCategory)  $default,) {final _that = this;
switch (_that) {
case _TripSummary():
return $default(_that.budgetAmount,_that.spent,_that.remaining,_that.spendingByCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@NullableAmountConverter()  String? budgetAmount, @AmountConverter()  String spent, @NullableAmountConverter()  String? remaining,  List<TripCategorySpending> spendingByCategory)?  $default,) {final _that = this;
switch (_that) {
case _TripSummary() when $default != null:
return $default(_that.budgetAmount,_that.spent,_that.remaining,_that.spendingByCategory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripSummary implements TripSummary {
  const _TripSummary({@NullableAmountConverter() this.budgetAmount, @AmountConverter() required this.spent, @NullableAmountConverter() this.remaining, required  List<TripCategorySpending> spendingByCategory}): _spendingByCategory = spendingByCategory;
  factory _TripSummary.fromJson(Map<String, dynamic> json) => _$TripSummaryFromJson(json);

@override@NullableAmountConverter() final  String? budgetAmount;
@override@AmountConverter() final  String spent;
@override@NullableAmountConverter() final  String? remaining;
 final  List<TripCategorySpending> _spendingByCategory;
@override List<TripCategorySpending> get spendingByCategory {
  if (_spendingByCategory is EqualUnmodifiableListView) return _spendingByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spendingByCategory);
}


/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripSummaryCopyWith<_TripSummary> get copyWith => __$TripSummaryCopyWithImpl<_TripSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripSummary&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&const DeepCollectionEquality().equals(other._spendingByCategory, _spendingByCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,budgetAmount,spent,remaining,const DeepCollectionEquality().hash(_spendingByCategory));

@override
String toString() {
  return 'TripSummary(budgetAmount: $budgetAmount, spent: $spent, remaining: $remaining, spendingByCategory: $spendingByCategory)';
}


}

/// @nodoc
abstract mixin class _$TripSummaryCopyWith<$Res> implements $TripSummaryCopyWith<$Res> {
  factory _$TripSummaryCopyWith(_TripSummary value, $Res Function(_TripSummary) _then) = __$TripSummaryCopyWithImpl;
@override @useResult
$Res call({
@NullableAmountConverter() String? budgetAmount,@AmountConverter() String spent,@NullableAmountConverter() String? remaining, List<TripCategorySpending> spendingByCategory
});




}
/// @nodoc
class __$TripSummaryCopyWithImpl<$Res>
    implements _$TripSummaryCopyWith<$Res> {
  __$TripSummaryCopyWithImpl(this._self, this._then);

  final _TripSummary _self;
  final $Res Function(_TripSummary) _then;

/// Create a copy of TripSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? budgetAmount = freezed,Object? spent = null,Object? remaining = freezed,Object? spendingByCategory = null,}) {
  return _then(_TripSummary(
budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as String?,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as String,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as String?,spendingByCategory: null == spendingByCategory ? _self._spendingByCategory : spendingByCategory // ignore: cast_nullable_to_non_nullable
as List<TripCategorySpending>,
  ));
}


}


/// @nodoc
mixin _$HousemateCategoryStatus {

 GroupExpenseCategory get category; bool get paid;
/// Create a copy of HousemateCategoryStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HousemateCategoryStatusCopyWith<HousemateCategoryStatus> get copyWith => _$HousemateCategoryStatusCopyWithImpl<HousemateCategoryStatus>(this as HousemateCategoryStatus, _$identity);

  /// Serializes this HousemateCategoryStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HousemateCategoryStatus&&(identical(other.category, category) || other.category == category)&&(identical(other.paid, paid) || other.paid == paid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,paid);

@override
String toString() {
  return 'HousemateCategoryStatus(category: $category, paid: $paid)';
}


}

/// @nodoc
abstract mixin class $HousemateCategoryStatusCopyWith<$Res>  {
  factory $HousemateCategoryStatusCopyWith(HousemateCategoryStatus value, $Res Function(HousemateCategoryStatus) _then) = _$HousemateCategoryStatusCopyWithImpl;
@useResult
$Res call({
 GroupExpenseCategory category, bool paid
});




}
/// @nodoc
class _$HousemateCategoryStatusCopyWithImpl<$Res>
    implements $HousemateCategoryStatusCopyWith<$Res> {
  _$HousemateCategoryStatusCopyWithImpl(this._self, this._then);

  final HousemateCategoryStatus _self;
  final $Res Function(HousemateCategoryStatus) _then;

/// Create a copy of HousemateCategoryStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? paid = null,}) {
  return _then(HousemateCategoryStatus(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as GroupExpenseCategory,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HousemateCategoryStatus].
extension HousemateCategoryStatusPatterns on HousemateCategoryStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HousemateCategoryStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HousemateCategoryStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HousemateCategoryStatus value)  $default,){
final _that = this;
switch (_that) {
case _HousemateCategoryStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HousemateCategoryStatus value)?  $default,){
final _that = this;
switch (_that) {
case _HousemateCategoryStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GroupExpenseCategory category,  bool paid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HousemateCategoryStatus() when $default != null:
return $default(_that.category,_that.paid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GroupExpenseCategory category,  bool paid)  $default,) {final _that = this;
switch (_that) {
case _HousemateCategoryStatus():
return $default(_that.category,_that.paid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GroupExpenseCategory category,  bool paid)?  $default,) {final _that = this;
switch (_that) {
case _HousemateCategoryStatus() when $default != null:
return $default(_that.category,_that.paid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HousemateCategoryStatus implements HousemateCategoryStatus {
  const _HousemateCategoryStatus({required this.category, required this.paid});
  factory _HousemateCategoryStatus.fromJson(Map<String, dynamic> json) => _$HousemateCategoryStatusFromJson(json);

@override final  GroupExpenseCategory category;
@override final  bool paid;

/// Create a copy of HousemateCategoryStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HousemateCategoryStatusCopyWith<_HousemateCategoryStatus> get copyWith => __$HousemateCategoryStatusCopyWithImpl<_HousemateCategoryStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HousemateCategoryStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HousemateCategoryStatus&&(identical(other.category, category) || other.category == category)&&(identical(other.paid, paid) || other.paid == paid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,paid);

@override
String toString() {
  return 'HousemateCategoryStatus(category: $category, paid: $paid)';
}


}

/// @nodoc
abstract mixin class _$HousemateCategoryStatusCopyWith<$Res> implements $HousemateCategoryStatusCopyWith<$Res> {
  factory _$HousemateCategoryStatusCopyWith(_HousemateCategoryStatus value, $Res Function(_HousemateCategoryStatus) _then) = __$HousemateCategoryStatusCopyWithImpl;
@override @useResult
$Res call({
 GroupExpenseCategory category, bool paid
});




}
/// @nodoc
class __$HousemateCategoryStatusCopyWithImpl<$Res>
    implements _$HousemateCategoryStatusCopyWith<$Res> {
  __$HousemateCategoryStatusCopyWithImpl(this._self, this._then);

  final _HousemateCategoryStatus _self;
  final $Res Function(_HousemateCategoryStatus) _then;

/// Create a copy of HousemateCategoryStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? paid = null,}) {
  return _then(_HousemateCategoryStatus(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as GroupExpenseCategory,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$HousemateDashboard {

 int get year; int get month; List<HousemateCategoryStatus> get categories;
/// Create a copy of HousemateDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HousemateDashboardCopyWith<HousemateDashboard> get copyWith => _$HousemateDashboardCopyWithImpl<HousemateDashboard>(this as HousemateDashboard, _$identity);

  /// Serializes this HousemateDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HousemateDashboard&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'HousemateDashboard(year: $year, month: $month, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $HousemateDashboardCopyWith<$Res>  {
  factory $HousemateDashboardCopyWith(HousemateDashboard value, $Res Function(HousemateDashboard) _then) = _$HousemateDashboardCopyWithImpl;
@useResult
$Res call({
 int year, int month, List<HousemateCategoryStatus> categories
});




}
/// @nodoc
class _$HousemateDashboardCopyWithImpl<$Res>
    implements $HousemateDashboardCopyWith<$Res> {
  _$HousemateDashboardCopyWithImpl(this._self, this._then);

  final HousemateDashboard _self;
  final $Res Function(HousemateDashboard) _then;

/// Create a copy of HousemateDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? categories = null,}) {
  return _then(HousemateDashboard(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<HousemateCategoryStatus>,
  ));
}

}


/// Adds pattern-matching-related methods to [HousemateDashboard].
extension HousemateDashboardPatterns on HousemateDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HousemateDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HousemateDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HousemateDashboard value)  $default,){
final _that = this;
switch (_that) {
case _HousemateDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HousemateDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _HousemateDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  List<HousemateCategoryStatus> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HousemateDashboard() when $default != null:
return $default(_that.year,_that.month,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  List<HousemateCategoryStatus> categories)  $default,) {final _that = this;
switch (_that) {
case _HousemateDashboard():
return $default(_that.year,_that.month,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  List<HousemateCategoryStatus> categories)?  $default,) {final _that = this;
switch (_that) {
case _HousemateDashboard() when $default != null:
return $default(_that.year,_that.month,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HousemateDashboard implements HousemateDashboard {
  const _HousemateDashboard({required this.year, required this.month, required  List<HousemateCategoryStatus> categories}): _categories = categories;
  factory _HousemateDashboard.fromJson(Map<String, dynamic> json) => _$HousemateDashboardFromJson(json);

@override final  int year;
@override final  int month;
 final  List<HousemateCategoryStatus> _categories;
@override List<HousemateCategoryStatus> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of HousemateDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HousemateDashboardCopyWith<_HousemateDashboard> get copyWith => __$HousemateDashboardCopyWithImpl<_HousemateDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HousemateDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HousemateDashboard&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'HousemateDashboard(year: $year, month: $month, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$HousemateDashboardCopyWith<$Res> implements $HousemateDashboardCopyWith<$Res> {
  factory _$HousemateDashboardCopyWith(_HousemateDashboard value, $Res Function(_HousemateDashboard) _then) = __$HousemateDashboardCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, List<HousemateCategoryStatus> categories
});




}
/// @nodoc
class __$HousemateDashboardCopyWithImpl<$Res>
    implements _$HousemateDashboardCopyWith<$Res> {
  __$HousemateDashboardCopyWithImpl(this._self, this._then);

  final _HousemateDashboard _self;
  final $Res Function(_HousemateDashboard) _then;

/// Create a copy of HousemateDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? categories = null,}) {
  return _then(_HousemateDashboard(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<HousemateCategoryStatus>,
  ));
}


}

// dart format on
