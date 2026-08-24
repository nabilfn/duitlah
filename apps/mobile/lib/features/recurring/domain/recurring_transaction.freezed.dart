// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringTransaction {

 String get id; String get accountId; TransactionType get type; TransactionDirection get direction; String? get categoryId;@AmountConverter() String get amount; String? get merchant; String? get description; String? get notes; RecurrenceFrequency get frequency; int get intervalCount; String get startDate; String? get endDate; String get nextOccurrenceDate; bool get isSubscription; bool get active;
/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringTransactionCopyWith<RecurringTransaction> get copyWith => _$RecurringTransactionCopyWithImpl<RecurringTransaction>(this as RecurringTransaction, _$identity);

  /// Serializes this RecurringTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.type, type) || other.type == type)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.intervalCount, intervalCount) || other.intervalCount == intervalCount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextOccurrenceDate, nextOccurrenceDate) || other.nextOccurrenceDate == nextOccurrenceDate)&&(identical(other.isSubscription, isSubscription) || other.isSubscription == isSubscription)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,type,direction,categoryId,amount,merchant,description,notes,frequency,intervalCount,startDate,endDate,nextOccurrenceDate,isSubscription,active);

@override
String toString() {
  return 'RecurringTransaction(id: $id, accountId: $accountId, type: $type, direction: $direction, categoryId: $categoryId, amount: $amount, merchant: $merchant, description: $description, notes: $notes, frequency: $frequency, intervalCount: $intervalCount, startDate: $startDate, endDate: $endDate, nextOccurrenceDate: $nextOccurrenceDate, isSubscription: $isSubscription, active: $active)';
}


}

/// @nodoc
abstract mixin class $RecurringTransactionCopyWith<$Res>  {
  factory $RecurringTransactionCopyWith(RecurringTransaction value, $Res Function(RecurringTransaction) _then) = _$RecurringTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, TransactionType type, TransactionDirection direction, String? categoryId,@AmountConverter() String amount, String? merchant, String? description, String? notes, RecurrenceFrequency frequency, int intervalCount, String startDate, String? endDate, String nextOccurrenceDate, bool isSubscription, bool active
});




}
/// @nodoc
class _$RecurringTransactionCopyWithImpl<$Res>
    implements $RecurringTransactionCopyWith<$Res> {
  _$RecurringTransactionCopyWithImpl(this._self, this._then);

  final RecurringTransaction _self;
  final $Res Function(RecurringTransaction) _then;

/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? type = null,Object? direction = null,Object? categoryId = freezed,Object? amount = null,Object? merchant = freezed,Object? description = freezed,Object? notes = freezed,Object? frequency = null,Object? intervalCount = null,Object? startDate = null,Object? endDate = freezed,Object? nextOccurrenceDate = null,Object? isSubscription = null,Object? active = null,}) {
  return _then(RecurringTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransactionDirection,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,intervalCount: null == intervalCount ? _self.intervalCount : intervalCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,nextOccurrenceDate: null == nextOccurrenceDate ? _self.nextOccurrenceDate : nextOccurrenceDate // ignore: cast_nullable_to_non_nullable
as String,isSubscription: null == isSubscription ? _self.isSubscription : isSubscription // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringTransaction].
extension RecurringTransactionPatterns on RecurringTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringTransaction value)  $default,){
final _that = this;
switch (_that) {
case _RecurringTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String accountId,  TransactionType type,  TransactionDirection direction,  String? categoryId, @AmountConverter()  String amount,  String? merchant,  String? description,  String? notes,  RecurrenceFrequency frequency,  int intervalCount,  String startDate,  String? endDate,  String nextOccurrenceDate,  bool isSubscription,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringTransaction() when $default != null:
return $default(_that.id,_that.accountId,_that.type,_that.direction,_that.categoryId,_that.amount,_that.merchant,_that.description,_that.notes,_that.frequency,_that.intervalCount,_that.startDate,_that.endDate,_that.nextOccurrenceDate,_that.isSubscription,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String accountId,  TransactionType type,  TransactionDirection direction,  String? categoryId, @AmountConverter()  String amount,  String? merchant,  String? description,  String? notes,  RecurrenceFrequency frequency,  int intervalCount,  String startDate,  String? endDate,  String nextOccurrenceDate,  bool isSubscription,  bool active)  $default,) {final _that = this;
switch (_that) {
case _RecurringTransaction():
return $default(_that.id,_that.accountId,_that.type,_that.direction,_that.categoryId,_that.amount,_that.merchant,_that.description,_that.notes,_that.frequency,_that.intervalCount,_that.startDate,_that.endDate,_that.nextOccurrenceDate,_that.isSubscription,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String accountId,  TransactionType type,  TransactionDirection direction,  String? categoryId, @AmountConverter()  String amount,  String? merchant,  String? description,  String? notes,  RecurrenceFrequency frequency,  int intervalCount,  String startDate,  String? endDate,  String nextOccurrenceDate,  bool isSubscription,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _RecurringTransaction() when $default != null:
return $default(_that.id,_that.accountId,_that.type,_that.direction,_that.categoryId,_that.amount,_that.merchant,_that.description,_that.notes,_that.frequency,_that.intervalCount,_that.startDate,_that.endDate,_that.nextOccurrenceDate,_that.isSubscription,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringTransaction implements RecurringTransaction {
  const _RecurringTransaction({required this.id, required this.accountId, required this.type, required this.direction, this.categoryId, @AmountConverter() required this.amount, this.merchant, this.description, this.notes, required this.frequency, required this.intervalCount, required this.startDate, this.endDate, required this.nextOccurrenceDate, required this.isSubscription, required this.active});
  factory _RecurringTransaction.fromJson(Map<String, dynamic> json) => _$RecurringTransactionFromJson(json);

@override final  String id;
@override final  String accountId;
@override final  TransactionType type;
@override final  TransactionDirection direction;
@override final  String? categoryId;
@override@AmountConverter() final  String amount;
@override final  String? merchant;
@override final  String? description;
@override final  String? notes;
@override final  RecurrenceFrequency frequency;
@override final  int intervalCount;
@override final  String startDate;
@override final  String? endDate;
@override final  String nextOccurrenceDate;
@override final  bool isSubscription;
@override final  bool active;

/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringTransactionCopyWith<_RecurringTransaction> get copyWith => __$RecurringTransactionCopyWithImpl<_RecurringTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.type, type) || other.type == type)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.intervalCount, intervalCount) || other.intervalCount == intervalCount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextOccurrenceDate, nextOccurrenceDate) || other.nextOccurrenceDate == nextOccurrenceDate)&&(identical(other.isSubscription, isSubscription) || other.isSubscription == isSubscription)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,type,direction,categoryId,amount,merchant,description,notes,frequency,intervalCount,startDate,endDate,nextOccurrenceDate,isSubscription,active);

