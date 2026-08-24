// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_space.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialSpace {

 String get id; SpaceType get type; String get name; SpaceRole get yourRole; SpaceStatus get status;
/// Create a copy of FinancialSpace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialSpaceCopyWith<FinancialSpace> get copyWith => _$FinancialSpaceCopyWithImpl<FinancialSpace>(this as FinancialSpace, _$identity);

  /// Serializes this FinancialSpace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialSpace&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.yourRole, yourRole) || other.yourRole == yourRole)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,yourRole,status);

@override
String toString() {
  return 'FinancialSpace(id: $id, type: $type, name: $name, yourRole: $yourRole, status: $status)';
}


}

/// @nodoc
abstract mixin class $FinancialSpaceCopyWith<$Res>  {
  factory $FinancialSpaceCopyWith(FinancialSpace value, $Res Function(FinancialSpace) _then) = _$FinancialSpaceCopyWithImpl;
@useResult
$Res call({
 String id, SpaceType type, String name, SpaceRole yourRole, SpaceStatus status
});




}
/// @nodoc
class _$FinancialSpaceCopyWithImpl<$Res>
    implements $FinancialSpaceCopyWith<$Res> {
  _$FinancialSpaceCopyWithImpl(this._self, this._then);

  final FinancialSpace _self;
  final $Res Function(FinancialSpace) _then;

/// Create a copy of FinancialSpace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? yourRole = null,Object? status = null,}) {
  return _then(FinancialSpace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SpaceType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,yourRole: null == yourRole ? _self.yourRole : yourRole // ignore: cast_nullable_to_non_nullable
as SpaceRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpaceStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialSpace].
extension FinancialSpacePatterns on FinancialSpace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialSpace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialSpace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialSpace value)  $default,){
final _that = this;
switch (_that) {
case _FinancialSpace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialSpace value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialSpace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SpaceType type,  String name,  SpaceRole yourRole,  SpaceStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialSpace() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.yourRole,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SpaceType type,  String name,  SpaceRole yourRole,  SpaceStatus status)  $default,) {final _that = this;
switch (_that) {
case _FinancialSpace():
return $default(_that.id,_that.type,_that.name,_that.yourRole,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SpaceType type,  String name,  SpaceRole yourRole,  SpaceStatus status)?  $default,) {final _that = this;
switch (_that) {
case _FinancialSpace() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.yourRole,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialSpace implements FinancialSpace {
  const _FinancialSpace({required this.id, required this.type, required this.name, required this.yourRole, required this.status});
  factory _FinancialSpace.fromJson(Map<String, dynamic> json) => _$FinancialSpaceFromJson(json);

@override final  String id;
@override final  SpaceType type;
@override final  String name;
@override final  SpaceRole yourRole;
@override final  SpaceStatus status;

/// Create a copy of FinancialSpace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialSpaceCopyWith<_FinancialSpace> get copyWith => __$FinancialSpaceCopyWithImpl<_FinancialSpace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialSpaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialSpace&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.yourRole, yourRole) || other.yourRole == yourRole)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,yourRole,status);

@override
String toString() {
  return 'FinancialSpace(id: $id, type: $type, name: $name, yourRole: $yourRole, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FinancialSpaceCopyWith<$Res> implements $FinancialSpaceCopyWith<$Res> {
  factory _$FinancialSpaceCopyWith(_FinancialSpace value, $Res Function(_FinancialSpace) _then) = __$FinancialSpaceCopyWithImpl;
@override @useResult
$Res call({
 String id, SpaceType type, String name, SpaceRole yourRole, SpaceStatus status
});




}
/// @nodoc
class __$FinancialSpaceCopyWithImpl<$Res>
    implements _$FinancialSpaceCopyWith<$Res> {
  __$FinancialSpaceCopyWithImpl(this._self, this._then);

  final _FinancialSpace _self;
  final $Res Function(_FinancialSpace) _then;

/// Create a copy of FinancialSpace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? yourRole = null,Object? status = null,}) {
  return _then(_FinancialSpace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SpaceType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,yourRole: null == yourRole ? _self.yourRole : yourRole // ignore: cast_nullable_to_non_nullable
as SpaceRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpaceStatus,
  ));
}


}


/// @nodoc
mixin _$BusinessProfile {

 String get spaceId; String get legalName; String? get tradeName; String? get registrationNumber; String? get tin; String? get businessType; String? get industry; String? get sstNumber; String? get financialYearStart; String? get financialYearEnd; String? get address; String? get phone; String? get email; String get currency;@NullableAmountConverter() String? get annualRevenue;
/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProfileCopyWith<BusinessProfile> get copyWith => _$BusinessProfileCopyWithImpl<BusinessProfile>(this as BusinessProfile, _$identity);

  /// Serializes this BusinessProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProfile&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.tradeName, tradeName) || other.tradeName == tradeName)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.tin, tin) || other.tin == tin)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.sstNumber, sstNumber) || other.sstNumber == sstNumber)&&(identical(other.financialYearStart, financialYearStart) || other.financialYearStart == financialYearStart)&&(identical(other.financialYearEnd, financialYearEnd) || other.financialYearEnd == financialYearEnd)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.annualRevenue, annualRevenue) || other.annualRevenue == annualRevenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spaceId,legalName,tradeName,registrationNumber,tin,businessType,industry,sstNumber,financialYearStart,financialYearEnd,address,phone,email,currency,annualRevenue);

@override
String toString() {
  return 'BusinessProfile(spaceId: $spaceId, legalName: $legalName, tradeName: $tradeName, registrationNumber: $registrationNumber, tin: $tin, businessType: $businessType, industry: $industry, sstNumber: $sstNumber, financialYearStart: $financialYearStart, financialYearEnd: $financialYearEnd, address: $address, phone: $phone, email: $email, currency: $currency, annualRevenue: $annualRevenue)';
}


}

/// @nodoc
abstract mixin class $BusinessProfileCopyWith<$Res>  {
  factory $BusinessProfileCopyWith(BusinessProfile value, $Res Function(BusinessProfile) _then) = _$BusinessProfileCopyWithImpl;
@useResult
$Res call({
 String spaceId, String legalName, String? tradeName, String? registrationNumber, String? tin, String? businessType, String? industry, String? sstNumber, String? financialYearStart, String? financialYearEnd, String? address, String? phone, String? email, String currency,@NullableAmountConverter() String? annualRevenue
});




}
/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._self, this._then);

  final BusinessProfile _self;
  final $Res Function(BusinessProfile) _then;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spaceId = null,Object? legalName = null,Object? tradeName = freezed,Object? registrationNumber = freezed,Object? tin = freezed,Object? businessType = freezed,Object? industry = freezed,Object? sstNumber = freezed,Object? financialYearStart = freezed,Object? financialYearEnd = freezed,Object? address = freezed,Object? phone = freezed,Object? email = freezed,Object? currency = null,Object? annualRevenue = freezed,}) {
  return _then(BusinessProfile(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,tradeName: freezed == tradeName ? _self.tradeName : tradeName // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,tin: freezed == tin ? _self.tin : tin // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,sstNumber: freezed == sstNumber ? _self.sstNumber : sstNumber // ignore: cast_nullable_to_non_nullable
as String?,financialYearStart: freezed == financialYearStart ? _self.financialYearStart : financialYearStart // ignore: cast_nullable_to_non_nullable
as String?,financialYearEnd: freezed == financialYearEnd ? _self.financialYearEnd : financialYearEnd // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,annualRevenue: freezed == annualRevenue ? _self.annualRevenue : annualRevenue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessProfile].
extension BusinessProfilePatterns on BusinessProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProfile value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProfile value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spaceId,  String legalName,  String? tradeName,  String? registrationNumber,  String? tin,  String? businessType,  String? industry,  String? sstNumber,  String? financialYearStart,  String? financialYearEnd,  String? address,  String? phone,  String? email,  String currency, @NullableAmountConverter()  String? annualRevenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
return $default(_that.spaceId,_that.legalName,_that.tradeName,_that.registrationNumber,_that.tin,_that.businessType,_that.industry,_that.sstNumber,_that.financialYearStart,_that.financialYearEnd,_that.address,_that.phone,_that.email,_that.currency,_that.annualRevenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spaceId,  String legalName,  String? tradeName,  String? registrationNumber,  String? tin,  String? businessType,  String? industry,  String? sstNumber,  String? financialYearStart,  String? financialYearEnd,  String? address,  String? phone,  String? email,  String currency, @NullableAmountConverter()  String? annualRevenue)  $default,) {final _that = this;
switch (_that) {
case _BusinessProfile():
return $default(_that.spaceId,_that.legalName,_that.tradeName,_that.registrationNumber,_that.tin,_that.businessType,_that.industry,_that.sstNumber,_that.financialYearStart,_that.financialYearEnd,_that.address,_that.phone,_that.email,_that.currency,_that.annualRevenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spaceId,  String legalName,  String? tradeName,  String? registrationNumber,  String? tin,  String? businessType,  String? industry,  String? sstNumber,  String? financialYearStart,  String? financialYearEnd,  String? address,  String? phone,  String? email,  String currency, @NullableAmountConverter()  String? annualRevenue)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
return $default(_that.spaceId,_that.legalName,_that.tradeName,_that.registrationNumber,_that.tin,_that.businessType,_that.industry,_that.sstNumber,_that.financialYearStart,_that.financialYearEnd,_that.address,_that.phone,_that.email,_that.currency,_that.annualRevenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessProfile implements BusinessProfile {
  const _BusinessProfile({required this.spaceId, required this.legalName, this.tradeName, this.registrationNumber, this.tin, this.businessType, this.industry, this.sstNumber, this.financialYearStart, this.financialYearEnd, this.address, this.phone, this.email, required this.currency, @NullableAmountConverter() this.annualRevenue});
  factory _BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);

@override final  String spaceId;
@override final  String legalName;
@override final  String? tradeName;
@override final  String? registrationNumber;
@override final  String? tin;
@override final  String? businessType;
@override final  String? industry;
@override final  String? sstNumber;
@override final  String? financialYearStart;
@override final  String? financialYearEnd;
@override final  String? address;
@override final  String? phone;
@override final  String? email;
@override final  String currency;
@override@NullableAmountConverter() final  String? annualRevenue;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProfileCopyWith<_BusinessProfile> get copyWith => __$BusinessProfileCopyWithImpl<_BusinessProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProfile&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.tradeName, tradeName) || other.tradeName == tradeName)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.tin, tin) || other.tin == tin)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.sstNumber, sstNumber) || other.sstNumber == sstNumber)&&(identical(other.financialYearStart, financialYearStart) || other.financialYearStart == financialYearStart)&&(identical(other.financialYearEnd, financialYearEnd) || other.financialYearEnd == financialYearEnd)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.annualRevenue, annualRevenue) || other.annualRevenue == annualRevenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spaceId,legalName,tradeName,registrationNumber,tin,businessType,industry,sstNumber,financialYearStart,financialYearEnd,address,phone,email,currency,annualRevenue);

