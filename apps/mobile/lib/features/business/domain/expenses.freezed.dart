// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

 String get id; String? get supplierId; String? get category;@AmountConverter() String get amount;@AmountConverter() String get amountPaid;@AmountConverter() String get amountRemaining; String get occurredOn; ExpenseStatus get status; String? get receiptId;/// Phase 6 — the Chart of Accounts ledger account this expense posts
/// to automatically when a payment is recorded against it. Null means
/// unmapped.
 String? get chartOfAccountsId; String? get notes;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountRemaining, amountRemaining) || other.amountRemaining == amountRemaining)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.chartOfAccountsId, chartOfAccountsId) || other.chartOfAccountsId == chartOfAccountsId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierId,category,amount,amountPaid,amountRemaining,occurredOn,status,receiptId,chartOfAccountsId,notes);

@override
String toString() {
  return 'Expense(id: $id, supplierId: $supplierId, category: $category, amount: $amount, amountPaid: $amountPaid, amountRemaining: $amountRemaining, occurredOn: $occurredOn, status: $status, receiptId: $receiptId, chartOfAccountsId: $chartOfAccountsId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String? supplierId, String? category,@AmountConverter() String amount,@AmountConverter() String amountPaid,@AmountConverter() String amountRemaining, String occurredOn, ExpenseStatus status, String? receiptId, String? chartOfAccountsId, String? notes
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? supplierId = freezed,Object? category = freezed,Object? amount = null,Object? amountPaid = null,Object? amountRemaining = null,Object? occurredOn = null,Object? status = null,Object? receiptId = freezed,Object? chartOfAccountsId = freezed,Object? notes = freezed,}) {
  return _then(Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,amountRemaining: null == amountRemaining ? _self.amountRemaining : amountRemaining // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseStatus,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,chartOfAccountsId: freezed == chartOfAccountsId ? _self.chartOfAccountsId : chartOfAccountsId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? supplierId,  String? category, @AmountConverter()  String amount, @AmountConverter()  String amountPaid, @AmountConverter()  String amountRemaining,  String occurredOn,  ExpenseStatus status,  String? receiptId,  String? chartOfAccountsId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.supplierId,_that.category,_that.amount,_that.amountPaid,_that.amountRemaining,_that.occurredOn,_that.status,_that.receiptId,_that.chartOfAccountsId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? supplierId,  String? category, @AmountConverter()  String amount, @AmountConverter()  String amountPaid, @AmountConverter()  String amountRemaining,  String occurredOn,  ExpenseStatus status,  String? receiptId,  String? chartOfAccountsId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.supplierId,_that.category,_that.amount,_that.amountPaid,_that.amountRemaining,_that.occurredOn,_that.status,_that.receiptId,_that.chartOfAccountsId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? supplierId,  String? category, @AmountConverter()  String amount, @AmountConverter()  String amountPaid, @AmountConverter()  String amountRemaining,  String occurredOn,  ExpenseStatus status,  String? receiptId,  String? chartOfAccountsId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.supplierId,_that.category,_that.amount,_that.amountPaid,_that.amountRemaining,_that.occurredOn,_that.status,_that.receiptId,_that.chartOfAccountsId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense implements Expense {
  const _Expense({required this.id, this.supplierId, this.category, @AmountConverter() required this.amount, @AmountConverter() required this.amountPaid, @AmountConverter() required this.amountRemaining, required this.occurredOn, required this.status, this.receiptId, this.chartOfAccountsId, this.notes});
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String id;
@override final  String? supplierId;
@override final  String? category;
@override@AmountConverter() final  String amount;
@override@AmountConverter() final  String amountPaid;
@override@AmountConverter() final  String amountRemaining;
@override final  String occurredOn;
@override final  ExpenseStatus status;
@override final  String? receiptId;
/// Phase 6 — the Chart of Accounts ledger account this expense posts
/// to automatically when a payment is recorded against it. Null means
/// unmapped.
@override final  String? chartOfAccountsId;
@override final  String? notes;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountRemaining, amountRemaining) || other.amountRemaining == amountRemaining)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.chartOfAccountsId, chartOfAccountsId) || other.chartOfAccountsId == chartOfAccountsId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierId,category,amount,amountPaid,amountRemaining,occurredOn,status,receiptId,chartOfAccountsId,notes);

