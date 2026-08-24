// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cross_space.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CrossSpaceLinkResponse {

 String get id; String get businessSpaceId; CrossSpaceLinkType get linkType; String get personalTransactionId; String? get businessJournalEntryId; String? get relatedLinkId;@AmountConverter() String get amount; String? get description; String get createdAt;
/// Create a copy of CrossSpaceLinkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossSpaceLinkResponseCopyWith<CrossSpaceLinkResponse> get copyWith => _$CrossSpaceLinkResponseCopyWithImpl<CrossSpaceLinkResponse>(this as CrossSpaceLinkResponse, _$identity);

  /// Serializes this CrossSpaceLinkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossSpaceLinkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.businessSpaceId, businessSpaceId) || other.businessSpaceId == businessSpaceId)&&(identical(other.linkType, linkType) || other.linkType == linkType)&&(identical(other.personalTransactionId, personalTransactionId) || other.personalTransactionId == personalTransactionId)&&(identical(other.businessJournalEntryId, businessJournalEntryId) || other.businessJournalEntryId == businessJournalEntryId)&&(identical(other.relatedLinkId, relatedLinkId) || other.relatedLinkId == relatedLinkId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessSpaceId,linkType,personalTransactionId,businessJournalEntryId,relatedLinkId,amount,description,createdAt);

