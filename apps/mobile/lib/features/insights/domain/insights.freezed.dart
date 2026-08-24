// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategorySpending {

 String get categoryId; String get categoryName;@AmountConverter() String get amount;
/// Create a copy of CategorySpending
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySpendingCopyWith<CategorySpending> get copyWith => _$CategorySpendingCopyWithImpl<CategorySpending>(this as CategorySpending, _$identity);

  /// Serializes this CategorySpending to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySpending&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,amount);

@override
String toString() {
  return 'CategorySpending(categoryId: $categoryId, categoryName: $categoryName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $CategorySpendingCopyWith<$Res>  {
  factory $CategorySpendingCopyWith(CategorySpending value, $Res Function(CategorySpending) _then) = _$CategorySpendingCopyWithImpl;
@useResult
$Res call({
 String categoryId, String categoryName,@AmountConverter() String amount
});




}
/// @nodoc
class _$CategorySpendingCopyWithImpl<$Res>
    implements $CategorySpendingCopyWith<$Res> {
  _$CategorySpendingCopyWithImpl(this._self, this._then);

  final CategorySpending _self;
  final $Res Function(CategorySpending) _then;

/// Create a copy of CategorySpending
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? amount = null,}) {
  return _then(CategorySpending(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySpending].
extension CategorySpendingPatterns on CategorySpending {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySpending value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySpending() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySpending value)  $default,){
final _that = this;
switch (_that) {
case _CategorySpending():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySpending value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySpending() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String categoryName, @AmountConverter()  String amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySpending() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String categoryName, @AmountConverter()  String amount)  $default,) {final _that = this;
switch (_that) {
case _CategorySpending():
return $default(_that.categoryId,_that.categoryName,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String categoryName, @AmountConverter()  String amount)?  $default,) {final _that = this;
switch (_that) {
case _CategorySpending() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategorySpending implements CategorySpending {
  const _CategorySpending({required this.categoryId, required this.categoryName, @AmountConverter() required this.amount});
  factory _CategorySpending.fromJson(Map<String, dynamic> json) => _$CategorySpendingFromJson(json);

@override final  String categoryId;
@override final  String categoryName;
@override@AmountConverter() final  String amount;

/// Create a copy of CategorySpending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySpendingCopyWith<_CategorySpending> get copyWith => __$CategorySpendingCopyWithImpl<_CategorySpending>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategorySpendingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySpending&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,amount);

@override
String toString() {
  return 'CategorySpending(categoryId: $categoryId, categoryName: $categoryName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$CategorySpendingCopyWith<$Res> implements $CategorySpendingCopyWith<$Res> {
  factory _$CategorySpendingCopyWith(_CategorySpending value, $Res Function(_CategorySpending) _then) = __$CategorySpendingCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String categoryName,@AmountConverter() String amount
});




}
/// @nodoc
class __$CategorySpendingCopyWithImpl<$Res>
    implements _$CategorySpendingCopyWith<$Res> {
  __$CategorySpendingCopyWithImpl(this._self, this._then);

  final _CategorySpending _self;
  final $Res Function(_CategorySpending) _then;

/// Create a copy of CategorySpending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? amount = null,}) {
  return _then(_CategorySpending(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MonthlyTrend {

 int get year; int get month;@AmountConverter() String get income;@AmountConverter() String get expense;@AmountConverter() String get savings;
/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyTrendCopyWith<MonthlyTrend> get copyWith => _$MonthlyTrendCopyWithImpl<MonthlyTrend>(this as MonthlyTrend, _$identity);

  /// Serializes this MonthlyTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyTrend&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.savings, savings) || other.savings == savings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,income,expense,savings);

@override
String toString() {
  return 'MonthlyTrend(year: $year, month: $month, income: $income, expense: $expense, savings: $savings)';
}


}

/// @nodoc
abstract mixin class $MonthlyTrendCopyWith<$Res>  {
  factory $MonthlyTrendCopyWith(MonthlyTrend value, $Res Function(MonthlyTrend) _then) = _$MonthlyTrendCopyWithImpl;
@useResult
$Res call({
 int year, int month,@AmountConverter() String income,@AmountConverter() String expense,@AmountConverter() String savings
});




}
/// @nodoc
class _$MonthlyTrendCopyWithImpl<$Res>
    implements $MonthlyTrendCopyWith<$Res> {
  _$MonthlyTrendCopyWithImpl(this._self, this._then);

  final MonthlyTrend _self;
  final $Res Function(MonthlyTrend) _then;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? income = null,Object? expense = null,Object? savings = null,}) {
  return _then(MonthlyTrend(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as String,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as String,savings: null == savings ? _self.savings : savings // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyTrend].
extension MonthlyTrendPatterns on MonthlyTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyTrend value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyTrend value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month, @AmountConverter()  String income, @AmountConverter()  String expense, @AmountConverter()  String savings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
return $default(_that.year,_that.month,_that.income,_that.expense,_that.savings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month, @AmountConverter()  String income, @AmountConverter()  String expense, @AmountConverter()  String savings)  $default,) {final _that = this;
switch (_that) {
case _MonthlyTrend():
return $default(_that.year,_that.month,_that.income,_that.expense,_that.savings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month, @AmountConverter()  String income, @AmountConverter()  String expense, @AmountConverter()  String savings)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
return $default(_that.year,_that.month,_that.income,_that.expense,_that.savings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyTrend implements MonthlyTrend {
  const _MonthlyTrend({required this.year, required this.month, @AmountConverter() required this.income, @AmountConverter() required this.expense, @AmountConverter() required this.savings});
  factory _MonthlyTrend.fromJson(Map<String, dynamic> json) => _$MonthlyTrendFromJson(json);

@override final  int year;
@override final  int month;
@override@AmountConverter() final  String income;
@override@AmountConverter() final  String expense;
@override@AmountConverter() final  String savings;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyTrendCopyWith<_MonthlyTrend> get copyWith => __$MonthlyTrendCopyWithImpl<_MonthlyTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyTrend&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.savings, savings) || other.savings == savings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,income,expense,savings);

@override
String toString() {
  return 'MonthlyTrend(year: $year, month: $month, income: $income, expense: $expense, savings: $savings)';
}


}

/// @nodoc
abstract mixin class _$MonthlyTrendCopyWith<$Res> implements $MonthlyTrendCopyWith<$Res> {
  factory _$MonthlyTrendCopyWith(_MonthlyTrend value, $Res Function(_MonthlyTrend) _then) = __$MonthlyTrendCopyWithImpl;
@override @useResult
$Res call({
 int year, int month,@AmountConverter() String income,@AmountConverter() String expense,@AmountConverter() String savings
});




}
/// @nodoc
class __$MonthlyTrendCopyWithImpl<$Res>
    implements _$MonthlyTrendCopyWith<$Res> {
  __$MonthlyTrendCopyWithImpl(this._self, this._then);

  final _MonthlyTrend _self;
  final $Res Function(_MonthlyTrend) _then;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? income = null,Object? expense = null,Object? savings = null,}) {
  return _then(_MonthlyTrend(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as String,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as String,savings: null == savings ? _self.savings : savings // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MerchantSpending {

 String get merchant;@AmountConverter() String get amount; int get transactionCount;
/// Create a copy of MerchantSpending
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantSpendingCopyWith<MerchantSpending> get copyWith => _$MerchantSpendingCopyWithImpl<MerchantSpending>(this as MerchantSpending, _$identity);

  /// Serializes this MerchantSpending to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantSpending&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,merchant,amount,transactionCount);

@override
String toString() {
  return 'MerchantSpending(merchant: $merchant, amount: $amount, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class $MerchantSpendingCopyWith<$Res>  {
  factory $MerchantSpendingCopyWith(MerchantSpending value, $Res Function(MerchantSpending) _then) = _$MerchantSpendingCopyWithImpl;
@useResult
$Res call({
 String merchant,@AmountConverter() String amount, int transactionCount
});




}
/// @nodoc
class _$MerchantSpendingCopyWithImpl<$Res>
    implements $MerchantSpendingCopyWith<$Res> {
  _$MerchantSpendingCopyWithImpl(this._self, this._then);

  final MerchantSpending _self;
  final $Res Function(MerchantSpending) _then;

/// Create a copy of MerchantSpending
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? merchant = null,Object? amount = null,Object? transactionCount = null,}) {
  return _then(MerchantSpending(
merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantSpending].
extension MerchantSpendingPatterns on MerchantSpending {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantSpending value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantSpending() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantSpending value)  $default,){
final _that = this;
switch (_that) {
case _MerchantSpending():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantSpending value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantSpending() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String merchant, @AmountConverter()  String amount,  int transactionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantSpending() when $default != null:
return $default(_that.merchant,_that.amount,_that.transactionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String merchant, @AmountConverter()  String amount,  int transactionCount)  $default,) {final _that = this;
switch (_that) {
case _MerchantSpending():
return $default(_that.merchant,_that.amount,_that.transactionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String merchant, @AmountConverter()  String amount,  int transactionCount)?  $default,) {final _that = this;
switch (_that) {
case _MerchantSpending() when $default != null:
return $default(_that.merchant,_that.amount,_that.transactionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantSpending implements MerchantSpending {
  const _MerchantSpending({required this.merchant, @AmountConverter() required this.amount, required this.transactionCount});
  factory _MerchantSpending.fromJson(Map<String, dynamic> json) => _$MerchantSpendingFromJson(json);

@override final  String merchant;
@override@AmountConverter() final  String amount;
@override final  int transactionCount;

/// Create a copy of MerchantSpending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantSpendingCopyWith<_MerchantSpending> get copyWith => __$MerchantSpendingCopyWithImpl<_MerchantSpending>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantSpendingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantSpending&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,merchant,amount,transactionCount);

@override
String toString() {
  return 'MerchantSpending(merchant: $merchant, amount: $amount, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class _$MerchantSpendingCopyWith<$Res> implements $MerchantSpendingCopyWith<$Res> {
  factory _$MerchantSpendingCopyWith(_MerchantSpending value, $Res Function(_MerchantSpending) _then) = __$MerchantSpendingCopyWithImpl;
@override @useResult
$Res call({
 String merchant,@AmountConverter() String amount, int transactionCount
});




}
/// @nodoc
class __$MerchantSpendingCopyWithImpl<$Res>
    implements _$MerchantSpendingCopyWith<$Res> {
  __$MerchantSpendingCopyWithImpl(this._self, this._then);

  final _MerchantSpending _self;
  final $Res Function(_MerchantSpending) _then;

/// Create a copy of MerchantSpending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? merchant = null,Object? amount = null,Object? transactionCount = null,}) {
  return _then(_MerchantSpending(
merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CalendarEntry {

 String get date; bool get confirmed; TransactionType get type; TransactionDirection get direction;@AmountConverter() String get amount; String? get merchant; String? get description;
/// Create a copy of CalendarEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEntryCopyWith<CalendarEntry> get copyWith => _$CalendarEntryCopyWithImpl<CalendarEntry>(this as CalendarEntry, _$identity);

  /// Serializes this CalendarEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEntry&&(identical(other.date, date) || other.date == date)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.type, type) || other.type == type)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,confirmed,type,direction,amount,merchant,description);

@override
String toString() {
  return 'CalendarEntry(date: $date, confirmed: $confirmed, type: $type, direction: $direction, amount: $amount, merchant: $merchant, description: $description)';
}


}

/// @nodoc
abstract mixin class $CalendarEntryCopyWith<$Res>  {
  factory $CalendarEntryCopyWith(CalendarEntry value, $Res Function(CalendarEntry) _then) = _$CalendarEntryCopyWithImpl;
@useResult
$Res call({
 String date, bool confirmed, TransactionType type, TransactionDirection direction,@AmountConverter() String amount, String? merchant, String? description
});




}
/// @nodoc
class _$CalendarEntryCopyWithImpl<$Res>
    implements $CalendarEntryCopyWith<$Res> {
  _$CalendarEntryCopyWithImpl(this._self, this._then);

  final CalendarEntry _self;
  final $Res Function(CalendarEntry) _then;

/// Create a copy of CalendarEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? confirmed = null,Object? type = null,Object? direction = null,Object? amount = null,Object? merchant = freezed,Object? description = freezed,}) {
  return _then(CalendarEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransactionDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarEntry].
extension CalendarEntryPatterns on CalendarEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEntry value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  bool confirmed,  TransactionType type,  TransactionDirection direction, @AmountConverter()  String amount,  String? merchant,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarEntry() when $default != null:
return $default(_that.date,_that.confirmed,_that.type,_that.direction,_that.amount,_that.merchant,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  bool confirmed,  TransactionType type,  TransactionDirection direction, @AmountConverter()  String amount,  String? merchant,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CalendarEntry():
return $default(_that.date,_that.confirmed,_that.type,_that.direction,_that.amount,_that.merchant,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  bool confirmed,  TransactionType type,  TransactionDirection direction, @AmountConverter()  String amount,  String? merchant,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CalendarEntry() when $default != null:
return $default(_that.date,_that.confirmed,_that.type,_that.direction,_that.amount,_that.merchant,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarEntry implements CalendarEntry {
  const _CalendarEntry({required this.date, required this.confirmed, required this.type, required this.direction, @AmountConverter() required this.amount, this.merchant, this.description});
  factory _CalendarEntry.fromJson(Map<String, dynamic> json) => _$CalendarEntryFromJson(json);

@override final  String date;
@override final  bool confirmed;
@override final  TransactionType type;
@override final  TransactionDirection direction;
@override@AmountConverter() final  String amount;
@override final  String? merchant;
@override final  String? description;

/// Create a copy of CalendarEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEntryCopyWith<_CalendarEntry> get copyWith => __$CalendarEntryCopyWithImpl<_CalendarEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEntry&&(identical(other.date, date) || other.date == date)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.type, type) || other.type == type)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,confirmed,type,direction,amount,merchant,description);

@override
String toString() {
  return 'CalendarEntry(date: $date, confirmed: $confirmed, type: $type, direction: $direction, amount: $amount, merchant: $merchant, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CalendarEntryCopyWith<$Res> implements $CalendarEntryCopyWith<$Res> {
  factory _$CalendarEntryCopyWith(_CalendarEntry value, $Res Function(_CalendarEntry) _then) = __$CalendarEntryCopyWithImpl;
@override @useResult
$Res call({
 String date, bool confirmed, TransactionType type, TransactionDirection direction,@AmountConverter() String amount, String? merchant, String? description
});




}
/// @nodoc
class __$CalendarEntryCopyWithImpl<$Res>
    implements _$CalendarEntryCopyWith<$Res> {
  __$CalendarEntryCopyWithImpl(this._self, this._then);

  final _CalendarEntry _self;
  final $Res Function(_CalendarEntry) _then;

/// Create a copy of CalendarEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? confirmed = null,Object? type = null,Object? direction = null,Object? amount = null,Object? merchant = freezed,Object? description = freezed,}) {
  return _then(_CalendarEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransactionDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Forecast {

@AmountConverter() String get currentBalance; String get asOfDate; String get targetDate;@AmountConverter() String get scheduledIncome;@AmountConverter() String get scheduledExpense;@AmountConverter() String get predictedVariableExpense;@AmountConverter() String get projectedBalance; String get disclaimer;
/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastCopyWith<Forecast> get copyWith => _$ForecastCopyWithImpl<Forecast>(this as Forecast, _$identity);

  /// Serializes this Forecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Forecast&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.asOfDate, asOfDate) || other.asOfDate == asOfDate)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.scheduledIncome, scheduledIncome) || other.scheduledIncome == scheduledIncome)&&(identical(other.scheduledExpense, scheduledExpense) || other.scheduledExpense == scheduledExpense)&&(identical(other.predictedVariableExpense, predictedVariableExpense) || other.predictedVariableExpense == predictedVariableExpense)&&(identical(other.projectedBalance, projectedBalance) || other.projectedBalance == projectedBalance)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentBalance,asOfDate,targetDate,scheduledIncome,scheduledExpense,predictedVariableExpense,projectedBalance,disclaimer);

@override
String toString() {
  return 'Forecast(currentBalance: $currentBalance, asOfDate: $asOfDate, targetDate: $targetDate, scheduledIncome: $scheduledIncome, scheduledExpense: $scheduledExpense, predictedVariableExpense: $predictedVariableExpense, projectedBalance: $projectedBalance, disclaimer: $disclaimer)';
}


}

/// @nodoc
abstract mixin class $ForecastCopyWith<$Res>  {
  factory $ForecastCopyWith(Forecast value, $Res Function(Forecast) _then) = _$ForecastCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String currentBalance, String asOfDate, String targetDate,@AmountConverter() String scheduledIncome,@AmountConverter() String scheduledExpense,@AmountConverter() String predictedVariableExpense,@AmountConverter() String projectedBalance, String disclaimer
});




}
/// @nodoc
class _$ForecastCopyWithImpl<$Res>
    implements $ForecastCopyWith<$Res> {
  _$ForecastCopyWithImpl(this._self, this._then);

  final Forecast _self;
  final $Res Function(Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentBalance = null,Object? asOfDate = null,Object? targetDate = null,Object? scheduledIncome = null,Object? scheduledExpense = null,Object? predictedVariableExpense = null,Object? projectedBalance = null,Object? disclaimer = null,}) {
  return _then(Forecast(
currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as String,asOfDate: null == asOfDate ? _self.asOfDate : asOfDate // ignore: cast_nullable_to_non_nullable
as String,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as String,scheduledIncome: null == scheduledIncome ? _self.scheduledIncome : scheduledIncome // ignore: cast_nullable_to_non_nullable
as String,scheduledExpense: null == scheduledExpense ? _self.scheduledExpense : scheduledExpense // ignore: cast_nullable_to_non_nullable
as String,predictedVariableExpense: null == predictedVariableExpense ? _self.predictedVariableExpense : predictedVariableExpense // ignore: cast_nullable_to_non_nullable
as String,projectedBalance: null == projectedBalance ? _self.projectedBalance : projectedBalance // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Forecast].
extension ForecastPatterns on Forecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Forecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Forecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Forecast value)  $default,){
final _that = this;
switch (_that) {
case _Forecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Forecast value)?  $default,){
final _that = this;
switch (_that) {
case _Forecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String currentBalance,  String asOfDate,  String targetDate, @AmountConverter()  String scheduledIncome, @AmountConverter()  String scheduledExpense, @AmountConverter()  String predictedVariableExpense, @AmountConverter()  String projectedBalance,  String disclaimer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.currentBalance,_that.asOfDate,_that.targetDate,_that.scheduledIncome,_that.scheduledExpense,_that.predictedVariableExpense,_that.projectedBalance,_that.disclaimer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String currentBalance,  String asOfDate,  String targetDate, @AmountConverter()  String scheduledIncome, @AmountConverter()  String scheduledExpense, @AmountConverter()  String predictedVariableExpense, @AmountConverter()  String projectedBalance,  String disclaimer)  $default,) {final _that = this;
switch (_that) {
case _Forecast():
return $default(_that.currentBalance,_that.asOfDate,_that.targetDate,_that.scheduledIncome,_that.scheduledExpense,_that.predictedVariableExpense,_that.projectedBalance,_that.disclaimer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String currentBalance,  String asOfDate,  String targetDate, @AmountConverter()  String scheduledIncome, @AmountConverter()  String scheduledExpense, @AmountConverter()  String predictedVariableExpense, @AmountConverter()  String projectedBalance,  String disclaimer)?  $default,) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.currentBalance,_that.asOfDate,_that.targetDate,_that.scheduledIncome,_that.scheduledExpense,_that.predictedVariableExpense,_that.projectedBalance,_that.disclaimer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Forecast implements Forecast {
  const _Forecast({@AmountConverter() required this.currentBalance, required this.asOfDate, required this.targetDate, @AmountConverter() required this.scheduledIncome, @AmountConverter() required this.scheduledExpense, @AmountConverter() required this.predictedVariableExpense, @AmountConverter() required this.projectedBalance, required this.disclaimer});
  factory _Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);

@override@AmountConverter() final  String currentBalance;
@override final  String asOfDate;
@override final  String targetDate;
@override@AmountConverter() final  String scheduledIncome;
@override@AmountConverter() final  String scheduledExpense;
@override@AmountConverter() final  String predictedVariableExpense;
@override@AmountConverter() final  String projectedBalance;
@override final  String disclaimer;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastCopyWith<_Forecast> get copyWith => __$ForecastCopyWithImpl<_Forecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Forecast&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.asOfDate, asOfDate) || other.asOfDate == asOfDate)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.scheduledIncome, scheduledIncome) || other.scheduledIncome == scheduledIncome)&&(identical(other.scheduledExpense, scheduledExpense) || other.scheduledExpense == scheduledExpense)&&(identical(other.predictedVariableExpense, predictedVariableExpense) || other.predictedVariableExpense == predictedVariableExpense)&&(identical(other.projectedBalance, projectedBalance) || other.projectedBalance == projectedBalance)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentBalance,asOfDate,targetDate,scheduledIncome,scheduledExpense,predictedVariableExpense,projectedBalance,disclaimer);

@override
String toString() {
  return 'Forecast(currentBalance: $currentBalance, asOfDate: $asOfDate, targetDate: $targetDate, scheduledIncome: $scheduledIncome, scheduledExpense: $scheduledExpense, predictedVariableExpense: $predictedVariableExpense, projectedBalance: $projectedBalance, disclaimer: $disclaimer)';
}


}

/// @nodoc
abstract mixin class _$ForecastCopyWith<$Res> implements $ForecastCopyWith<$Res> {
  factory _$ForecastCopyWith(_Forecast value, $Res Function(_Forecast) _then) = __$ForecastCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String currentBalance, String asOfDate, String targetDate,@AmountConverter() String scheduledIncome,@AmountConverter() String scheduledExpense,@AmountConverter() String predictedVariableExpense,@AmountConverter() String projectedBalance, String disclaimer
});




}
/// @nodoc
class __$ForecastCopyWithImpl<$Res>
    implements _$ForecastCopyWith<$Res> {
  __$ForecastCopyWithImpl(this._self, this._then);

  final _Forecast _self;
  final $Res Function(_Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentBalance = null,Object? asOfDate = null,Object? targetDate = null,Object? scheduledIncome = null,Object? scheduledExpense = null,Object? predictedVariableExpense = null,Object? projectedBalance = null,Object? disclaimer = null,}) {
  return _then(_Forecast(
currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as String,asOfDate: null == asOfDate ? _self.asOfDate : asOfDate // ignore: cast_nullable_to_non_nullable
as String,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as String,scheduledIncome: null == scheduledIncome ? _self.scheduledIncome : scheduledIncome // ignore: cast_nullable_to_non_nullable
as String,scheduledExpense: null == scheduledExpense ? _self.scheduledExpense : scheduledExpense // ignore: cast_nullable_to_non_nullable
as String,predictedVariableExpense: null == predictedVariableExpense ? _self.predictedVariableExpense : predictedVariableExpense // ignore: cast_nullable_to_non_nullable
as String,projectedBalance: null == projectedBalance ? _self.projectedBalance : projectedBalance // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
