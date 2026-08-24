// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessDashboard {

@AmountConverter() String get cashPosition;@AmountConverter() String get totalReceivables;@AmountConverter() String get totalPayables; int get customerCount; int get supplierCount; int get productCount; int get openInvoiceCount; int get unpaidExpenseCount;
/// Create a copy of BusinessDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessDashboardCopyWith<BusinessDashboard> get copyWith => _$BusinessDashboardCopyWithImpl<BusinessDashboard>(this as BusinessDashboard, _$identity);

  /// Serializes this BusinessDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessDashboard&&(identical(other.cashPosition, cashPosition) || other.cashPosition == cashPosition)&&(identical(other.totalReceivables, totalReceivables) || other.totalReceivables == totalReceivables)&&(identical(other.totalPayables, totalPayables) || other.totalPayables == totalPayables)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount)&&(identical(other.supplierCount, supplierCount) || other.supplierCount == supplierCount)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.openInvoiceCount, openInvoiceCount) || other.openInvoiceCount == openInvoiceCount)&&(identical(other.unpaidExpenseCount, unpaidExpenseCount) || other.unpaidExpenseCount == unpaidExpenseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cashPosition,totalReceivables,totalPayables,customerCount,supplierCount,productCount,openInvoiceCount,unpaidExpenseCount);

@override
String toString() {
  return 'BusinessDashboard(cashPosition: $cashPosition, totalReceivables: $totalReceivables, totalPayables: $totalPayables, customerCount: $customerCount, supplierCount: $supplierCount, productCount: $productCount, openInvoiceCount: $openInvoiceCount, unpaidExpenseCount: $unpaidExpenseCount)';
}


}

