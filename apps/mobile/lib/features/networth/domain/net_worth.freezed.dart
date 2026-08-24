// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_worth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BreakdownLine {

 String get label;@AmountConverter() String get amount;
/// Create a copy of BreakdownLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreakdownLineCopyWith<BreakdownLine> get copyWith => _$BreakdownLineCopyWithImpl<BreakdownLine>(this as BreakdownLine, _$identity);

  /// Serializes this BreakdownLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreakdownLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount);

@override
String toString() {
  return 'BreakdownLine(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $BreakdownLineCopyWith<$Res>  {
  factory $BreakdownLineCopyWith(BreakdownLine value, $Res Function(BreakdownLine) _then) = _$BreakdownLineCopyWithImpl;
@useResult
$Res call({
 String label,@AmountConverter() String amount
});




}
/// @nodoc
class _$BreakdownLineCopyWithImpl<$Res>
    implements $BreakdownLineCopyWith<$Res> {
  _$BreakdownLineCopyWithImpl(this._self, this._then);

  final BreakdownLine _self;
  final $Res Function(BreakdownLine) _then;

/// Create a copy of BreakdownLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? amount = null,}) {
  return _then(BreakdownLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BreakdownLine].
extension BreakdownLinePatterns on BreakdownLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreakdownLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreakdownLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreakdownLine value)  $default,){
final _that = this;
switch (_that) {
case _BreakdownLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreakdownLine value)?  $default,){
final _that = this;
switch (_that) {
case _BreakdownLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label, @AmountConverter()  String amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreakdownLine() when $default != null:
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label, @AmountConverter()  String amount)  $default,) {final _that = this;
switch (_that) {
case _BreakdownLine():
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label, @AmountConverter()  String amount)?  $default,) {final _that = this;
switch (_that) {
case _BreakdownLine() when $default != null:
return $default(_that.label,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreakdownLine implements BreakdownLine {
  const _BreakdownLine({required this.label, @AmountConverter() required this.amount});
  factory _BreakdownLine.fromJson(Map<String, dynamic> json) => _$BreakdownLineFromJson(json);

@override final  String label;
@override@AmountConverter() final  String amount;

/// Create a copy of BreakdownLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreakdownLineCopyWith<_BreakdownLine> get copyWith => __$BreakdownLineCopyWithImpl<_BreakdownLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreakdownLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreakdownLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount);

@override
String toString() {
  return 'BreakdownLine(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$BreakdownLineCopyWith<$Res> implements $BreakdownLineCopyWith<$Res> {
  factory _$BreakdownLineCopyWith(_BreakdownLine value, $Res Function(_BreakdownLine) _then) = __$BreakdownLineCopyWithImpl;
@override @useResult
$Res call({
 String label,@AmountConverter() String amount
});




}
/// @nodoc
class __$BreakdownLineCopyWithImpl<$Res>
    implements _$BreakdownLineCopyWith<$Res> {
  __$BreakdownLineCopyWithImpl(this._self, this._then);

  final _BreakdownLine _self;
  final $Res Function(_BreakdownLine) _then;

/// Create a copy of BreakdownLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? amount = null,}) {
  return _then(_BreakdownLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NetWorth {

@AmountConverter() String get totalAssets;@AmountConverter() String get totalLiabilities;@AmountConverter() String get netWorth; List<BreakdownLine> get assetsBreakdown; List<BreakdownLine> get liabilitiesBreakdown;
/// Create a copy of NetWorth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetWorthCopyWith<NetWorth> get copyWith => _$NetWorthCopyWithImpl<NetWorth>(this as NetWorth, _$identity);

  /// Serializes this NetWorth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetWorth&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&const DeepCollectionEquality().equals(other.assetsBreakdown, assetsBreakdown)&&const DeepCollectionEquality().equals(other.liabilitiesBreakdown, liabilitiesBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalAssets,totalLiabilities,netWorth,const DeepCollectionEquality().hash(assetsBreakdown),const DeepCollectionEquality().hash(liabilitiesBreakdown));

@override
String toString() {
  return 'NetWorth(totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, assetsBreakdown: $assetsBreakdown, liabilitiesBreakdown: $liabilitiesBreakdown)';
}


}

/// @nodoc
abstract mixin class $NetWorthCopyWith<$Res>  {
  factory $NetWorthCopyWith(NetWorth value, $Res Function(NetWorth) _then) = _$NetWorthCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String totalAssets,@AmountConverter() String totalLiabilities,@AmountConverter() String netWorth, List<BreakdownLine> assetsBreakdown, List<BreakdownLine> liabilitiesBreakdown
});




}
/// @nodoc
class _$NetWorthCopyWithImpl<$Res>
    implements $NetWorthCopyWith<$Res> {
  _$NetWorthCopyWithImpl(this._self, this._then);

  final NetWorth _self;
  final $Res Function(NetWorth) _then;

/// Create a copy of NetWorth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalAssets = null,Object? totalLiabilities = null,Object? netWorth = null,Object? assetsBreakdown = null,Object? liabilitiesBreakdown = null,}) {
  return _then(NetWorth(
totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as String,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as String,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as String,assetsBreakdown: null == assetsBreakdown ? _self.assetsBreakdown : assetsBreakdown // ignore: cast_nullable_to_non_nullable
as List<BreakdownLine>,liabilitiesBreakdown: null == liabilitiesBreakdown ? _self.liabilitiesBreakdown : liabilitiesBreakdown // ignore: cast_nullable_to_non_nullable
as List<BreakdownLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [NetWorth].
extension NetWorthPatterns on NetWorth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetWorth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetWorth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetWorth value)  $default,){
final _that = this;
switch (_that) {
case _NetWorth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetWorth value)?  $default,){
final _that = this;
switch (_that) {
case _NetWorth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String totalAssets, @AmountConverter()  String totalLiabilities, @AmountConverter()  String netWorth,  List<BreakdownLine> assetsBreakdown,  List<BreakdownLine> liabilitiesBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetWorth() when $default != null:
return $default(_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.assetsBreakdown,_that.liabilitiesBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String totalAssets, @AmountConverter()  String totalLiabilities, @AmountConverter()  String netWorth,  List<BreakdownLine> assetsBreakdown,  List<BreakdownLine> liabilitiesBreakdown)  $default,) {final _that = this;
switch (_that) {
case _NetWorth():
return $default(_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.assetsBreakdown,_that.liabilitiesBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String totalAssets, @AmountConverter()  String totalLiabilities, @AmountConverter()  String netWorth,  List<BreakdownLine> assetsBreakdown,  List<BreakdownLine> liabilitiesBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _NetWorth() when $default != null:
return $default(_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.assetsBreakdown,_that.liabilitiesBreakdown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetWorth implements NetWorth {
  const _NetWorth({@AmountConverter() required this.totalAssets, @AmountConverter() required this.totalLiabilities, @AmountConverter() required this.netWorth, required  List<BreakdownLine> assetsBreakdown, required  List<BreakdownLine> liabilitiesBreakdown}): _assetsBreakdown = assetsBreakdown,_liabilitiesBreakdown = liabilitiesBreakdown;
  factory _NetWorth.fromJson(Map<String, dynamic> json) => _$NetWorthFromJson(json);

@override@AmountConverter() final  String totalAssets;
@override@AmountConverter() final  String totalLiabilities;
@override@AmountConverter() final  String netWorth;
 final  List<BreakdownLine> _assetsBreakdown;
@override List<BreakdownLine> get assetsBreakdown {
  if (_assetsBreakdown is EqualUnmodifiableListView) return _assetsBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assetsBreakdown);
}

 final  List<BreakdownLine> _liabilitiesBreakdown;
@override List<BreakdownLine> get liabilitiesBreakdown {
  if (_liabilitiesBreakdown is EqualUnmodifiableListView) return _liabilitiesBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_liabilitiesBreakdown);
}


/// Create a copy of NetWorth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetWorthCopyWith<_NetWorth> get copyWith => __$NetWorthCopyWithImpl<_NetWorth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetWorthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetWorth&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&const DeepCollectionEquality().equals(other._assetsBreakdown, _assetsBreakdown)&&const DeepCollectionEquality().equals(other._liabilitiesBreakdown, _liabilitiesBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalAssets,totalLiabilities,netWorth,const DeepCollectionEquality().hash(_assetsBreakdown),const DeepCollectionEquality().hash(_liabilitiesBreakdown));

@override
String toString() {
  return 'NetWorth(totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, assetsBreakdown: $assetsBreakdown, liabilitiesBreakdown: $liabilitiesBreakdown)';
}


}

/// @nodoc
abstract mixin class _$NetWorthCopyWith<$Res> implements $NetWorthCopyWith<$Res> {
  factory _$NetWorthCopyWith(_NetWorth value, $Res Function(_NetWorth) _then) = __$NetWorthCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String totalAssets,@AmountConverter() String totalLiabilities,@AmountConverter() String netWorth, List<BreakdownLine> assetsBreakdown, List<BreakdownLine> liabilitiesBreakdown
});




}
/// @nodoc
class __$NetWorthCopyWithImpl<$Res>
    implements _$NetWorthCopyWith<$Res> {
  __$NetWorthCopyWithImpl(this._self, this._then);

  final _NetWorth _self;
  final $Res Function(_NetWorth) _then;

/// Create a copy of NetWorth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalAssets = null,Object? totalLiabilities = null,Object? netWorth = null,Object? assetsBreakdown = null,Object? liabilitiesBreakdown = null,}) {
  return _then(_NetWorth(
totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as String,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as String,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as String,assetsBreakdown: null == assetsBreakdown ? _self._assetsBreakdown : assetsBreakdown // ignore: cast_nullable_to_non_nullable
as List<BreakdownLine>,liabilitiesBreakdown: null == liabilitiesBreakdown ? _self._liabilitiesBreakdown : liabilitiesBreakdown // ignore: cast_nullable_to_non_nullable
as List<BreakdownLine>,
  ));
}


}


/// @nodoc
mixin _$OtherAsset {

 String get id; AssetType get type; String get name;@AmountConverter() String get estimatedValue; String? get notes;
/// Create a copy of OtherAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtherAssetCopyWith<OtherAsset> get copyWith => _$OtherAssetCopyWithImpl<OtherAsset>(this as OtherAsset, _$identity);

  /// Serializes this OtherAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtherAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,estimatedValue,notes);

@override
String toString() {
  return 'OtherAsset(id: $id, type: $type, name: $name, estimatedValue: $estimatedValue, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $OtherAssetCopyWith<$Res>  {
  factory $OtherAssetCopyWith(OtherAsset value, $Res Function(OtherAsset) _then) = _$OtherAssetCopyWithImpl;
@useResult
$Res call({
 String id, AssetType type, String name,@AmountConverter() String estimatedValue, String? notes
});




}
/// @nodoc
class _$OtherAssetCopyWithImpl<$Res>
    implements $OtherAssetCopyWith<$Res> {
  _$OtherAssetCopyWithImpl(this._self, this._then);

  final OtherAsset _self;
  final $Res Function(OtherAsset) _then;

/// Create a copy of OtherAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? estimatedValue = null,Object? notes = freezed,}) {
  return _then(OtherAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtherAsset].
extension OtherAssetPatterns on OtherAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtherAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtherAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtherAsset value)  $default,){
final _that = this;
switch (_that) {
case _OtherAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtherAsset value)?  $default,){
final _that = this;
switch (_that) {
case _OtherAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AssetType type,  String name, @AmountConverter()  String estimatedValue,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtherAsset() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.estimatedValue,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AssetType type,  String name, @AmountConverter()  String estimatedValue,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _OtherAsset():
return $default(_that.id,_that.type,_that.name,_that.estimatedValue,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AssetType type,  String name, @AmountConverter()  String estimatedValue,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _OtherAsset() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.estimatedValue,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtherAsset implements OtherAsset {
  const _OtherAsset({required this.id, required this.type, required this.name, @AmountConverter() required this.estimatedValue, this.notes});
  factory _OtherAsset.fromJson(Map<String, dynamic> json) => _$OtherAssetFromJson(json);

@override final  String id;
@override final  AssetType type;
@override final  String name;
@override@AmountConverter() final  String estimatedValue;
@override final  String? notes;

/// Create a copy of OtherAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtherAssetCopyWith<_OtherAsset> get copyWith => __$OtherAssetCopyWithImpl<_OtherAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtherAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtherAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,estimatedValue,notes);

@override
String toString() {
  return 'OtherAsset(id: $id, type: $type, name: $name, estimatedValue: $estimatedValue, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$OtherAssetCopyWith<$Res> implements $OtherAssetCopyWith<$Res> {
  factory _$OtherAssetCopyWith(_OtherAsset value, $Res Function(_OtherAsset) _then) = __$OtherAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, AssetType type, String name,@AmountConverter() String estimatedValue, String? notes
});




}
/// @nodoc
class __$OtherAssetCopyWithImpl<$Res>
    implements _$OtherAssetCopyWith<$Res> {
  __$OtherAssetCopyWithImpl(this._self, this._then);

  final _OtherAsset _self;
  final $Res Function(_OtherAsset) _then;

/// Create a copy of OtherAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? estimatedValue = null,Object? notes = freezed,}) {
  return _then(_OtherAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NetWorthSnapshot {

 String get id;@AmountConverter() String get totalAssets;@AmountConverter() String get totalLiabilities;@AmountConverter() String get netWorth; String get snapshotDate;
/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetWorthSnapshotCopyWith<NetWorthSnapshot> get copyWith => _$NetWorthSnapshotCopyWithImpl<NetWorthSnapshot>(this as NetWorthSnapshot, _$identity);

  /// Serializes this NetWorthSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetWorthSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&(identical(other.snapshotDate, snapshotDate) || other.snapshotDate == snapshotDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,totalAssets,totalLiabilities,netWorth,snapshotDate);

@override
String toString() {
  return 'NetWorthSnapshot(id: $id, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, snapshotDate: $snapshotDate)';
}


}

/// @nodoc
abstract mixin class $NetWorthSnapshotCopyWith<$Res>  {
  factory $NetWorthSnapshotCopyWith(NetWorthSnapshot value, $Res Function(NetWorthSnapshot) _then) = _$NetWorthSnapshotCopyWithImpl;
@useResult
$Res call({
 String id,@AmountConverter() String totalAssets,@AmountConverter() String totalLiabilities,@AmountConverter() String netWorth, String snapshotDate
});




}
/// @nodoc
class _$NetWorthSnapshotCopyWithImpl<$Res>
    implements $NetWorthSnapshotCopyWith<$Res> {
  _$NetWorthSnapshotCopyWithImpl(this._self, this._then);

  final NetWorthSnapshot _self;
  final $Res Function(NetWorthSnapshot) _then;

/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? totalAssets = null,Object? totalLiabilities = null,Object? netWorth = null,Object? snapshotDate = null,}) {
  return _then(NetWorthSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as String,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as String,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as String,snapshotDate: null == snapshotDate ? _self.snapshotDate : snapshotDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NetWorthSnapshot].
extension NetWorthSnapshotPatterns on NetWorthSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetWorthSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetWorthSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _NetWorthSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetWorthSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @AmountConverter()  String totalAssets, @AmountConverter()  String totalLiabilities, @AmountConverter()  String netWorth,  String snapshotDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
return $default(_that.id,_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.snapshotDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @AmountConverter()  String totalAssets, @AmountConverter()  String totalLiabilities, @AmountConverter()  String netWorth,  String snapshotDate)  $default,) {final _that = this;
switch (_that) {
case _NetWorthSnapshot():
return $default(_that.id,_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.snapshotDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @AmountConverter()  String totalAssets, @AmountConverter()  String totalLiabilities, @AmountConverter()  String netWorth,  String snapshotDate)?  $default,) {final _that = this;
switch (_that) {
case _NetWorthSnapshot() when $default != null:
return $default(_that.id,_that.totalAssets,_that.totalLiabilities,_that.netWorth,_that.snapshotDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetWorthSnapshot implements NetWorthSnapshot {
  const _NetWorthSnapshot({required this.id, @AmountConverter() required this.totalAssets, @AmountConverter() required this.totalLiabilities, @AmountConverter() required this.netWorth, required this.snapshotDate});
  factory _NetWorthSnapshot.fromJson(Map<String, dynamic> json) => _$NetWorthSnapshotFromJson(json);

@override final  String id;
@override@AmountConverter() final  String totalAssets;
@override@AmountConverter() final  String totalLiabilities;
@override@AmountConverter() final  String netWorth;
@override final  String snapshotDate;

/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetWorthSnapshotCopyWith<_NetWorthSnapshot> get copyWith => __$NetWorthSnapshotCopyWithImpl<_NetWorthSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetWorthSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetWorthSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&(identical(other.snapshotDate, snapshotDate) || other.snapshotDate == snapshotDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,totalAssets,totalLiabilities,netWorth,snapshotDate);

@override
String toString() {
  return 'NetWorthSnapshot(id: $id, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, snapshotDate: $snapshotDate)';
}


}

/// @nodoc
abstract mixin class _$NetWorthSnapshotCopyWith<$Res> implements $NetWorthSnapshotCopyWith<$Res> {
  factory _$NetWorthSnapshotCopyWith(_NetWorthSnapshot value, $Res Function(_NetWorthSnapshot) _then) = __$NetWorthSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id,@AmountConverter() String totalAssets,@AmountConverter() String totalLiabilities,@AmountConverter() String netWorth, String snapshotDate
});




}
/// @nodoc
class __$NetWorthSnapshotCopyWithImpl<$Res>
    implements _$NetWorthSnapshotCopyWith<$Res> {
  __$NetWorthSnapshotCopyWithImpl(this._self, this._then);

  final _NetWorthSnapshot _self;
  final $Res Function(_NetWorthSnapshot) _then;

/// Create a copy of NetWorthSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? totalAssets = null,Object? totalLiabilities = null,Object? netWorth = null,Object? snapshotDate = null,}) {
  return _then(_NetWorthSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as String,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as String,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as String,snapshotDate: null == snapshotDate ? _self.snapshotDate : snapshotDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