@override
String toString() {
  return 'Expense(id: $id, supplierId: $supplierId, category: $category, amount: $amount, amountPaid: $amountPaid, amountRemaining: $amountRemaining, occurredOn: $occurredOn, status: $status, receiptId: $receiptId, chartOfAccountsId: $chartOfAccountsId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String? supplierId, String? category,@AmountConverter() String amount,@AmountConverter() String amountPaid,@AmountConverter() String amountRemaining, String occurredOn, ExpenseStatus status, String? receiptId, String? chartOfAccountsId, String? notes
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? supplierId = freezed,Object? category = freezed,Object? amount = null,Object? amountPaid = null,Object? amountRemaining = null,Object? occurredOn = null,Object? status = null,Object? receiptId = freezed,Object? chartOfAccountsId = freezed,Object? notes = freezed,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,amountRemaining: null == amountRemaining ? _self.amountRemaining : amountRemaining // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseStatus,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,chartOfAccountsId: freezed == chartOfAccountsId ? _self.chartOfAccountsId : chartOfAccountsId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ExpensePayment {

 String get id; String get businessAccountId;@AmountConverter() String get amount; String get paidOn; String? get notes;
/// Create a copy of ExpensePayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensePaymentCopyWith<ExpensePayment> get copyWith => _$ExpensePaymentCopyWithImpl<ExpensePayment>(this as ExpensePayment, _$identity);

  /// Serializes this ExpensePayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensePayment&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,amount,paidOn,notes);

@override
String toString() {
  return 'ExpensePayment(id: $id, businessAccountId: $businessAccountId, amount: $amount, paidOn: $paidOn, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ExpensePaymentCopyWith<$Res>  {
  factory $ExpensePaymentCopyWith(ExpensePayment value, $Res Function(ExpensePayment) _then) = _$ExpensePaymentCopyWithImpl;
@useResult
$Res call({
 String id, String businessAccountId,@AmountConverter() String amount, String paidOn, String? notes
});




}
/// @nodoc
class _$ExpensePaymentCopyWithImpl<$Res>
    implements $ExpensePaymentCopyWith<$Res> {
  _$ExpensePaymentCopyWithImpl(this._self, this._then);

  final ExpensePayment _self;
  final $Res Function(ExpensePayment) _then;

/// Create a copy of ExpensePayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessAccountId = null,Object? amount = null,Object? paidOn = null,Object? notes = freezed,}) {
  return _then(ExpensePayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpensePayment].
extension ExpensePaymentPatterns on ExpensePayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpensePayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpensePayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpensePayment value)  $default,){
final _that = this;
switch (_that) {
case _ExpensePayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpensePayment value)?  $default,){
final _that = this;
switch (_that) {
case _ExpensePayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessAccountId, @AmountConverter()  String amount,  String paidOn,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpensePayment() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.amount,_that.paidOn,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessAccountId, @AmountConverter()  String amount,  String paidOn,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ExpensePayment():
return $default(_that.id,_that.businessAccountId,_that.amount,_that.paidOn,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessAccountId, @AmountConverter()  String amount,  String paidOn,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ExpensePayment() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.amount,_that.paidOn,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpensePayment implements ExpensePayment {
  const _ExpensePayment({required this.id, required this.businessAccountId, @AmountConverter() required this.amount, required this.paidOn, this.notes});
  factory _ExpensePayment.fromJson(Map<String, dynamic> json) => _$ExpensePaymentFromJson(json);

@override final  String id;
@override final  String businessAccountId;
@override@AmountConverter() final  String amount;
@override final  String paidOn;
@override final  String? notes;

/// Create a copy of ExpensePayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpensePaymentCopyWith<_ExpensePayment> get copyWith => __$ExpensePaymentCopyWithImpl<_ExpensePayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpensePaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpensePayment&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,amount,paidOn,notes);

@override
String toString() {
  return 'ExpensePayment(id: $id, businessAccountId: $businessAccountId, amount: $amount, paidOn: $paidOn, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ExpensePaymentCopyWith<$Res> implements $ExpensePaymentCopyWith<$Res> {
  factory _$ExpensePaymentCopyWith(_ExpensePayment value, $Res Function(_ExpensePayment) _then) = __$ExpensePaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessAccountId,@AmountConverter() String amount, String paidOn, String? notes
});




}
/// @nodoc
class __$ExpensePaymentCopyWithImpl<$Res>
    implements _$ExpensePaymentCopyWith<$Res> {
  __$ExpensePaymentCopyWithImpl(this._self, this._then);

  final _ExpensePayment _self;
  final $Res Function(_ExpensePayment) _then;

/// Create a copy of ExpensePayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessAccountId = null,Object? amount = null,Object? paidOn = null,Object? notes = freezed,}) {
  return _then(_ExpensePayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