/// @nodoc
abstract mixin class $BusinessDashboardCopyWith<$Res>  {
  factory $BusinessDashboardCopyWith(BusinessDashboard value, $Res Function(BusinessDashboard) _then) = _$BusinessDashboardCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String cashPosition,@AmountConverter() String totalReceivables,@AmountConverter() String totalPayables, int customerCount, int supplierCount, int productCount, int openInvoiceCount, int unpaidExpenseCount
});




}
/// @nodoc
class _$BusinessDashboardCopyWithImpl<$Res>
    implements $BusinessDashboardCopyWith<$Res> {
  _$BusinessDashboardCopyWithImpl(this._self, this._then);

  final BusinessDashboard _self;
  final $Res Function(BusinessDashboard) _then;

/// Create a copy of BusinessDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cashPosition = null,Object? totalReceivables = null,Object? totalPayables = null,Object? customerCount = null,Object? supplierCount = null,Object? productCount = null,Object? openInvoiceCount = null,Object? unpaidExpenseCount = null,}) {
  return _then(BusinessDashboard(
cashPosition: null == cashPosition ? _self.cashPosition : cashPosition // ignore: cast_nullable_to_non_nullable
as String,totalReceivables: null == totalReceivables ? _self.totalReceivables : totalReceivables // ignore: cast_nullable_to_non_nullable
as String,totalPayables: null == totalPayables ? _self.totalPayables : totalPayables // ignore: cast_nullable_to_non_nullable
as String,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,supplierCount: null == supplierCount ? _self.supplierCount : supplierCount // ignore: cast_nullable_to_non_nullable
as int,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,openInvoiceCount: null == openInvoiceCount ? _self.openInvoiceCount : openInvoiceCount // ignore: cast_nullable_to_non_nullable
as int,unpaidExpenseCount: null == unpaidExpenseCount ? _self.unpaidExpenseCount : unpaidExpenseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessDashboard].
extension BusinessDashboardPatterns on BusinessDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessDashboard value)  $default,){
final _that = this;
switch (_that) {
case _BusinessDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String cashPosition, @AmountConverter()  String totalReceivables, @AmountConverter()  String totalPayables,  int customerCount,  int supplierCount,  int productCount,  int openInvoiceCount,  int unpaidExpenseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessDashboard() when $default != null:
return $default(_that.cashPosition,_that.totalReceivables,_that.totalPayables,_that.customerCount,_that.supplierCount,_that.productCount,_that.openInvoiceCount,_that.unpaidExpenseCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String cashPosition, @AmountConverter()  String totalReceivables, @AmountConverter()  String totalPayables,  int customerCount,  int supplierCount,  int productCount,  int openInvoiceCount,  int unpaidExpenseCount)  $default,) {final _that = this;
switch (_that) {
case _BusinessDashboard():
return $default(_that.cashPosition,_that.totalReceivables,_that.totalPayables,_that.customerCount,_that.supplierCount,_that.productCount,_that.openInvoiceCount,_that.unpaidExpenseCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String cashPosition, @AmountConverter()  String totalReceivables, @AmountConverter()  String totalPayables,  int customerCount,  int supplierCount,  int productCount,  int openInvoiceCount,  int unpaidExpenseCount)?  $default,) {final _that = this;
switch (_that) {
case _BusinessDashboard() when $default != null:
return $default(_that.cashPosition,_that.totalReceivables,_that.totalPayables,_that.customerCount,_that.supplierCount,_that.productCount,_that.openInvoiceCount,_that.unpaidExpenseCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessDashboard implements BusinessDashboard {
  const _BusinessDashboard({@AmountConverter() required this.cashPosition, @AmountConverter() required this.totalReceivables, @AmountConverter() required this.totalPayables, required this.customerCount, required this.supplierCount, required this.productCount, required this.openInvoiceCount, required this.unpaidExpenseCount});
  factory _BusinessDashboard.fromJson(Map<String, dynamic> json) => _$BusinessDashboardFromJson(json);

@override@AmountConverter() final  String cashPosition;
@override@AmountConverter() final  String totalReceivables;
@override@AmountConverter() final  String totalPayables;
@override final  int customerCount;
@override final  int supplierCount;
@override final  int productCount;
@override final  int openInvoiceCount;
@override final  int unpaidExpenseCount;

/// Create a copy of BusinessDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessDashboardCopyWith<_BusinessDashboard> get copyWith => __$BusinessDashboardCopyWithImpl<_BusinessDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessDashboard&&(identical(other.cashPosition, cashPosition) || other.cashPosition == cashPosition)&&(identical(other.totalReceivables, totalReceivables) || other.totalReceivables == totalReceivables)&&(identical(other.totalPayables, totalPayables) || other.totalPayables == totalPayables)&&(identical(other.customerCount, customerCount) || other.customerCount == customerCount)&&(identical(other.supplierCount, supplierCount) || other.supplierCount == supplierCount)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.openInvoiceCount, openInvoiceCount) || other.openInvoiceCount == openInvoiceCount)&&(identical(other.unpaidExpenseCount, unpaidExpenseCount) || other.unpaidExpenseCount == unpaidExpenseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cashPosition,totalReceivables,totalPayables,customerCount,supplierCount,productCount,openInvoiceCount,unpaidExpenseCount);

@override
String toString() {
  return 'BusinessDashboard(cashPosition: $cashPosition, totalReceivables: $totalReceivables, totalPayables: $totalPayables, customerCount: $customerCount, supplierCount: $supplierCount, productCount: $productCount, openInvoiceCount: $openInvoiceCount, unpaidExpenseCount: $unpaidExpenseCount)';
}


}

/// @nodoc
abstract mixin class _$BusinessDashboardCopyWith<$Res> implements $BusinessDashboardCopyWith<$Res> {
  factory _$BusinessDashboardCopyWith(_BusinessDashboard value, $Res Function(_BusinessDashboard) _then) = __$BusinessDashboardCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String cashPosition,@AmountConverter() String totalReceivables,@AmountConverter() String totalPayables, int customerCount, int supplierCount, int productCount, int openInvoiceCount, int unpaidExpenseCount
});




}
/// @nodoc
class __$BusinessDashboardCopyWithImpl<$Res>
    implements _$BusinessDashboardCopyWith<$Res> {
  __$BusinessDashboardCopyWithImpl(this._self, this._then);

  final _BusinessDashboard _self;
  final $Res Function(_BusinessDashboard) _then;

/// Create a copy of BusinessDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cashPosition = null,Object? totalReceivables = null,Object? totalPayables = null,Object? customerCount = null,Object? supplierCount = null,Object? productCount = null,Object? openInvoiceCount = null,Object? unpaidExpenseCount = null,}) {
  return _then(_BusinessDashboard(
cashPosition: null == cashPosition ? _self.cashPosition : cashPosition // ignore: cast_nullable_to_non_nullable
as String,totalReceivables: null == totalReceivables ? _self.totalReceivables : totalReceivables // ignore: cast_nullable_to_non_nullable
as String,totalPayables: null == totalPayables ? _self.totalPayables : totalPayables // ignore: cast_nullable_to_non_nullable
as String,customerCount: null == customerCount ? _self.customerCount : customerCount // ignore: cast_nullable_to_non_nullable
as int,supplierCount: null == supplierCount ? _self.supplierCount : supplierCount // ignore: cast_nullable_to_non_nullable
as int,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,openInvoiceCount: null == openInvoiceCount ? _self.openInvoiceCount : openInvoiceCount // ignore: cast_nullable_to_non_nullable
as int,unpaidExpenseCount: null == unpaidExpenseCount ? _self.unpaidExpenseCount : unpaidExpenseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
