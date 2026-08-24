// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessAccount {

 String get id; String get name; BusinessAccountType get type; String get currency;@AmountConverter() String get openingBalance;@AmountConverter() String get balance;/// Phase 6 — the Chart of Accounts ledger account this business account
/// posts to automatically (e.g. when an expense payment is recorded from
/// it). Null means unmapped: Phase 5's payment actions still work, they
/// just don't produce a double-entry journal yet.
 String? get chartOfAccountsId; bool get archived;
/// Create a copy of BusinessAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessAccountCopyWith<BusinessAccount> get copyWith => _$BusinessAccountCopyWithImpl<BusinessAccount>(this as BusinessAccount, _$identity);

  /// Serializes this BusinessAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.chartOfAccountsId, chartOfAccountsId) || other.chartOfAccountsId == chartOfAccountsId)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,currency,openingBalance,balance,chartOfAccountsId,archived);

@override
String toString() {
  return 'BusinessAccount(id: $id, name: $name, type: $type, currency: $currency, openingBalance: $openingBalance, balance: $balance, chartOfAccountsId: $chartOfAccountsId, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $BusinessAccountCopyWith<$Res>  {
  factory $BusinessAccountCopyWith(BusinessAccount value, $Res Function(BusinessAccount) _then) = _$BusinessAccountCopyWithImpl;
@useResult
$Res call({
 String id, String name, BusinessAccountType type, String currency,@AmountConverter() String openingBalance,@AmountConverter() String balance, String? chartOfAccountsId, bool archived
});




}
/// @nodoc
class _$BusinessAccountCopyWithImpl<$Res>
    implements $BusinessAccountCopyWith<$Res> {
  _$BusinessAccountCopyWithImpl(this._self, this._then);

  final BusinessAccount _self;
  final $Res Function(BusinessAccount) _then;

/// Create a copy of BusinessAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? currency = null,Object? openingBalance = null,Object? balance = null,Object? chartOfAccountsId = freezed,Object? archived = null,}) {
  return _then(BusinessAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BusinessAccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,chartOfAccountsId: freezed == chartOfAccountsId ? _self.chartOfAccountsId : chartOfAccountsId // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessAccount].
extension BusinessAccountPatterns on BusinessAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessAccount value)  $default,){
final _that = this;
switch (_that) {
case _BusinessAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessAccount value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  BusinessAccountType type,  String currency, @AmountConverter()  String openingBalance, @AmountConverter()  String balance,  String? chartOfAccountsId,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessAccount() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.currency,_that.openingBalance,_that.balance,_that.chartOfAccountsId,_that.archived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  BusinessAccountType type,  String currency, @AmountConverter()  String openingBalance, @AmountConverter()  String balance,  String? chartOfAccountsId,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _BusinessAccount():
return $default(_that.id,_that.name,_that.type,_that.currency,_that.openingBalance,_that.balance,_that.chartOfAccountsId,_that.archived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  BusinessAccountType type,  String currency, @AmountConverter()  String openingBalance, @AmountConverter()  String balance,  String? chartOfAccountsId,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _BusinessAccount() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.currency,_that.openingBalance,_that.balance,_that.chartOfAccountsId,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessAccount implements BusinessAccount {
  const _BusinessAccount({required this.id, required this.name, required this.type, required this.currency, @AmountConverter() required this.openingBalance, @AmountConverter() required this.balance, this.chartOfAccountsId, required this.archived});
  factory _BusinessAccount.fromJson(Map<String, dynamic> json) => _$BusinessAccountFromJson(json);

@override final  String id;
@override final  String name;
@override final  BusinessAccountType type;
@override final  String currency;
@override@AmountConverter() final  String openingBalance;
@override@AmountConverter() final  String balance;
/// Phase 6 — the Chart of Accounts ledger account this business account
/// posts to automatically (e.g. when an expense payment is recorded from
/// it). Null means unmapped: Phase 5's payment actions still work, they
/// just don't produce a double-entry journal yet.
@override final  String? chartOfAccountsId;
@override final  bool archived;

/// Create a copy of BusinessAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessAccountCopyWith<_BusinessAccount> get copyWith => __$BusinessAccountCopyWithImpl<_BusinessAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.chartOfAccountsId, chartOfAccountsId) || other.chartOfAccountsId == chartOfAccountsId)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,currency,openingBalance,balance,chartOfAccountsId,archived);

@override
String toString() {
  return 'BusinessAccount(id: $id, name: $name, type: $type, currency: $currency, openingBalance: $openingBalance, balance: $balance, chartOfAccountsId: $chartOfAccountsId, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$BusinessAccountCopyWith<$Res> implements $BusinessAccountCopyWith<$Res> {
  factory _$BusinessAccountCopyWith(_BusinessAccount value, $Res Function(_BusinessAccount) _then) = __$BusinessAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, BusinessAccountType type, String currency,@AmountConverter() String openingBalance,@AmountConverter() String balance, String? chartOfAccountsId, bool archived
});




}
/// @nodoc
class __$BusinessAccountCopyWithImpl<$Res>
    implements _$BusinessAccountCopyWith<$Res> {
  __$BusinessAccountCopyWithImpl(this._self, this._then);

  final _BusinessAccount _self;
  final $Res Function(_BusinessAccount) _then;

/// Create a copy of BusinessAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? currency = null,Object? openingBalance = null,Object? balance = null,Object? chartOfAccountsId = freezed,Object? archived = null,}) {
  return _then(_BusinessAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BusinessAccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,chartOfAccountsId: freezed == chartOfAccountsId ? _self.chartOfAccountsId : chartOfAccountsId // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AccountEntry {

 String get id; EntryDirection get direction;@AmountConverter() String get amount; String get occurredOn; String? get description; String? get transferGroupId;
/// Create a copy of AccountEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountEntryCopyWith<AccountEntry> get copyWith => _$AccountEntryCopyWithImpl<AccountEntry>(this as AccountEntry, _$identity);

  /// Serializes this AccountEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.transferGroupId, transferGroupId) || other.transferGroupId == transferGroupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,amount,occurredOn,description,transferGroupId);

@override
String toString() {
  return 'AccountEntry(id: $id, direction: $direction, amount: $amount, occurredOn: $occurredOn, description: $description, transferGroupId: $transferGroupId)';
}


}

/// @nodoc
abstract mixin class $AccountEntryCopyWith<$Res>  {
  factory $AccountEntryCopyWith(AccountEntry value, $Res Function(AccountEntry) _then) = _$AccountEntryCopyWithImpl;
@useResult
$Res call({
 String id, EntryDirection direction,@AmountConverter() String amount, String occurredOn, String? description, String? transferGroupId
});




}
/// @nodoc
class _$AccountEntryCopyWithImpl<$Res>
    implements $AccountEntryCopyWith<$Res> {
  _$AccountEntryCopyWithImpl(this._self, this._then);

  final AccountEntry _self;
  final $Res Function(AccountEntry) _then;

/// Create a copy of AccountEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? direction = null,Object? amount = null,Object? occurredOn = null,Object? description = freezed,Object? transferGroupId = freezed,}) {
  return _then(AccountEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as EntryDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transferGroupId: freezed == transferGroupId ? _self.transferGroupId : transferGroupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountEntry].
extension AccountEntryPatterns on AccountEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountEntry value)  $default,){
final _that = this;
switch (_that) {
case _AccountEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AccountEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EntryDirection direction, @AmountConverter()  String amount,  String occurredOn,  String? description,  String? transferGroupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountEntry() when $default != null:
return $default(_that.id,_that.direction,_that.amount,_that.occurredOn,_that.description,_that.transferGroupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EntryDirection direction, @AmountConverter()  String amount,  String occurredOn,  String? description,  String? transferGroupId)  $default,) {final _that = this;
switch (_that) {
case _AccountEntry():
return $default(_that.id,_that.direction,_that.amount,_that.occurredOn,_that.description,_that.transferGroupId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EntryDirection direction, @AmountConverter()  String amount,  String occurredOn,  String? description,  String? transferGroupId)?  $default,) {final _that = this;
switch (_that) {
case _AccountEntry() when $default != null:
return $default(_that.id,_that.direction,_that.amount,_that.occurredOn,_that.description,_that.transferGroupId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountEntry implements AccountEntry {
  const _AccountEntry({required this.id, required this.direction, @AmountConverter() required this.amount, required this.occurredOn, this.description, this.transferGroupId});
  factory _AccountEntry.fromJson(Map<String, dynamic> json) => _$AccountEntryFromJson(json);

@override final  String id;
@override final  EntryDirection direction;
@override@AmountConverter() final  String amount;
@override final  String occurredOn;
@override final  String? description;
@override final  String? transferGroupId;

/// Create a copy of AccountEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountEntryCopyWith<_AccountEntry> get copyWith => __$AccountEntryCopyWithImpl<_AccountEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.transferGroupId, transferGroupId) || other.transferGroupId == transferGroupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,amount,occurredOn,description,transferGroupId);

@override
String toString() {
  return 'AccountEntry(id: $id, direction: $direction, amount: $amount, occurredOn: $occurredOn, description: $description, transferGroupId: $transferGroupId)';
}


}

/// @nodoc
abstract mixin class _$AccountEntryCopyWith<$Res> implements $AccountEntryCopyWith<$Res> {
  factory _$AccountEntryCopyWith(_AccountEntry value, $Res Function(_AccountEntry) _then) = __$AccountEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, EntryDirection direction,@AmountConverter() String amount, String occurredOn, String? description, String? transferGroupId
});




}
/// @nodoc
class __$AccountEntryCopyWithImpl<$Res>
    implements _$AccountEntryCopyWith<$Res> {
  __$AccountEntryCopyWithImpl(this._self, this._then);

  final _AccountEntry _self;
  final $Res Function(_AccountEntry) _then;

/// Create a copy of AccountEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? direction = null,Object? amount = null,Object? occurredOn = null,Object? description = freezed,Object? transferGroupId = freezed,}) {
  return _then(_AccountEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as EntryDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transferGroupId: freezed == transferGroupId ? _self.transferGroupId : transferGroupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