@override
String toString() {
  return 'CrossSpaceLinkResponse(id: $id, businessSpaceId: $businessSpaceId, linkType: $linkType, personalTransactionId: $personalTransactionId, businessJournalEntryId: $businessJournalEntryId, relatedLinkId: $relatedLinkId, amount: $amount, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CrossSpaceLinkResponseCopyWith<$Res>  {
  factory $CrossSpaceLinkResponseCopyWith(CrossSpaceLinkResponse value, $Res Function(CrossSpaceLinkResponse) _then) = _$CrossSpaceLinkResponseCopyWithImpl;
@useResult
$Res call({
 String id, String businessSpaceId, CrossSpaceLinkType linkType, String personalTransactionId, String? businessJournalEntryId, String? relatedLinkId,@AmountConverter() String amount, String? description, String createdAt
});




}
/// @nodoc
class _$CrossSpaceLinkResponseCopyWithImpl<$Res>
    implements $CrossSpaceLinkResponseCopyWith<$Res> {
  _$CrossSpaceLinkResponseCopyWithImpl(this._self, this._then);

  final CrossSpaceLinkResponse _self;
  final $Res Function(CrossSpaceLinkResponse) _then;

/// Create a copy of CrossSpaceLinkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessSpaceId = null,Object? linkType = null,Object? personalTransactionId = null,Object? businessJournalEntryId = freezed,Object? relatedLinkId = freezed,Object? amount = null,Object? description = freezed,Object? createdAt = null,}) {
  return _then(CrossSpaceLinkResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessSpaceId: null == businessSpaceId ? _self.businessSpaceId : businessSpaceId // ignore: cast_nullable_to_non_nullable
as String,linkType: null == linkType ? _self.linkType : linkType // ignore: cast_nullable_to_non_nullable
as CrossSpaceLinkType,personalTransactionId: null == personalTransactionId ? _self.personalTransactionId : personalTransactionId // ignore: cast_nullable_to_non_nullable
as String,businessJournalEntryId: freezed == businessJournalEntryId ? _self.businessJournalEntryId : businessJournalEntryId // ignore: cast_nullable_to_non_nullable
as String?,relatedLinkId: freezed == relatedLinkId ? _self.relatedLinkId : relatedLinkId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossSpaceLinkResponse].
extension CrossSpaceLinkResponsePatterns on CrossSpaceLinkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossSpaceLinkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossSpaceLinkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossSpaceLinkResponse value)  $default,){
final _that = this;
switch (_that) {
case _CrossSpaceLinkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossSpaceLinkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CrossSpaceLinkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessSpaceId,  CrossSpaceLinkType linkType,  String personalTransactionId,  String? businessJournalEntryId,  String? relatedLinkId, @AmountConverter()  String amount,  String? description,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossSpaceLinkResponse() when $default != null:
return $default(_that.id,_that.businessSpaceId,_that.linkType,_that.personalTransactionId,_that.businessJournalEntryId,_that.relatedLinkId,_that.amount,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessSpaceId,  CrossSpaceLinkType linkType,  String personalTransactionId,  String? businessJournalEntryId,  String? relatedLinkId, @AmountConverter()  String amount,  String? description,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _CrossSpaceLinkResponse():
return $default(_that.id,_that.businessSpaceId,_that.linkType,_that.personalTransactionId,_that.businessJournalEntryId,_that.relatedLinkId,_that.amount,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessSpaceId,  CrossSpaceLinkType linkType,  String personalTransactionId,  String? businessJournalEntryId,  String? relatedLinkId, @AmountConverter()  String amount,  String? description,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CrossSpaceLinkResponse() when $default != null:
return $default(_that.id,_that.businessSpaceId,_that.linkType,_that.personalTransactionId,_that.businessJournalEntryId,_that.relatedLinkId,_that.amount,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossSpaceLinkResponse implements CrossSpaceLinkResponse {
  const _CrossSpaceLinkResponse({required this.id, required this.businessSpaceId, required this.linkType, required this.personalTransactionId, this.businessJournalEntryId, this.relatedLinkId, @AmountConverter() required this.amount, this.description, required this.createdAt});
  factory _CrossSpaceLinkResponse.fromJson(Map<String, dynamic> json) => _$CrossSpaceLinkResponseFromJson(json);

@override final  String id;
@override final  String businessSpaceId;
@override final  CrossSpaceLinkType linkType;
@override final  String personalTransactionId;
@override final  String? businessJournalEntryId;
@override final  String? relatedLinkId;
@override@AmountConverter() final  String amount;
@override final  String? description;
@override final  String createdAt;

/// Create a copy of CrossSpaceLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossSpaceLinkResponseCopyWith<_CrossSpaceLinkResponse> get copyWith => __$CrossSpaceLinkResponseCopyWithImpl<_CrossSpaceLinkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossSpaceLinkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossSpaceLinkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.businessSpaceId, businessSpaceId) || other.businessSpaceId == businessSpaceId)&&(identical(other.linkType, linkType) || other.linkType == linkType)&&(identical(other.personalTransactionId, personalTransactionId) || other.personalTransactionId == personalTransactionId)&&(identical(other.businessJournalEntryId, businessJournalEntryId) || other.businessJournalEntryId == businessJournalEntryId)&&(identical(other.relatedLinkId, relatedLinkId) || other.relatedLinkId == relatedLinkId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessSpaceId,linkType,personalTransactionId,businessJournalEntryId,relatedLinkId,amount,description,createdAt);

@override
String toString() {
  return 'CrossSpaceLinkResponse(id: $id, businessSpaceId: $businessSpaceId, linkType: $linkType, personalTransactionId: $personalTransactionId, businessJournalEntryId: $businessJournalEntryId, relatedLinkId: $relatedLinkId, amount: $amount, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CrossSpaceLinkResponseCopyWith<$Res> implements $CrossSpaceLinkResponseCopyWith<$Res> {
  factory _$CrossSpaceLinkResponseCopyWith(_CrossSpaceLinkResponse value, $Res Function(_CrossSpaceLinkResponse) _then) = __$CrossSpaceLinkResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessSpaceId, CrossSpaceLinkType linkType, String personalTransactionId, String? businessJournalEntryId, String? relatedLinkId,@AmountConverter() String amount, String? description, String createdAt
});




}
/// @nodoc
class __$CrossSpaceLinkResponseCopyWithImpl<$Res>
    implements _$CrossSpaceLinkResponseCopyWith<$Res> {
  __$CrossSpaceLinkResponseCopyWithImpl(this._self, this._then);

  final _CrossSpaceLinkResponse _self;
  final $Res Function(_CrossSpaceLinkResponse) _then;

/// Create a copy of CrossSpaceLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessSpaceId = null,Object? linkType = null,Object? personalTransactionId = null,Object? businessJournalEntryId = freezed,Object? relatedLinkId = freezed,Object? amount = null,Object? description = freezed,Object? createdAt = null,}) {
  return _then(_CrossSpaceLinkResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessSpaceId: null == businessSpaceId ? _self.businessSpaceId : businessSpaceId // ignore: cast_nullable_to_non_nullable
as String,linkType: null == linkType ? _self.linkType : linkType // ignore: cast_nullable_to_non_nullable
as CrossSpaceLinkType,personalTransactionId: null == personalTransactionId ? _self.personalTransactionId : personalTransactionId // ignore: cast_nullable_to_non_nullable
as String,businessJournalEntryId: freezed == businessJournalEntryId ? _self.businessJournalEntryId : businessJournalEntryId // ignore: cast_nullable_to_non_nullable
as String?,relatedLinkId: freezed == relatedLinkId ? _self.relatedLinkId : relatedLinkId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BusinessOwnershipLine {

 String get spaceId; String get spaceName;@AmountConverter() String get equityValue;
/// Create a copy of BusinessOwnershipLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessOwnershipLineCopyWith<BusinessOwnershipLine> get copyWith => _$BusinessOwnershipLineCopyWithImpl<BusinessOwnershipLine>(this as BusinessOwnershipLine, _$identity);

  /// Serializes this BusinessOwnershipLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessOwnershipLine&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.spaceName, spaceName) || other.spaceName == spaceName)&&(identical(other.equityValue, equityValue) || other.equityValue == equityValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spaceId,spaceName,equityValue);

@override
String toString() {
  return 'BusinessOwnershipLine(spaceId: $spaceId, spaceName: $spaceName, equityValue: $equityValue)';
}


}

/// @nodoc
abstract mixin class $BusinessOwnershipLineCopyWith<$Res>  {
  factory $BusinessOwnershipLineCopyWith(BusinessOwnershipLine value, $Res Function(BusinessOwnershipLine) _then) = _$BusinessOwnershipLineCopyWithImpl;
@useResult
$Res call({
 String spaceId, String spaceName,@AmountConverter() String equityValue
});




}
/// @nodoc
class _$BusinessOwnershipLineCopyWithImpl<$Res>
    implements $BusinessOwnershipLineCopyWith<$Res> {
  _$BusinessOwnershipLineCopyWithImpl(this._self, this._then);

  final BusinessOwnershipLine _self;
  final $Res Function(BusinessOwnershipLine) _then;

/// Create a copy of BusinessOwnershipLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spaceId = null,Object? spaceName = null,Object? equityValue = null,}) {
  return _then(BusinessOwnershipLine(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,spaceName: null == spaceName ? _self.spaceName : spaceName // ignore: cast_nullable_to_non_nullable
as String,equityValue: null == equityValue ? _self.equityValue : equityValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessOwnershipLine].
extension BusinessOwnershipLinePatterns on BusinessOwnershipLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessOwnershipLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessOwnershipLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessOwnershipLine value)  $default,){
final _that = this;
switch (_that) {
case _BusinessOwnershipLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessOwnershipLine value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessOwnershipLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spaceId,  String spaceName, @AmountConverter()  String equityValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessOwnershipLine() when $default != null:
return $default(_that.spaceId,_that.spaceName,_that.equityValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spaceId,  String spaceName, @AmountConverter()  String equityValue)  $default,) {final _that = this;
switch (_that) {
case _BusinessOwnershipLine():
return $default(_that.spaceId,_that.spaceName,_that.equityValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spaceId,  String spaceName, @AmountConverter()  String equityValue)?  $default,) {final _that = this;
switch (_that) {
case _BusinessOwnershipLine() when $default != null:
return $default(_that.spaceId,_that.spaceName,_that.equityValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessOwnershipLine implements BusinessOwnershipLine {
  const _BusinessOwnershipLine({required this.spaceId, required this.spaceName, @AmountConverter() required this.equityValue});
  factory _BusinessOwnershipLine.fromJson(Map<String, dynamic> json) => _$BusinessOwnershipLineFromJson(json);

@override final  String spaceId;
@override final  String spaceName;
@override@AmountConverter() final  String equityValue;

/// Create a copy of BusinessOwnershipLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessOwnershipLineCopyWith<_BusinessOwnershipLine> get copyWith => __$BusinessOwnershipLineCopyWithImpl<_BusinessOwnershipLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessOwnershipLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessOwnershipLine&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.spaceName, spaceName) || other.spaceName == spaceName)&&(identical(other.equityValue, equityValue) || other.equityValue == equityValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spaceId,spaceName,equityValue);

@override
String toString() {
  return 'BusinessOwnershipLine(spaceId: $spaceId, spaceName: $spaceName, equityValue: $equityValue)';
}


}

/// @nodoc
abstract mixin class _$BusinessOwnershipLineCopyWith<$Res> implements $BusinessOwnershipLineCopyWith<$Res> {
  factory _$BusinessOwnershipLineCopyWith(_BusinessOwnershipLine value, $Res Function(_BusinessOwnershipLine) _then) = __$BusinessOwnershipLineCopyWithImpl;
@override @useResult
$Res call({
 String spaceId, String spaceName,@AmountConverter() String equityValue
});




}
/// @nodoc
class __$BusinessOwnershipLineCopyWithImpl<$Res>
    implements _$BusinessOwnershipLineCopyWith<$Res> {
  __$BusinessOwnershipLineCopyWithImpl(this._self, this._then);

  final _BusinessOwnershipLine _self;
  final $Res Function(_BusinessOwnershipLine) _then;

/// Create a copy of BusinessOwnershipLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spaceId = null,Object? spaceName = null,Object? equityValue = null,}) {
  return _then(_BusinessOwnershipLine(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,spaceName: null == spaceName ? _self.spaceName : spaceName // ignore: cast_nullable_to_non_nullable
as String,equityValue: null == equityValue ? _self.equityValue : equityValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CombinedNetWorth {

@AmountConverter() String get personalNetWorth; List<BusinessOwnershipLine> get businessOwnership;@AmountConverter() String get totalBusinessOwnershipValue;@AmountConverter() String get estimatedTotalNetWorth;
/// Create a copy of CombinedNetWorth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombinedNetWorthCopyWith<CombinedNetWorth> get copyWith => _$CombinedNetWorthCopyWithImpl<CombinedNetWorth>(this as CombinedNetWorth, _$identity);

  /// Serializes this CombinedNetWorth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombinedNetWorth&&(identical(other.personalNetWorth, personalNetWorth) || other.personalNetWorth == personalNetWorth)&&const DeepCollectionEquality().equals(other.businessOwnership, businessOwnership)&&(identical(other.totalBusinessOwnershipValue, totalBusinessOwnershipValue) || other.totalBusinessOwnershipValue == totalBusinessOwnershipValue)&&(identical(other.estimatedTotalNetWorth, estimatedTotalNetWorth) || other.estimatedTotalNetWorth == estimatedTotalNetWorth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personalNetWorth,const DeepCollectionEquality().hash(businessOwnership),totalBusinessOwnershipValue,estimatedTotalNetWorth);

@override
String toString() {
  return 'CombinedNetWorth(personalNetWorth: $personalNetWorth, businessOwnership: $businessOwnership, totalBusinessOwnershipValue: $totalBusinessOwnershipValue, estimatedTotalNetWorth: $estimatedTotalNetWorth)';
}


}

/// @nodoc
abstract mixin class $CombinedNetWorthCopyWith<$Res>  {
  factory $CombinedNetWorthCopyWith(CombinedNetWorth value, $Res Function(CombinedNetWorth) _then) = _$CombinedNetWorthCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String personalNetWorth, List<BusinessOwnershipLine> businessOwnership,@AmountConverter() String totalBusinessOwnershipValue,@AmountConverter() String estimatedTotalNetWorth
});




}
/// @nodoc
class _$CombinedNetWorthCopyWithImpl<$Res>
    implements $CombinedNetWorthCopyWith<$Res> {
  _$CombinedNetWorthCopyWithImpl(this._self, this._then);

  final CombinedNetWorth _self;
  final $Res Function(CombinedNetWorth) _then;

/// Create a copy of CombinedNetWorth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personalNetWorth = null,Object? businessOwnership = null,Object? totalBusinessOwnershipValue = null,Object? estimatedTotalNetWorth = null,}) {
  return _then(CombinedNetWorth(
personalNetWorth: null == personalNetWorth ? _self.personalNetWorth : personalNetWorth // ignore: cast_nullable_to_non_nullable
as String,businessOwnership: null == businessOwnership ? _self.businessOwnership : businessOwnership // ignore: cast_nullable_to_non_nullable
as List<BusinessOwnershipLine>,totalBusinessOwnershipValue: null == totalBusinessOwnershipValue ? _self.totalBusinessOwnershipValue : totalBusinessOwnershipValue // ignore: cast_nullable_to_non_nullable
as String,estimatedTotalNetWorth: null == estimatedTotalNetWorth ? _self.estimatedTotalNetWorth : estimatedTotalNetWorth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CombinedNetWorth].
extension CombinedNetWorthPatterns on CombinedNetWorth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CombinedNetWorth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CombinedNetWorth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CombinedNetWorth value)  $default,){
final _that = this;
switch (_that) {
case _CombinedNetWorth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CombinedNetWorth value)?  $default,){
final _that = this;
switch (_that) {
case _CombinedNetWorth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String personalNetWorth,  List<BusinessOwnershipLine> businessOwnership, @AmountConverter()  String totalBusinessOwnershipValue, @AmountConverter()  String estimatedTotalNetWorth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CombinedNetWorth() when $default != null:
return $default(_that.personalNetWorth,_that.businessOwnership,_that.totalBusinessOwnershipValue,_that.estimatedTotalNetWorth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String personalNetWorth,  List<BusinessOwnershipLine> businessOwnership, @AmountConverter()  String totalBusinessOwnershipValue, @AmountConverter()  String estimatedTotalNetWorth)  $default,) {final _that = this;
switch (_that) {
case _CombinedNetWorth():
return $default(_that.personalNetWorth,_that.businessOwnership,_that.totalBusinessOwnershipValue,_that.estimatedTotalNetWorth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String personalNetWorth,  List<BusinessOwnershipLine> businessOwnership, @AmountConverter()  String totalBusinessOwnershipValue, @AmountConverter()  String estimatedTotalNetWorth)?  $default,) {final _that = this;
switch (_that) {
case _CombinedNetWorth() when $default != null:
return $default(_that.personalNetWorth,_that.businessOwnership,_that.totalBusinessOwnershipValue,_that.estimatedTotalNetWorth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CombinedNetWorth implements CombinedNetWorth {
  const _CombinedNetWorth({@AmountConverter() required this.personalNetWorth, required  List<BusinessOwnershipLine> businessOwnership, @AmountConverter() required this.totalBusinessOwnershipValue, @AmountConverter() required this.estimatedTotalNetWorth}): _businessOwnership = businessOwnership;
  factory _CombinedNetWorth.fromJson(Map<String, dynamic> json) => _$CombinedNetWorthFromJson(json);

@override@AmountConverter() final  String personalNetWorth;
 final  List<BusinessOwnershipLine> _businessOwnership;
@override List<BusinessOwnershipLine> get businessOwnership {
  if (_businessOwnership is EqualUnmodifiableListView) return _businessOwnership;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_businessOwnership);
}

@override@AmountConverter() final  String totalBusinessOwnershipValue;
@override@AmountConverter() final  String estimatedTotalNetWorth;

/// Create a copy of CombinedNetWorth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CombinedNetWorthCopyWith<_CombinedNetWorth> get copyWith => __$CombinedNetWorthCopyWithImpl<_CombinedNetWorth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CombinedNetWorthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CombinedNetWorth&&(identical(other.personalNetWorth, personalNetWorth) || other.personalNetWorth == personalNetWorth)&&const DeepCollectionEquality().equals(other._businessOwnership, _businessOwnership)&&(identical(other.totalBusinessOwnershipValue, totalBusinessOwnershipValue) || other.totalBusinessOwnershipValue == totalBusinessOwnershipValue)&&(identical(other.estimatedTotalNetWorth, estimatedTotalNetWorth) || other.estimatedTotalNetWorth == estimatedTotalNetWorth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personalNetWorth,const DeepCollectionEquality().hash(_businessOwnership),totalBusinessOwnershipValue,estimatedTotalNetWorth);

@override
String toString() {
  return 'CombinedNetWorth(personalNetWorth: $personalNetWorth, businessOwnership: $businessOwnership, totalBusinessOwnershipValue: $totalBusinessOwnershipValue, estimatedTotalNetWorth: $estimatedTotalNetWorth)';
}


}

/// @nodoc
abstract mixin class _$CombinedNetWorthCopyWith<$Res> implements $CombinedNetWorthCopyWith<$Res> {
  factory _$CombinedNetWorthCopyWith(_CombinedNetWorth value, $Res Function(_CombinedNetWorth) _then) = __$CombinedNetWorthCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String personalNetWorth, List<BusinessOwnershipLine> businessOwnership,@AmountConverter() String totalBusinessOwnershipValue,@AmountConverter() String estimatedTotalNetWorth
});




}
/// @nodoc
class __$CombinedNetWorthCopyWithImpl<$Res>
    implements _$CombinedNetWorthCopyWith<$Res> {
  __$CombinedNetWorthCopyWithImpl(this._self, this._then);

  final _CombinedNetWorth _self;
  final $Res Function(_CombinedNetWorth) _then;

/// Create a copy of CombinedNetWorth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personalNetWorth = null,Object? businessOwnership = null,Object? totalBusinessOwnershipValue = null,Object? estimatedTotalNetWorth = null,}) {
  return _then(_CombinedNetWorth(
personalNetWorth: null == personalNetWorth ? _self.personalNetWorth : personalNetWorth // ignore: cast_nullable_to_non_nullable
as String,businessOwnership: null == businessOwnership ? _self._businessOwnership : businessOwnership // ignore: cast_nullable_to_non_nullable
as List<BusinessOwnershipLine>,totalBusinessOwnershipValue: null == totalBusinessOwnershipValue ? _self.totalBusinessOwnershipValue : totalBusinessOwnershipValue // ignore: cast_nullable_to_non_nullable
as String,estimatedTotalNetWorth: null == estimatedTotalNetWorth ? _self.estimatedTotalNetWorth : estimatedTotalNetWorth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
