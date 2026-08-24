// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FixedAssetResponse {

 String get id; String get name; String? get category; String get acquisitionDate;@AmountConverter() String get cost;@AmountConverter() String get salvageValue; int get usefulLifeMonths; DepreciationMethod get depreciationMethod; FixedAssetStatus get status; String? get disposedOn;@NullableAmountConverter() String? get disposalProceeds;@AmountConverter() String get accumulatedDepreciation;@AmountConverter() String get netBookValue;
/// Create a copy of FixedAssetResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixedAssetResponseCopyWith<FixedAssetResponse> get copyWith => _$FixedAssetResponseCopyWithImpl<FixedAssetResponse>(this as FixedAssetResponse, _$identity);

  /// Serializes this FixedAssetResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FixedAssetResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.acquisitionDate, acquisitionDate) || other.acquisitionDate == acquisitionDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.salvageValue, salvageValue) || other.salvageValue == salvageValue)&&(identical(other.usefulLifeMonths, usefulLifeMonths) || other.usefulLifeMonths == usefulLifeMonths)&&(identical(other.depreciationMethod, depreciationMethod) || other.depreciationMethod == depreciationMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.disposedOn, disposedOn) || other.disposedOn == disposedOn)&&(identical(other.disposalProceeds, disposalProceeds) || other.disposalProceeds == disposalProceeds)&&(identical(other.accumulatedDepreciation, accumulatedDepreciation) || other.accumulatedDepreciation == accumulatedDepreciation)&&(identical(other.netBookValue, netBookValue) || other.netBookValue == netBookValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,acquisitionDate,cost,salvageValue,usefulLifeMonths,depreciationMethod,status,disposedOn,disposalProceeds,accumulatedDepreciation,netBookValue);

@override
String toString() {
  return 'FixedAssetResponse(id: $id, name: $name, category: $category, acquisitionDate: $acquisitionDate, cost: $cost, salvageValue: $salvageValue, usefulLifeMonths: $usefulLifeMonths, depreciationMethod: $depreciationMethod, status: $status, disposedOn: $disposedOn, disposalProceeds: $disposalProceeds, accumulatedDepreciation: $accumulatedDepreciation, netBookValue: $netBookValue)';
}


}