@override
String toString() {
  return 'RecurringTransaction(id: $id, accountId: $accountId, type: $type, direction: $direction, categoryId: $categoryId, amount: $amount, merchant: $merchant, description: $description, notes: $notes, frequency: $frequency, intervalCount: $intervalCount, startDate: $startDate, endDate: $endDate, nextOccurrenceDate: $nextOccurrenceDate, isSubscription: $isSubscription, active: $active)';
}


}

/// @nodoc
abstract mixin class _$RecurringTransactionCopyWith<$Res> implements $RecurringTransactionCopyWith<$Res> {
  factory _$RecurringTransactionCopyWith(_RecurringTransaction value, $Res Function(_RecurringTransaction) _then) = __$RecurringTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, TransactionType type, TransactionDirection direction, String? categoryId,@AmountConverter() String amount, String? merchant, String? description, String? notes, RecurrenceFrequency frequency, int intervalCount, String startDate, String? endDate, String nextOccurrenceDate, bool isSubscription, bool active
});




}
/// @nodoc
class __$RecurringTransactionCopyWithImpl<$Res>
    implements _$RecurringTransactionCopyWith<$Res> {
  __$RecurringTransactionCopyWithImpl(this._self, this._then);

  final _RecurringTransaction _self;
  final $Res Function(_RecurringTransaction) _then;

/// Create a copy of RecurringTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? type = null,Object? direction = null,Object? categoryId = freezed,Object? amount = null,Object? merchant = freezed,Object? description = freezed,Object? notes = freezed,Object? frequency = null,Object? intervalCount = null,Object? startDate = null,Object? endDate = freezed,Object? nextOccurrenceDate = null,Object? isSubscription = null,Object? active = null,}) {
  return _then(_RecurringTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransactionDirection,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,intervalCount: null == intervalCount ? _self.intervalCount : intervalCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,nextOccurrenceDate: null == nextOccurrenceDate ? _self.nextOccurrenceDate : nextOccurrenceDate // ignore: cast_nullable_to_non_nullable
as String,isSubscription: null == isSubscription ? _self.isSubscription : isSubscription // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SubscriptionsSummary {

@AmountConverter() String get estimatedMonthlyTotal; List<RecurringTransaction> get subscriptions;
/// Create a copy of SubscriptionsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionsSummaryCopyWith<SubscriptionsSummary> get copyWith => _$SubscriptionsSummaryCopyWithImpl<SubscriptionsSummary>(this as SubscriptionsSummary, _$identity);

  /// Serializes this SubscriptionsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionsSummary&&(identical(other.estimatedMonthlyTotal, estimatedMonthlyTotal) || other.estimatedMonthlyTotal == estimatedMonthlyTotal)&&const DeepCollectionEquality().equals(other.subscriptions, subscriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,estimatedMonthlyTotal,const DeepCollectionEquality().hash(subscriptions));

@override
String toString() {
  return 'SubscriptionsSummary(estimatedMonthlyTotal: $estimatedMonthlyTotal, subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class $SubscriptionsSummaryCopyWith<$Res>  {
  factory $SubscriptionsSummaryCopyWith(SubscriptionsSummary value, $Res Function(SubscriptionsSummary) _then) = _$SubscriptionsSummaryCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String estimatedMonthlyTotal, List<RecurringTransaction> subscriptions
});




}
/// @nodoc
class _$SubscriptionsSummaryCopyWithImpl<$Res>
    implements $SubscriptionsSummaryCopyWith<$Res> {
  _$SubscriptionsSummaryCopyWithImpl(this._self, this._then);

  final SubscriptionsSummary _self;
  final $Res Function(SubscriptionsSummary) _then;

/// Create a copy of SubscriptionsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? estimatedMonthlyTotal = null,Object? subscriptions = null,}) {
  return _then(SubscriptionsSummary(
estimatedMonthlyTotal: null == estimatedMonthlyTotal ? _self.estimatedMonthlyTotal : estimatedMonthlyTotal // ignore: cast_nullable_to_non_nullable
as String,subscriptions: null == subscriptions ? _self.subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<RecurringTransaction>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionsSummary].
extension SubscriptionsSummaryPatterns on SubscriptionsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionsSummary value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String estimatedMonthlyTotal,  List<RecurringTransaction> subscriptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionsSummary() when $default != null:
return $default(_that.estimatedMonthlyTotal,_that.subscriptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String estimatedMonthlyTotal,  List<RecurringTransaction> subscriptions)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionsSummary():
return $default(_that.estimatedMonthlyTotal,_that.subscriptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String estimatedMonthlyTotal,  List<RecurringTransaction> subscriptions)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionsSummary() when $default != null:
return $default(_that.estimatedMonthlyTotal,_that.subscriptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionsSummary implements SubscriptionsSummary {
  const _SubscriptionsSummary({@AmountConverter() required this.estimatedMonthlyTotal, required  List<RecurringTransaction> subscriptions}): _subscriptions = subscriptions;
  factory _SubscriptionsSummary.fromJson(Map<String, dynamic> json) => _$SubscriptionsSummaryFromJson(json);

@override@AmountConverter() final  String estimatedMonthlyTotal;
 final  List<RecurringTransaction> _subscriptions;
@override List<RecurringTransaction> get subscriptions {
  if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscriptions);
}


/// Create a copy of SubscriptionsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionsSummaryCopyWith<_SubscriptionsSummary> get copyWith => __$SubscriptionsSummaryCopyWithImpl<_SubscriptionsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionsSummary&&(identical(other.estimatedMonthlyTotal, estimatedMonthlyTotal) || other.estimatedMonthlyTotal == estimatedMonthlyTotal)&&const DeepCollectionEquality().equals(other._subscriptions, _subscriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,estimatedMonthlyTotal,const DeepCollectionEquality().hash(_subscriptions));

@override
String toString() {
  return 'SubscriptionsSummary(estimatedMonthlyTotal: $estimatedMonthlyTotal, subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionsSummaryCopyWith<$Res> implements $SubscriptionsSummaryCopyWith<$Res> {
  factory _$SubscriptionsSummaryCopyWith(_SubscriptionsSummary value, $Res Function(_SubscriptionsSummary) _then) = __$SubscriptionsSummaryCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String estimatedMonthlyTotal, List<RecurringTransaction> subscriptions
});




}
/// @nodoc
class __$SubscriptionsSummaryCopyWithImpl<$Res>
    implements _$SubscriptionsSummaryCopyWith<$Res> {
  __$SubscriptionsSummaryCopyWithImpl(this._self, this._then);

  final _SubscriptionsSummary _self;
  final $Res Function(_SubscriptionsSummary) _then;

/// Create a copy of SubscriptionsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? estimatedMonthlyTotal = null,Object? subscriptions = null,}) {
  return _then(_SubscriptionsSummary(
estimatedMonthlyTotal: null == estimatedMonthlyTotal ? _self.estimatedMonthlyTotal : estimatedMonthlyTotal // ignore: cast_nullable_to_non_nullable
as String,subscriptions: null == subscriptions ? _self._subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<RecurringTransaction>,
  ));
}


}

// dart format on
