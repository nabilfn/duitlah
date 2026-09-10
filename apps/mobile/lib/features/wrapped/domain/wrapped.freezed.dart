// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wrapped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WrappedPromo {

 bool get available; int? get year; int? get month; String? get personaName;
/// Create a copy of WrappedPromo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedPromoCopyWith<WrappedPromo> get copyWith => _$WrappedPromoCopyWithImpl<WrappedPromo>(this as WrappedPromo, _$identity);

  /// Serializes this WrappedPromo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedPromo&&(identical(other.available, available) || other.available == available)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.personaName, personaName) || other.personaName == personaName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available,year,month,personaName);

@override
String toString() {
  return 'WrappedPromo(available: $available, year: $year, month: $month, personaName: $personaName)';
}


}

/// @nodoc
abstract mixin class $WrappedPromoCopyWith<$Res>  {
  factory $WrappedPromoCopyWith(WrappedPromo value, $Res Function(WrappedPromo) _then) = _$WrappedPromoCopyWithImpl;
@useResult
$Res call({
 bool available, int? year, int? month, String? personaName
});




}
/// @nodoc
class _$WrappedPromoCopyWithImpl<$Res>
    implements $WrappedPromoCopyWith<$Res> {
  _$WrappedPromoCopyWithImpl(this._self, this._then);

  final WrappedPromo _self;
  final $Res Function(WrappedPromo) _then;

/// Create a copy of WrappedPromo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? year = freezed,Object? month = freezed,Object? personaName = freezed,}) {
  return _then(WrappedPromo(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WrappedPromo].
extension WrappedPromoPatterns on WrappedPromo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedPromo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedPromo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedPromo value)  $default,){
final _that = this;
switch (_that) {
case _WrappedPromo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedPromo value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedPromo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available,  int? year,  int? month,  String? personaName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedPromo() when $default != null:
return $default(_that.available,_that.year,_that.month,_that.personaName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available,  int? year,  int? month,  String? personaName)  $default,) {final _that = this;
switch (_that) {
case _WrappedPromo():
return $default(_that.available,_that.year,_that.month,_that.personaName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available,  int? year,  int? month,  String? personaName)?  $default,) {final _that = this;
switch (_that) {
case _WrappedPromo() when $default != null:
return $default(_that.available,_that.year,_that.month,_that.personaName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedPromo implements WrappedPromo {
  const _WrappedPromo({required this.available, this.year, this.month, this.personaName});
  factory _WrappedPromo.fromJson(Map<String, dynamic> json) => _$WrappedPromoFromJson(json);

@override final  bool available;
@override final  int? year;
@override final  int? month;
@override final  String? personaName;

/// Create a copy of WrappedPromo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedPromoCopyWith<_WrappedPromo> get copyWith => __$WrappedPromoCopyWithImpl<_WrappedPromo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedPromoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedPromo&&(identical(other.available, available) || other.available == available)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.personaName, personaName) || other.personaName == personaName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,available,year,month,personaName);

@override
String toString() {
  return 'WrappedPromo(available: $available, year: $year, month: $month, personaName: $personaName)';
}


}

/// @nodoc
abstract mixin class _$WrappedPromoCopyWith<$Res> implements $WrappedPromoCopyWith<$Res> {
  factory _$WrappedPromoCopyWith(_WrappedPromo value, $Res Function(_WrappedPromo) _then) = __$WrappedPromoCopyWithImpl;
@override @useResult
$Res call({
 bool available, int? year, int? month, String? personaName
});




}
/// @nodoc
class __$WrappedPromoCopyWithImpl<$Res>
    implements _$WrappedPromoCopyWith<$Res> {
  __$WrappedPromoCopyWithImpl(this._self, this._then);

  final _WrappedPromo _self;
  final $Res Function(_WrappedPromo) _then;

/// Create a copy of WrappedPromo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? year = freezed,Object? month = freezed,Object? personaName = freezed,}) {
  return _then(_WrappedPromo(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WrappedHistoryItem {

 int get year; int get month; String? get personaId; String? get personaName; bool get viewed;
/// Create a copy of WrappedHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedHistoryItemCopyWith<WrappedHistoryItem> get copyWith => _$WrappedHistoryItemCopyWithImpl<WrappedHistoryItem>(this as WrappedHistoryItem, _$identity);

  /// Serializes this WrappedHistoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedHistoryItem&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.personaId, personaId) || other.personaId == personaId)&&(identical(other.personaName, personaName) || other.personaName == personaName)&&(identical(other.viewed, viewed) || other.viewed == viewed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,personaId,personaName,viewed);

@override
String toString() {
  return 'WrappedHistoryItem(year: $year, month: $month, personaId: $personaId, personaName: $personaName, viewed: $viewed)';
}


}

/// @nodoc
abstract mixin class $WrappedHistoryItemCopyWith<$Res>  {
  factory $WrappedHistoryItemCopyWith(WrappedHistoryItem value, $Res Function(WrappedHistoryItem) _then) = _$WrappedHistoryItemCopyWithImpl;
@useResult
$Res call({
 int year, int month, String? personaId, String? personaName, bool viewed
});




}
/// @nodoc
class _$WrappedHistoryItemCopyWithImpl<$Res>
    implements $WrappedHistoryItemCopyWith<$Res> {
  _$WrappedHistoryItemCopyWithImpl(this._self, this._then);

  final WrappedHistoryItem _self;
  final $Res Function(WrappedHistoryItem) _then;

/// Create a copy of WrappedHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? personaId = freezed,Object? personaName = freezed,Object? viewed = null,}) {
  return _then(WrappedHistoryItem(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,personaId: freezed == personaId ? _self.personaId : personaId // ignore: cast_nullable_to_non_nullable
as String?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,viewed: null == viewed ? _self.viewed : viewed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WrappedHistoryItem].
extension WrappedHistoryItemPatterns on WrappedHistoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedHistoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _WrappedHistoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedHistoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  String? personaId,  String? personaName,  bool viewed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedHistoryItem() when $default != null:
return $default(_that.year,_that.month,_that.personaId,_that.personaName,_that.viewed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  String? personaId,  String? personaName,  bool viewed)  $default,) {final _that = this;
switch (_that) {
case _WrappedHistoryItem():
return $default(_that.year,_that.month,_that.personaId,_that.personaName,_that.viewed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  String? personaId,  String? personaName,  bool viewed)?  $default,) {final _that = this;
switch (_that) {
case _WrappedHistoryItem() when $default != null:
return $default(_that.year,_that.month,_that.personaId,_that.personaName,_that.viewed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedHistoryItem implements WrappedHistoryItem {
  const _WrappedHistoryItem({required this.year, required this.month, this.personaId, this.personaName, required this.viewed});
  factory _WrappedHistoryItem.fromJson(Map<String, dynamic> json) => _$WrappedHistoryItemFromJson(json);

@override final  int year;
@override final  int month;
@override final  String? personaId;
@override final  String? personaName;
@override final  bool viewed;

/// Create a copy of WrappedHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedHistoryItemCopyWith<_WrappedHistoryItem> get copyWith => __$WrappedHistoryItemCopyWithImpl<_WrappedHistoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedHistoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedHistoryItem&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.personaId, personaId) || other.personaId == personaId)&&(identical(other.personaName, personaName) || other.personaName == personaName)&&(identical(other.viewed, viewed) || other.viewed == viewed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,personaId,personaName,viewed);

@override
String toString() {
  return 'WrappedHistoryItem(year: $year, month: $month, personaId: $personaId, personaName: $personaName, viewed: $viewed)';
}


}

/// @nodoc
abstract mixin class _$WrappedHistoryItemCopyWith<$Res> implements $WrappedHistoryItemCopyWith<$Res> {
  factory _$WrappedHistoryItemCopyWith(_WrappedHistoryItem value, $Res Function(_WrappedHistoryItem) _then) = __$WrappedHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, String? personaId, String? personaName, bool viewed
});




}
/// @nodoc
class __$WrappedHistoryItemCopyWithImpl<$Res>
    implements _$WrappedHistoryItemCopyWith<$Res> {
  __$WrappedHistoryItemCopyWithImpl(this._self, this._then);

  final _WrappedHistoryItem _self;
  final $Res Function(_WrappedHistoryItem) _then;

/// Create a copy of WrappedHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? personaId = freezed,Object? personaName = freezed,Object? viewed = null,}) {
  return _then(_WrappedHistoryItem(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,personaId: freezed == personaId ? _self.personaId : personaId // ignore: cast_nullable_to_non_nullable
as String?,personaName: freezed == personaName ? _self.personaName : personaName // ignore: cast_nullable_to_non_nullable
as String?,viewed: null == viewed ? _self.viewed : viewed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WrappedOverview {

 int get year; int get month;@AmountConverter() String get totalIncome;@AmountConverter() String get totalExpense;@AmountConverter() String get netAmount;@AmountConverter() String get totalSavingsContribution; int get transactionCount; double? get spendingChangePercentage; double? get incomeChangePercentage;
/// Create a copy of WrappedOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedOverviewCopyWith<WrappedOverview> get copyWith => _$WrappedOverviewCopyWithImpl<WrappedOverview>(this as WrappedOverview, _$identity);

  /// Serializes this WrappedOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedOverview&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.totalSavingsContribution, totalSavingsContribution) || other.totalSavingsContribution == totalSavingsContribution)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.spendingChangePercentage, spendingChangePercentage) || other.spendingChangePercentage == spendingChangePercentage)&&(identical(other.incomeChangePercentage, incomeChangePercentage) || other.incomeChangePercentage == incomeChangePercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,totalIncome,totalExpense,netAmount,totalSavingsContribution,transactionCount,spendingChangePercentage,incomeChangePercentage);

@override
String toString() {
  return 'WrappedOverview(year: $year, month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, netAmount: $netAmount, totalSavingsContribution: $totalSavingsContribution, transactionCount: $transactionCount, spendingChangePercentage: $spendingChangePercentage, incomeChangePercentage: $incomeChangePercentage)';
}


}

/// @nodoc
abstract mixin class $WrappedOverviewCopyWith<$Res>  {
  factory $WrappedOverviewCopyWith(WrappedOverview value, $Res Function(WrappedOverview) _then) = _$WrappedOverviewCopyWithImpl;
@useResult
$Res call({
 int year, int month,@AmountConverter() String totalIncome,@AmountConverter() String totalExpense,@AmountConverter() String netAmount,@AmountConverter() String totalSavingsContribution, int transactionCount, double? spendingChangePercentage, double? incomeChangePercentage
});




}
/// @nodoc
class _$WrappedOverviewCopyWithImpl<$Res>
    implements $WrappedOverviewCopyWith<$Res> {
  _$WrappedOverviewCopyWithImpl(this._self, this._then);

  final WrappedOverview _self;
  final $Res Function(WrappedOverview) _then;

/// Create a copy of WrappedOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? netAmount = null,Object? totalSavingsContribution = null,Object? transactionCount = null,Object? spendingChangePercentage = freezed,Object? incomeChangePercentage = freezed,}) {
  return _then(WrappedOverview(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String,totalSavingsContribution: null == totalSavingsContribution ? _self.totalSavingsContribution : totalSavingsContribution // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,spendingChangePercentage: freezed == spendingChangePercentage ? _self.spendingChangePercentage : spendingChangePercentage // ignore: cast_nullable_to_non_nullable
as double?,incomeChangePercentage: freezed == incomeChangePercentage ? _self.incomeChangePercentage : incomeChangePercentage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WrappedOverview].
extension WrappedOverviewPatterns on WrappedOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedOverview value)  $default,){
final _that = this;
switch (_that) {
case _WrappedOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedOverview value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month, @AmountConverter()  String totalIncome, @AmountConverter()  String totalExpense, @AmountConverter()  String netAmount, @AmountConverter()  String totalSavingsContribution,  int transactionCount,  double? spendingChangePercentage,  double? incomeChangePercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedOverview() when $default != null:
return $default(_that.year,_that.month,_that.totalIncome,_that.totalExpense,_that.netAmount,_that.totalSavingsContribution,_that.transactionCount,_that.spendingChangePercentage,_that.incomeChangePercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month, @AmountConverter()  String totalIncome, @AmountConverter()  String totalExpense, @AmountConverter()  String netAmount, @AmountConverter()  String totalSavingsContribution,  int transactionCount,  double? spendingChangePercentage,  double? incomeChangePercentage)  $default,) {final _that = this;
switch (_that) {
case _WrappedOverview():
return $default(_that.year,_that.month,_that.totalIncome,_that.totalExpense,_that.netAmount,_that.totalSavingsContribution,_that.transactionCount,_that.spendingChangePercentage,_that.incomeChangePercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month, @AmountConverter()  String totalIncome, @AmountConverter()  String totalExpense, @AmountConverter()  String netAmount, @AmountConverter()  String totalSavingsContribution,  int transactionCount,  double? spendingChangePercentage,  double? incomeChangePercentage)?  $default,) {final _that = this;
switch (_that) {
case _WrappedOverview() when $default != null:
return $default(_that.year,_that.month,_that.totalIncome,_that.totalExpense,_that.netAmount,_that.totalSavingsContribution,_that.transactionCount,_that.spendingChangePercentage,_that.incomeChangePercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedOverview implements WrappedOverview {
  const _WrappedOverview({required this.year, required this.month, @AmountConverter() required this.totalIncome, @AmountConverter() required this.totalExpense, @AmountConverter() required this.netAmount, @AmountConverter() required this.totalSavingsContribution, required this.transactionCount, this.spendingChangePercentage, this.incomeChangePercentage});
  factory _WrappedOverview.fromJson(Map<String, dynamic> json) => _$WrappedOverviewFromJson(json);

@override final  int year;
@override final  int month;
@override@AmountConverter() final  String totalIncome;
@override@AmountConverter() final  String totalExpense;
@override@AmountConverter() final  String netAmount;
@override@AmountConverter() final  String totalSavingsContribution;
@override final  int transactionCount;
@override final  double? spendingChangePercentage;
@override final  double? incomeChangePercentage;

/// Create a copy of WrappedOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedOverviewCopyWith<_WrappedOverview> get copyWith => __$WrappedOverviewCopyWithImpl<_WrappedOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedOverview&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.totalSavingsContribution, totalSavingsContribution) || other.totalSavingsContribution == totalSavingsContribution)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.spendingChangePercentage, spendingChangePercentage) || other.spendingChangePercentage == spendingChangePercentage)&&(identical(other.incomeChangePercentage, incomeChangePercentage) || other.incomeChangePercentage == incomeChangePercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,totalIncome,totalExpense,netAmount,totalSavingsContribution,transactionCount,spendingChangePercentage,incomeChangePercentage);

@override
String toString() {
  return 'WrappedOverview(year: $year, month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, netAmount: $netAmount, totalSavingsContribution: $totalSavingsContribution, transactionCount: $transactionCount, spendingChangePercentage: $spendingChangePercentage, incomeChangePercentage: $incomeChangePercentage)';
}


}

/// @nodoc
abstract mixin class _$WrappedOverviewCopyWith<$Res> implements $WrappedOverviewCopyWith<$Res> {
  factory _$WrappedOverviewCopyWith(_WrappedOverview value, $Res Function(_WrappedOverview) _then) = __$WrappedOverviewCopyWithImpl;
@override @useResult
$Res call({
 int year, int month,@AmountConverter() String totalIncome,@AmountConverter() String totalExpense,@AmountConverter() String netAmount,@AmountConverter() String totalSavingsContribution, int transactionCount, double? spendingChangePercentage, double? incomeChangePercentage
});




}
/// @nodoc
class __$WrappedOverviewCopyWithImpl<$Res>
    implements _$WrappedOverviewCopyWith<$Res> {
  __$WrappedOverviewCopyWithImpl(this._self, this._then);

  final _WrappedOverview _self;
  final $Res Function(_WrappedOverview) _then;

/// Create a copy of WrappedOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? netAmount = null,Object? totalSavingsContribution = null,Object? transactionCount = null,Object? spendingChangePercentage = freezed,Object? incomeChangePercentage = freezed,}) {
  return _then(_WrappedOverview(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String,totalSavingsContribution: null == totalSavingsContribution ? _self.totalSavingsContribution : totalSavingsContribution // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,spendingChangePercentage: freezed == spendingChangePercentage ? _self.spendingChangePercentage : spendingChangePercentage // ignore: cast_nullable_to_non_nullable
as double?,incomeChangePercentage: freezed == incomeChangePercentage ? _self.incomeChangePercentage : incomeChangePercentage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$WrappedPersona {

 String get id; String get name; String get tagline;/// One of exactly 10 keys — see `presentation/widgets/persona_visuals.dart` for the
/// colour treatment + line-art motif mapped to each.
 String get visualTheme;@AmountConverter() String get amount; double get percentage; String get denominatorLabel; double get score; List<String> get evidence;
/// Create a copy of WrappedPersona
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedPersonaCopyWith<WrappedPersona> get copyWith => _$WrappedPersonaCopyWithImpl<WrappedPersona>(this as WrappedPersona, _$identity);

  /// Serializes this WrappedPersona to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedPersona&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.visualTheme, visualTheme) || other.visualTheme == visualTheme)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.denominatorLabel, denominatorLabel) || other.denominatorLabel == denominatorLabel)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.evidence, evidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tagline,visualTheme,amount,percentage,denominatorLabel,score,const DeepCollectionEquality().hash(evidence));

@override
String toString() {
  return 'WrappedPersona(id: $id, name: $name, tagline: $tagline, visualTheme: $visualTheme, amount: $amount, percentage: $percentage, denominatorLabel: $denominatorLabel, score: $score, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class $WrappedPersonaCopyWith<$Res>  {
  factory $WrappedPersonaCopyWith(WrappedPersona value, $Res Function(WrappedPersona) _then) = _$WrappedPersonaCopyWithImpl;
@useResult
$Res call({
 String id, String name, String tagline, String visualTheme,@AmountConverter() String amount, double percentage, String denominatorLabel, double score, List<String> evidence
});




}
/// @nodoc
class _$WrappedPersonaCopyWithImpl<$Res>
    implements $WrappedPersonaCopyWith<$Res> {
  _$WrappedPersonaCopyWithImpl(this._self, this._then);

  final WrappedPersona _self;
  final $Res Function(WrappedPersona) _then;

/// Create a copy of WrappedPersona
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tagline = null,Object? visualTheme = null,Object? amount = null,Object? percentage = null,Object? denominatorLabel = null,Object? score = null,Object? evidence = null,}) {
  return _then(WrappedPersona(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,visualTheme: null == visualTheme ? _self.visualTheme : visualTheme // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,denominatorLabel: null == denominatorLabel ? _self.denominatorLabel : denominatorLabel // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WrappedPersona].
extension WrappedPersonaPatterns on WrappedPersona {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedPersona value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedPersona() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedPersona value)  $default,){
final _that = this;
switch (_that) {
case _WrappedPersona():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedPersona value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedPersona() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String tagline,  String visualTheme, @AmountConverter()  String amount,  double percentage,  String denominatorLabel,  double score,  List<String> evidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedPersona() when $default != null:
return $default(_that.id,_that.name,_that.tagline,_that.visualTheme,_that.amount,_that.percentage,_that.denominatorLabel,_that.score,_that.evidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String tagline,  String visualTheme, @AmountConverter()  String amount,  double percentage,  String denominatorLabel,  double score,  List<String> evidence)  $default,) {final _that = this;
switch (_that) {
case _WrappedPersona():
return $default(_that.id,_that.name,_that.tagline,_that.visualTheme,_that.amount,_that.percentage,_that.denominatorLabel,_that.score,_that.evidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String tagline,  String visualTheme, @AmountConverter()  String amount,  double percentage,  String denominatorLabel,  double score,  List<String> evidence)?  $default,) {final _that = this;
switch (_that) {
case _WrappedPersona() when $default != null:
return $default(_that.id,_that.name,_that.tagline,_that.visualTheme,_that.amount,_that.percentage,_that.denominatorLabel,_that.score,_that.evidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedPersona implements WrappedPersona {
  const _WrappedPersona({required this.id, required this.name, required this.tagline, required this.visualTheme, @AmountConverter() required this.amount, required this.percentage, required this.denominatorLabel, required this.score, required  List<String> evidence}): _evidence = evidence;
  factory _WrappedPersona.fromJson(Map<String, dynamic> json) => _$WrappedPersonaFromJson(json);

@override final  String id;
@override final  String name;
@override final  String tagline;
/// One of exactly 10 keys — see `presentation/widgets/persona_visuals.dart` for the
/// colour treatment + line-art motif mapped to each.
@override final  String visualTheme;
@override@AmountConverter() final  String amount;
@override final  double percentage;
@override final  String denominatorLabel;
@override final  double score;
 final  List<String> _evidence;
@override List<String> get evidence {
  if (_evidence is EqualUnmodifiableListView) return _evidence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidence);
}


/// Create a copy of WrappedPersona
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedPersonaCopyWith<_WrappedPersona> get copyWith => __$WrappedPersonaCopyWithImpl<_WrappedPersona>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedPersonaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedPersona&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.visualTheme, visualTheme) || other.visualTheme == visualTheme)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.denominatorLabel, denominatorLabel) || other.denominatorLabel == denominatorLabel)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other._evidence, _evidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tagline,visualTheme,amount,percentage,denominatorLabel,score,const DeepCollectionEquality().hash(_evidence));

@override
String toString() {
  return 'WrappedPersona(id: $id, name: $name, tagline: $tagline, visualTheme: $visualTheme, amount: $amount, percentage: $percentage, denominatorLabel: $denominatorLabel, score: $score, evidence: $evidence)';
}


}

/// @nodoc
abstract mixin class _$WrappedPersonaCopyWith<$Res> implements $WrappedPersonaCopyWith<$Res> {
  factory _$WrappedPersonaCopyWith(_WrappedPersona value, $Res Function(_WrappedPersona) _then) = __$WrappedPersonaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String tagline, String visualTheme,@AmountConverter() String amount, double percentage, String denominatorLabel, double score, List<String> evidence
});




}
/// @nodoc
class __$WrappedPersonaCopyWithImpl<$Res>
    implements _$WrappedPersonaCopyWith<$Res> {
  __$WrappedPersonaCopyWithImpl(this._self, this._then);

  final _WrappedPersona _self;
  final $Res Function(_WrappedPersona) _then;

/// Create a copy of WrappedPersona
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tagline = null,Object? visualTheme = null,Object? amount = null,Object? percentage = null,Object? denominatorLabel = null,Object? score = null,Object? evidence = null,}) {
  return _then(_WrappedPersona(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,visualTheme: null == visualTheme ? _self.visualTheme : visualTheme // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,denominatorLabel: null == denominatorLabel ? _self.denominatorLabel : denominatorLabel // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,evidence: null == evidence ? _self._evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$WrappedInsight {

 String get type; String get title; String get primaryValue; String? get secondaryValue; String? get comparison;
/// Create a copy of WrappedInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedInsightCopyWith<WrappedInsight> get copyWith => _$WrappedInsightCopyWithImpl<WrappedInsight>(this as WrappedInsight, _$identity);

  /// Serializes this WrappedInsight to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedInsight&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.primaryValue, primaryValue) || other.primaryValue == primaryValue)&&(identical(other.secondaryValue, secondaryValue) || other.secondaryValue == secondaryValue)&&(identical(other.comparison, comparison) || other.comparison == comparison));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,primaryValue,secondaryValue,comparison);

@override
String toString() {
  return 'WrappedInsight(type: $type, title: $title, primaryValue: $primaryValue, secondaryValue: $secondaryValue, comparison: $comparison)';
}


}

/// @nodoc
abstract mixin class $WrappedInsightCopyWith<$Res>  {
  factory $WrappedInsightCopyWith(WrappedInsight value, $Res Function(WrappedInsight) _then) = _$WrappedInsightCopyWithImpl;
@useResult
$Res call({
 String type, String title, String primaryValue, String? secondaryValue, String? comparison
});




}
/// @nodoc
class _$WrappedInsightCopyWithImpl<$Res>
    implements $WrappedInsightCopyWith<$Res> {
  _$WrappedInsightCopyWithImpl(this._self, this._then);

  final WrappedInsight _self;
  final $Res Function(WrappedInsight) _then;

/// Create a copy of WrappedInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? primaryValue = null,Object? secondaryValue = freezed,Object? comparison = freezed,}) {
  return _then(WrappedInsight(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,primaryValue: null == primaryValue ? _self.primaryValue : primaryValue // ignore: cast_nullable_to_non_nullable
as String,secondaryValue: freezed == secondaryValue ? _self.secondaryValue : secondaryValue // ignore: cast_nullable_to_non_nullable
as String?,comparison: freezed == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WrappedInsight].
extension WrappedInsightPatterns on WrappedInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedInsight value)  $default,){
final _that = this;
switch (_that) {
case _WrappedInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedInsight value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String title,  String primaryValue,  String? secondaryValue,  String? comparison)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedInsight() when $default != null:
return $default(_that.type,_that.title,_that.primaryValue,_that.secondaryValue,_that.comparison);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String title,  String primaryValue,  String? secondaryValue,  String? comparison)  $default,) {final _that = this;
switch (_that) {
case _WrappedInsight():
return $default(_that.type,_that.title,_that.primaryValue,_that.secondaryValue,_that.comparison);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String title,  String primaryValue,  String? secondaryValue,  String? comparison)?  $default,) {final _that = this;
switch (_that) {
case _WrappedInsight() when $default != null:
return $default(_that.type,_that.title,_that.primaryValue,_that.secondaryValue,_that.comparison);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedInsight implements WrappedInsight {
  const _WrappedInsight({required this.type, required this.title, required this.primaryValue, this.secondaryValue, this.comparison});
  factory _WrappedInsight.fromJson(Map<String, dynamic> json) => _$WrappedInsightFromJson(json);

@override final  String type;
@override final  String title;
@override final  String primaryValue;
@override final  String? secondaryValue;
@override final  String? comparison;

/// Create a copy of WrappedInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedInsightCopyWith<_WrappedInsight> get copyWith => __$WrappedInsightCopyWithImpl<_WrappedInsight>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedInsightToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedInsight&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.primaryValue, primaryValue) || other.primaryValue == primaryValue)&&(identical(other.secondaryValue, secondaryValue) || other.secondaryValue == secondaryValue)&&(identical(other.comparison, comparison) || other.comparison == comparison));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,primaryValue,secondaryValue,comparison);

@override
String toString() {
  return 'WrappedInsight(type: $type, title: $title, primaryValue: $primaryValue, secondaryValue: $secondaryValue, comparison: $comparison)';
}


}

/// @nodoc
abstract mixin class _$WrappedInsightCopyWith<$Res> implements $WrappedInsightCopyWith<$Res> {
  factory _$WrappedInsightCopyWith(_WrappedInsight value, $Res Function(_WrappedInsight) _then) = __$WrappedInsightCopyWithImpl;
@override @useResult
$Res call({
 String type, String title, String primaryValue, String? secondaryValue, String? comparison
});




}
/// @nodoc
class __$WrappedInsightCopyWithImpl<$Res>
    implements _$WrappedInsightCopyWith<$Res> {
  __$WrappedInsightCopyWithImpl(this._self, this._then);

  final _WrappedInsight _self;
  final $Res Function(_WrappedInsight) _then;

/// Create a copy of WrappedInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? primaryValue = null,Object? secondaryValue = freezed,Object? comparison = freezed,}) {
  return _then(_WrappedInsight(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,primaryValue: null == primaryValue ? _self.primaryValue : primaryValue // ignore: cast_nullable_to_non_nullable
as String,secondaryValue: freezed == secondaryValue ? _self.secondaryValue : secondaryValue // ignore: cast_nullable_to_non_nullable
as String?,comparison: freezed == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WrappedGoal {

 String get message;
/// Create a copy of WrappedGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedGoalCopyWith<WrappedGoal> get copyWith => _$WrappedGoalCopyWithImpl<WrappedGoal>(this as WrappedGoal, _$identity);

  /// Serializes this WrappedGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedGoal&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'WrappedGoal(message: $message)';
}


}

/// @nodoc
abstract mixin class $WrappedGoalCopyWith<$Res>  {
  factory $WrappedGoalCopyWith(WrappedGoal value, $Res Function(WrappedGoal) _then) = _$WrappedGoalCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$WrappedGoalCopyWithImpl<$Res>
    implements $WrappedGoalCopyWith<$Res> {
  _$WrappedGoalCopyWithImpl(this._self, this._then);

  final WrappedGoal _self;
  final $Res Function(WrappedGoal) _then;

/// Create a copy of WrappedGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(WrappedGoal(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WrappedGoal].
extension WrappedGoalPatterns on WrappedGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedGoal value)  $default,){
final _that = this;
switch (_that) {
case _WrappedGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedGoal value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedGoal() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _WrappedGoal():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _WrappedGoal() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedGoal implements WrappedGoal {
  const _WrappedGoal({required this.message});
  factory _WrappedGoal.fromJson(Map<String, dynamic> json) => _$WrappedGoalFromJson(json);

@override final  String message;

/// Create a copy of WrappedGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedGoalCopyWith<_WrappedGoal> get copyWith => __$WrappedGoalCopyWithImpl<_WrappedGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedGoal&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'WrappedGoal(message: $message)';
}


}

/// @nodoc
abstract mixin class _$WrappedGoalCopyWith<$Res> implements $WrappedGoalCopyWith<$Res> {
  factory _$WrappedGoalCopyWith(_WrappedGoal value, $Res Function(_WrappedGoal) _then) = __$WrappedGoalCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$WrappedGoalCopyWithImpl<$Res>
    implements _$WrappedGoalCopyWith<$Res> {
  __$WrappedGoalCopyWithImpl(this._self, this._then);

  final _WrappedGoal _self;
  final $Res Function(_WrappedGoal) _then;

/// Create a copy of WrappedGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_WrappedGoal(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WrappedResult {

 int get year; int get month; int get version; String get generatedAt; bool get sufficientData; WrappedOverview get overview; WrappedPersona? get persona; List<WrappedInsight> get insights; WrappedGoal get recommendedGoal; WrappedStoryData? get story;
/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrappedResultCopyWith<WrappedResult> get copyWith => _$WrappedResultCopyWithImpl<WrappedResult>(this as WrappedResult, _$identity);

  /// Serializes this WrappedResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrappedResult&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.version, version) || other.version == version)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.sufficientData, sufficientData) || other.sufficientData == sufficientData)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.persona, persona) || other.persona == persona)&&const DeepCollectionEquality().equals(other.insights, insights)&&(identical(other.recommendedGoal, recommendedGoal) || other.recommendedGoal == recommendedGoal)&&(identical(other.story, story) || other.story == story));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,version,generatedAt,sufficientData,overview,persona,const DeepCollectionEquality().hash(insights),recommendedGoal,story);

@override
String toString() {
  return 'WrappedResult(year: $year, month: $month, version: $version, generatedAt: $generatedAt, sufficientData: $sufficientData, overview: $overview, persona: $persona, insights: $insights, recommendedGoal: $recommendedGoal, story: $story)';
}


}

/// @nodoc
abstract mixin class $WrappedResultCopyWith<$Res>  {
  factory $WrappedResultCopyWith(WrappedResult value, $Res Function(WrappedResult) _then) = _$WrappedResultCopyWithImpl;
@useResult
$Res call({
 int year, int month, int version, String generatedAt, bool sufficientData, WrappedOverview overview, WrappedPersona? persona, List<WrappedInsight> insights, WrappedGoal recommendedGoal, WrappedStoryData? story
});


$WrappedOverviewCopyWith<$Res> get overview;$WrappedPersonaCopyWith<$Res>? get persona;$WrappedGoalCopyWith<$Res> get recommendedGoal;

}
/// @nodoc
class _$WrappedResultCopyWithImpl<$Res>
    implements $WrappedResultCopyWith<$Res> {
  _$WrappedResultCopyWithImpl(this._self, this._then);

  final WrappedResult _self;
  final $Res Function(WrappedResult) _then;

/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? version = null,Object? generatedAt = null,Object? sufficientData = null,Object? overview = null,Object? persona = freezed,Object? insights = null,Object? recommendedGoal = null,Object? story = freezed,}) {
  return _then(WrappedResult(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String,sufficientData: null == sufficientData ? _self.sufficientData : sufficientData // ignore: cast_nullable_to_non_nullable
as bool,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as WrappedOverview,persona: freezed == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as WrappedPersona?,insights: null == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as List<WrappedInsight>,recommendedGoal: null == recommendedGoal ? _self.recommendedGoal : recommendedGoal // ignore: cast_nullable_to_non_nullable
as WrappedGoal,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as WrappedStoryData?,
  ));
}
/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WrappedOverviewCopyWith<$Res> get overview {
  
  return $WrappedOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WrappedPersonaCopyWith<$Res>? get persona {
    if (_self.persona == null) {
    return null;
  }

  return $WrappedPersonaCopyWith<$Res>(_self.persona!, (value) {
    return _then(_self.copyWith(persona: value));
  });
}/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WrappedGoalCopyWith<$Res> get recommendedGoal {
  
  return $WrappedGoalCopyWith<$Res>(_self.recommendedGoal, (value) {
    return _then(_self.copyWith(recommendedGoal: value));
  });
}
}


/// Adds pattern-matching-related methods to [WrappedResult].
extension WrappedResultPatterns on WrappedResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrappedResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrappedResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrappedResult value)  $default,){
final _that = this;
switch (_that) {
case _WrappedResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrappedResult value)?  $default,){
final _that = this;
switch (_that) {
case _WrappedResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  int version,  String generatedAt,  bool sufficientData,  WrappedOverview overview,  WrappedPersona? persona,  List<WrappedInsight> insights,  WrappedGoal recommendedGoal,  WrappedStoryData? story)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrappedResult() when $default != null:
return $default(_that.year,_that.month,_that.version,_that.generatedAt,_that.sufficientData,_that.overview,_that.persona,_that.insights,_that.recommendedGoal,_that.story);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  int version,  String generatedAt,  bool sufficientData,  WrappedOverview overview,  WrappedPersona? persona,  List<WrappedInsight> insights,  WrappedGoal recommendedGoal,  WrappedStoryData? story)  $default,) {final _that = this;
switch (_that) {
case _WrappedResult():
return $default(_that.year,_that.month,_that.version,_that.generatedAt,_that.sufficientData,_that.overview,_that.persona,_that.insights,_that.recommendedGoal,_that.story);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  int version,  String generatedAt,  bool sufficientData,  WrappedOverview overview,  WrappedPersona? persona,  List<WrappedInsight> insights,  WrappedGoal recommendedGoal,  WrappedStoryData? story)?  $default,) {final _that = this;
switch (_that) {
case _WrappedResult() when $default != null:
return $default(_that.year,_that.month,_that.version,_that.generatedAt,_that.sufficientData,_that.overview,_that.persona,_that.insights,_that.recommendedGoal,_that.story);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrappedResult implements WrappedResult {
  const _WrappedResult({required this.year, required this.month, required this.version, required this.generatedAt, required this.sufficientData, required this.overview, this.persona, required  List<WrappedInsight> insights, required this.recommendedGoal, this.story}): _insights = insights;
  factory _WrappedResult.fromJson(Map<String, dynamic> json) => _$WrappedResultFromJson(json);

@override final  int year;
@override final  int month;
@override final  int version;
@override final  String generatedAt;
@override final  bool sufficientData;
@override final  WrappedOverview overview;
@override final  WrappedPersona? persona;
 final  List<WrappedInsight> _insights;
@override List<WrappedInsight> get insights {
  if (_insights is EqualUnmodifiableListView) return _insights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_insights);
}

@override final  WrappedGoal recommendedGoal;
@override final  WrappedStoryData? story;

/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrappedResultCopyWith<_WrappedResult> get copyWith => __$WrappedResultCopyWithImpl<_WrappedResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrappedResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrappedResult&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.version, version) || other.version == version)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.sufficientData, sufficientData) || other.sufficientData == sufficientData)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.persona, persona) || other.persona == persona)&&const DeepCollectionEquality().equals(other._insights, _insights)&&(identical(other.recommendedGoal, recommendedGoal) || other.recommendedGoal == recommendedGoal)&&(identical(other.story, story) || other.story == story));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,version,generatedAt,sufficientData,overview,persona,const DeepCollectionEquality().hash(_insights),recommendedGoal,story);

@override
String toString() {
  return 'WrappedResult(year: $year, month: $month, version: $version, generatedAt: $generatedAt, sufficientData: $sufficientData, overview: $overview, persona: $persona, insights: $insights, recommendedGoal: $recommendedGoal, story: $story)';
}


}

/// @nodoc
abstract mixin class _$WrappedResultCopyWith<$Res> implements $WrappedResultCopyWith<$Res> {
  factory _$WrappedResultCopyWith(_WrappedResult value, $Res Function(_WrappedResult) _then) = __$WrappedResultCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, int version, String generatedAt, bool sufficientData, WrappedOverview overview, WrappedPersona? persona, List<WrappedInsight> insights, WrappedGoal recommendedGoal, WrappedStoryData? story
});


@override $WrappedOverviewCopyWith<$Res> get overview;@override $WrappedPersonaCopyWith<$Res>? get persona;@override $WrappedGoalCopyWith<$Res> get recommendedGoal;

}
/// @nodoc
class __$WrappedResultCopyWithImpl<$Res>
    implements _$WrappedResultCopyWith<$Res> {
  __$WrappedResultCopyWithImpl(this._self, this._then);

  final _WrappedResult _self;
  final $Res Function(_WrappedResult) _then;

/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? version = null,Object? generatedAt = null,Object? sufficientData = null,Object? overview = null,Object? persona = freezed,Object? insights = null,Object? recommendedGoal = null,Object? story = freezed,}) {
  return _then(_WrappedResult(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String,sufficientData: null == sufficientData ? _self.sufficientData : sufficientData // ignore: cast_nullable_to_non_nullable
as bool,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as WrappedOverview,persona: freezed == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as WrappedPersona?,insights: null == insights ? _self._insights : insights // ignore: cast_nullable_to_non_nullable
as List<WrappedInsight>,recommendedGoal: null == recommendedGoal ? _self.recommendedGoal : recommendedGoal // ignore: cast_nullable_to_non_nullable
as WrappedGoal,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as WrappedStoryData?,
  ));
}

/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WrappedOverviewCopyWith<$Res> get overview {
  
  return $WrappedOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WrappedPersonaCopyWith<$Res>? get persona {
    if (_self.persona == null) {
    return null;
  }

  return $WrappedPersonaCopyWith<$Res>(_self.persona!, (value) {
    return _then(_self.copyWith(persona: value));
  });
}/// Create a copy of WrappedResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WrappedGoalCopyWith<$Res> get recommendedGoal {
  
  return $WrappedGoalCopyWith<$Res>(_self.recommendedGoal, (value) {
    return _then(_self.copyWith(recommendedGoal: value));
  });
}
}

// dart format on