/// @nodoc
abstract mixin class $FixedAssetResponseCopyWith<$Res>  {
  factory $FixedAssetResponseCopyWith(FixedAssetResponse value, $Res Function(FixedAssetResponse) _then) = _$FixedAssetResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? category, String acquisitionDate,@AmountConverter() String cost,@AmountConverter() String salvageValue, int usefulLifeMonths, DepreciationMethod depreciationMethod, FixedAssetStatus status, String? disposedOn,@NullableAmountConverter() String? disposalProceeds,@AmountConverter() String accumulatedDepreciation,@AmountConverter() String netBookValue
});




}
/// @nodoc
class _$FixedAssetResponseCopyWithImpl<$Res>
    implements $FixedAssetResponseCopyWith<$Res> {
  _$FixedAssetResponseCopyWithImpl(this._self, this._then);

  final FixedAssetResponse _self;
  final $Res Function(FixedAssetResponse) _then;

/// Create a copy of FixedAssetResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = freezed,Object? acquisitionDate = null,Object? cost = null,Object? salvageValue = null,Object? usefulLifeMonths = null,Object? depreciationMethod = null,Object? status = null,Object? disposedOn = freezed,Object? disposalProceeds = freezed,Object? accumulatedDepreciation = null,Object? netBookValue = null,}) {
  return _then(FixedAssetResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,acquisitionDate: null == acquisitionDate ? _self.acquisitionDate : acquisitionDate // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String,salvageValue: null == salvageValue ? _self.salvageValue : salvageValue // ignore: cast_nullable_to_non_nullable
as String,usefulLifeMonths: null == usefulLifeMonths ? _self.usefulLifeMonths : usefulLifeMonths // ignore: cast_nullable_to_non_nullable
as int,depreciationMethod: null == depreciationMethod ? _self.depreciationMethod : depreciationMethod // ignore: cast_nullable_to_non_nullable
as DepreciationMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FixedAssetStatus,disposedOn: freezed == disposedOn ? _self.disposedOn : disposedOn // ignore: cast_nullable_to_non_nullable
as String?,disposalProceeds: freezed == disposalProceeds ? _self.disposalProceeds : disposalProceeds // ignore: cast_nullable_to_non_nullable
as String?,accumulatedDepreciation: null == accumulatedDepreciation ? _self.accumulatedDepreciation : accumulatedDepreciation // ignore: cast_nullable_to_non_nullable
as String,netBookValue: null == netBookValue ? _self.netBookValue : netBookValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FixedAssetResponse].
extension FixedAssetResponsePatterns on FixedAssetResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FixedAssetResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FixedAssetResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FixedAssetResponse value)  $default,){
final _that = this;
switch (_that) {
case _FixedAssetResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FixedAssetResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FixedAssetResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? category,  String acquisitionDate, @AmountConverter()  String cost, @AmountConverter()  String salvageValue,  int usefulLifeMonths,  DepreciationMethod depreciationMethod,  FixedAssetStatus status,  String? disposedOn, @NullableAmountConverter()  String? disposalProceeds, @AmountConverter()  String accumulatedDepreciation, @AmountConverter()  String netBookValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FixedAssetResponse() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.acquisitionDate,_that.cost,_that.salvageValue,_that.usefulLifeMonths,_that.depreciationMethod,_that.status,_that.disposedOn,_that.disposalProceeds,_that.accumulatedDepreciation,_that.netBookValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? category,  String acquisitionDate, @AmountConverter()  String cost, @AmountConverter()  String salvageValue,  int usefulLifeMonths,  DepreciationMethod depreciationMethod,  FixedAssetStatus status,  String? disposedOn, @NullableAmountConverter()  String? disposalProceeds, @AmountConverter()  String accumulatedDepreciation, @AmountConverter()  String netBookValue)  $default,) {final _that = this;
switch (_that) {
case _FixedAssetResponse():
return $default(_that.id,_that.name,_that.category,_that.acquisitionDate,_that.cost,_that.salvageValue,_that.usefulLifeMonths,_that.depreciationMethod,_that.status,_that.disposedOn,_that.disposalProceeds,_that.accumulatedDepreciation,_that.netBookValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? category,  String acquisitionDate, @AmountConverter()  String cost, @AmountConverter()  String salvageValue,  int usefulLifeMonths,  DepreciationMethod depreciationMethod,  FixedAssetStatus status,  String? disposedOn, @NullableAmountConverter()  String? disposalProceeds, @AmountConverter()  String accumulatedDepreciation, @AmountConverter()  String netBookValue)?  $default,) {final _that = this;
switch (_that) {
case _FixedAssetResponse() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.acquisitionDate,_that.cost,_that.salvageValue,_that.usefulLifeMonths,_that.depreciationMethod,_that.status,_that.disposedOn,_that.disposalProceeds,_that.accumulatedDepreciation,_that.netBookValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FixedAssetResponse implements FixedAssetResponse {
  const _FixedAssetResponse({required this.id, required this.name, this.category, required this.acquisitionDate, @AmountConverter() required this.cost, @AmountConverter() required this.salvageValue, required this.usefulLifeMonths, required this.depreciationMethod, required this.status, this.disposedOn, @NullableAmountConverter() this.disposalProceeds, @AmountConverter() required this.accumulatedDepreciation, @AmountConverter() required this.netBookValue});
  factory _FixedAssetResponse.fromJson(Map<String, dynamic> json) => _$FixedAssetResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? category;
@override final  String acquisitionDate;
@override@AmountConverter() final  String cost;
@override@AmountConverter() final  String salvageValue;
@override final  int usefulLifeMonths;
@override final  DepreciationMethod depreciationMethod;
@override final  FixedAssetStatus status;
@override final  String? disposedOn;
@override@NullableAmountConverter() final  String? disposalProceeds;
@override@AmountConverter() final  String accumulatedDepreciation;
@override@AmountConverter() final  String netBookValue;

/// Create a copy of FixedAssetResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FixedAssetResponseCopyWith<_FixedAssetResponse> get copyWith => __$FixedAssetResponseCopyWithImpl<_FixedAssetResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FixedAssetResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FixedAssetResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.acquisitionDate, acquisitionDate) || other.acquisitionDate == acquisitionDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.salvageValue, salvageValue) || other.salvageValue == salvageValue)&&(identical(other.usefulLifeMonths, usefulLifeMonths) || other.usefulLifeMonths == usefulLifeMonths)&&(identical(other.depreciationMethod, depreciationMethod) || other.depreciationMethod == depreciationMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.disposedOn, disposedOn) || other.disposedOn == disposedOn)&&(identical(other.disposalProceeds, disposalProceeds) || other.disposalProceeds == disposalProceeds)&&(identical(other.accumulatedDepreciation, accumulatedDepreciation) || other.accumulatedDepreciation == accumulatedDepreciation)&&(identical(other.netBookValue, netBookValue) || other.netBookValue == netBookValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,acquisitionDate,cost,salvageValue,usefulLifeMonths,depreciationMethod,status,disposedOn,disposalProceeds,accumulatedDepreciation,netBookValue);

@override
String toString() {
  return 'FixedAssetResponse(id: $id, name: $name, category: $category, acquisitionDate: $acquisitionDate, cost: $cost, salvageValue: $salvageValue, usefulLifeMonths: $usefulLifeMonths, depreciationMethod: $depreciationMethod, status: $status, disposedOn: $disposedOn, disposalProceeds: $disposalProceeds, accumulatedDepreciation: $accumulatedDepreciation, netBookValue: $netBookValue)';
}


}

/// @nodoc
abstract mixin class _$FixedAssetResponseCopyWith<$Res> implements $FixedAssetResponseCopyWith<$Res> {
  factory _$FixedAssetResponseCopyWith(_FixedAssetResponse value, $Res Function(_FixedAssetResponse) _then) = __$FixedAssetResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? category, String acquisitionDate,@AmountConverter() String cost,@AmountConverter() String salvageValue, int usefulLifeMonths, DepreciationMethod depreciationMethod, FixedAssetStatus status, String? disposedOn,@NullableAmountConverter() String? disposalProceeds,@AmountConverter() String accumulatedDepreciation,@AmountConverter() String netBookValue
});




}
/// @nodoc
class __$FixedAssetResponseCopyWithImpl<$Res>
    implements _$FixedAssetResponseCopyWith<$Res> {
  __$FixedAssetResponseCopyWithImpl(this._self, this._then);

  final _FixedAssetResponse _self;
  final $Res Function(_FixedAssetResponse) _then;

/// Create a copy of FixedAssetResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = freezed,Object? acquisitionDate = null,Object? cost = null,Object? salvageValue = null,Object? usefulLifeMonths = null,Object? depreciationMethod = null,Object? status = null,Object? disposedOn = freezed,Object? disposalProceeds = freezed,Object? accumulatedDepreciation = null,Object? netBookValue = null,}) {
  return _then(_FixedAssetResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,acquisitionDate: null == acquisitionDate ? _self.acquisitionDate : acquisitionDate // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String,salvageValue: null == salvageValue ? _self.salvageValue : salvageValue // ignore: cast_nullable_to_non_nullable
as String,usefulLifeMonths: null == usefulLifeMonths ? _self.usefulLifeMonths : usefulLifeMonths // ignore: cast_nullable_to_non_nullable
as int,depreciationMethod: null == depreciationMethod ? _self.depreciationMethod : depreciationMethod // ignore: cast_nullable_to_non_nullable
as DepreciationMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FixedAssetStatus,disposedOn: freezed == disposedOn ? _self.disposedOn : disposedOn // ignore: cast_nullable_to_non_nullable
as String?,disposalProceeds: freezed == disposalProceeds ? _self.disposalProceeds : disposalProceeds // ignore: cast_nullable_to_non_nullable
as String?,accumulatedDepreciation: null == accumulatedDepreciation ? _self.accumulatedDepreciation : accumulatedDepreciation // ignore: cast_nullable_to_non_nullable
as String,netBookValue: null == netBookValue ? _self.netBookValue : netBookValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DepreciationEntryResponse {

 String get id; String get assetId; String get period;@AmountConverter() String get amount; String get createdAt;
/// Create a copy of DepreciationEntryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepreciationEntryResponseCopyWith<DepreciationEntryResponse> get copyWith => _$DepreciationEntryResponseCopyWithImpl<DepreciationEntryResponse>(this as DepreciationEntryResponse, _$identity);

  /// Serializes this DepreciationEntryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepreciationEntryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.period, period) || other.period == period)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetId,period,amount,createdAt);

@override
String toString() {
  return 'DepreciationEntryResponse(id: $id, assetId: $assetId, period: $period, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DepreciationEntryResponseCopyWith<$Res>  {
  factory $DepreciationEntryResponseCopyWith(DepreciationEntryResponse value, $Res Function(DepreciationEntryResponse) _then) = _$DepreciationEntryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String assetId, String period,@AmountConverter() String amount, String createdAt
});




}
/// @nodoc
class _$DepreciationEntryResponseCopyWithImpl<$Res>
    implements $DepreciationEntryResponseCopyWith<$Res> {
  _$DepreciationEntryResponseCopyWithImpl(this._self, this._then);

  final DepreciationEntryResponse _self;
  final $Res Function(DepreciationEntryResponse) _then;

/// Create a copy of DepreciationEntryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetId = null,Object? period = null,Object? amount = null,Object? createdAt = null,}) {
  return _then(DepreciationEntryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DepreciationEntryResponse].
extension DepreciationEntryResponsePatterns on DepreciationEntryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepreciationEntryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepreciationEntryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepreciationEntryResponse value)  $default,){
final _that = this;
switch (_that) {
case _DepreciationEntryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepreciationEntryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DepreciationEntryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetId,  String period, @AmountConverter()  String amount,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepreciationEntryResponse() when $default != null:
return $default(_that.id,_that.assetId,_that.period,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetId,  String period, @AmountConverter()  String amount,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _DepreciationEntryResponse():
return $default(_that.id,_that.assetId,_that.period,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetId,  String period, @AmountConverter()  String amount,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DepreciationEntryResponse() when $default != null:
return $default(_that.id,_that.assetId,_that.period,_that.amount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepreciationEntryResponse implements DepreciationEntryResponse {
  const _DepreciationEntryResponse({required this.id, required this.assetId, required this.period, @AmountConverter() required this.amount, required this.createdAt});
  factory _DepreciationEntryResponse.fromJson(Map<String, dynamic> json) => _$DepreciationEntryResponseFromJson(json);

@override final  String id;
@override final  String assetId;
@override final  String period;
@override@AmountConverter() final  String amount;
@override final  String createdAt;

/// Create a copy of DepreciationEntryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepreciationEntryResponseCopyWith<_DepreciationEntryResponse> get copyWith => __$DepreciationEntryResponseCopyWithImpl<_DepreciationEntryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepreciationEntryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepreciationEntryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.period, period) || other.period == period)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetId,period,amount,createdAt);

@override
String toString() {
  return 'DepreciationEntryResponse(id: $id, assetId: $assetId, period: $period, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DepreciationEntryResponseCopyWith<$Res> implements $DepreciationEntryResponseCopyWith<$Res> {
  factory _$DepreciationEntryResponseCopyWith(_DepreciationEntryResponse value, $Res Function(_DepreciationEntryResponse) _then) = __$DepreciationEntryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetId, String period,@AmountConverter() String amount, String createdAt
});




}
/// @nodoc
class __$DepreciationEntryResponseCopyWithImpl<$Res>
    implements _$DepreciationEntryResponseCopyWith<$Res> {
  __$DepreciationEntryResponseCopyWithImpl(this._self, this._then);

  final _DepreciationEntryResponse _self;
  final $Res Function(_DepreciationEntryResponse) _then;

/// Create a copy of DepreciationEntryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetId = null,Object? period = null,Object? amount = null,Object? createdAt = null,}) {
  return _then(_DepreciationEntryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