@override
String toString() {
  return 'BusinessProfile(spaceId: $spaceId, legalName: $legalName, tradeName: $tradeName, registrationNumber: $registrationNumber, tin: $tin, businessType: $businessType, industry: $industry, sstNumber: $sstNumber, financialYearStart: $financialYearStart, financialYearEnd: $financialYearEnd, address: $address, phone: $phone, email: $email, currency: $currency, annualRevenue: $annualRevenue)';
}


}

/// @nodoc
abstract mixin class _$BusinessProfileCopyWith<$Res> implements $BusinessProfileCopyWith<$Res> {
  factory _$BusinessProfileCopyWith(_BusinessProfile value, $Res Function(_BusinessProfile) _then) = __$BusinessProfileCopyWithImpl;
@override @useResult
$Res call({
 String spaceId, String legalName, String? tradeName, String? registrationNumber, String? tin, String? businessType, String? industry, String? sstNumber, String? financialYearStart, String? financialYearEnd, String? address, String? phone, String? email, String currency,@NullableAmountConverter() String? annualRevenue
});




}
/// @nodoc
class __$BusinessProfileCopyWithImpl<$Res>
    implements _$BusinessProfileCopyWith<$Res> {
  __$BusinessProfileCopyWithImpl(this._self, this._then);

  final _BusinessProfile _self;
  final $Res Function(_BusinessProfile) _then;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spaceId = null,Object? legalName = null,Object? tradeName = freezed,Object? registrationNumber = freezed,Object? tin = freezed,Object? businessType = freezed,Object? industry = freezed,Object? sstNumber = freezed,Object? financialYearStart = freezed,Object? financialYearEnd = freezed,Object? address = freezed,Object? phone = freezed,Object? email = freezed,Object? currency = null,Object? annualRevenue = freezed,}) {
  return _then(_BusinessProfile(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,tradeName: freezed == tradeName ? _self.tradeName : tradeName // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,tin: freezed == tin ? _self.tin : tin // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,sstNumber: freezed == sstNumber ? _self.sstNumber : sstNumber // ignore: cast_nullable_to_non_nullable
as String?,financialYearStart: freezed == financialYearStart ? _self.financialYearStart : financialYearStart // ignore: cast_nullable_to_non_nullable
as String?,financialYearEnd: freezed == financialYearEnd ? _self.financialYearEnd : financialYearEnd // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,annualRevenue: freezed == annualRevenue ? _self.annualRevenue : annualRevenue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
