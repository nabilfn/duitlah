// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatTurn {

 ChatMessageRole get role; String get content;
/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatTurnCopyWith<ChatTurn> get copyWith => _$ChatTurnCopyWithImpl<ChatTurn>(this as ChatTurn, _$identity);

  /// Serializes this ChatTurn to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatTurn&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content);

@override
String toString() {
  return 'ChatTurn(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class $ChatTurnCopyWith<$Res>  {
  factory $ChatTurnCopyWith(ChatTurn value, $Res Function(ChatTurn) _then) = _$ChatTurnCopyWithImpl;
@useResult
$Res call({
 ChatMessageRole role, String content
});




}
/// @nodoc
class _$ChatTurnCopyWithImpl<$Res>
    implements $ChatTurnCopyWith<$Res> {
  _$ChatTurnCopyWithImpl(this._self, this._then);

  final ChatTurn _self;
  final $Res Function(ChatTurn) _then;

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? content = null,}) {
  return _then(ChatTurn(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatMessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatTurn].
extension ChatTurnPatterns on ChatTurn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatTurn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatTurn value)  $default,){
final _that = this;
switch (_that) {
case _ChatTurn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatTurn value)?  $default,){
final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatMessageRole role,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatMessageRole role,  String content)  $default,) {final _that = this;
switch (_that) {
case _ChatTurn():
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatMessageRole role,  String content)?  $default,) {final _that = this;
switch (_that) {
case _ChatTurn() when $default != null:
return $default(_that.role,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatTurn implements ChatTurn {
  const _ChatTurn({required this.role, required this.content});
  factory _ChatTurn.fromJson(Map<String, dynamic> json) => _$ChatTurnFromJson(json);

@override final  ChatMessageRole role;
@override final  String content;

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatTurnCopyWith<_ChatTurn> get copyWith => __$ChatTurnCopyWithImpl<_ChatTurn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatTurnToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatTurn&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content);

@override
String toString() {
  return 'ChatTurn(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class _$ChatTurnCopyWith<$Res> implements $ChatTurnCopyWith<$Res> {
  factory _$ChatTurnCopyWith(_ChatTurn value, $Res Function(_ChatTurn) _then) = __$ChatTurnCopyWithImpl;
@override @useResult
$Res call({
 ChatMessageRole role, String content
});




}
/// @nodoc
class __$ChatTurnCopyWithImpl<$Res>
    implements _$ChatTurnCopyWith<$Res> {
  __$ChatTurnCopyWithImpl(this._self, this._then);

  final _ChatTurn _self;
  final $Res Function(_ChatTurn) _then;

/// Create a copy of ChatTurn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? content = null,}) {
  return _then(_ChatTurn(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatMessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatResult {

 String get reply; bool get available;
/// Create a copy of ChatResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatResultCopyWith<ChatResult> get copyWith => _$ChatResultCopyWithImpl<ChatResult>(this as ChatResult, _$identity);

  /// Serializes this ChatResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatResult&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply,available);

@override
String toString() {
  return 'ChatResult(reply: $reply, available: $available)';
}


}

/// @nodoc
abstract mixin class $ChatResultCopyWith<$Res>  {
  factory $ChatResultCopyWith(ChatResult value, $Res Function(ChatResult) _then) = _$ChatResultCopyWithImpl;
@useResult
$Res call({
 String reply, bool available
});




}
/// @nodoc
class _$ChatResultCopyWithImpl<$Res>
    implements $ChatResultCopyWith<$Res> {
  _$ChatResultCopyWithImpl(this._self, this._then);

  final ChatResult _self;
  final $Res Function(ChatResult) _then;

/// Create a copy of ChatResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reply = null,Object? available = null,}) {
  return _then(ChatResult(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatResult].
extension ChatResultPatterns on ChatResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatResult value)  $default,){
final _that = this;
switch (_that) {
case _ChatResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatResult value)?  $default,){
final _that = this;
switch (_that) {
case _ChatResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reply,  bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatResult() when $default != null:
return $default(_that.reply,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reply,  bool available)  $default,) {final _that = this;
switch (_that) {
case _ChatResult():
return $default(_that.reply,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reply,  bool available)?  $default,) {final _that = this;
switch (_that) {
case _ChatResult() when $default != null:
return $default(_that.reply,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatResult implements ChatResult {
  const _ChatResult({required this.reply, required this.available});
  factory _ChatResult.fromJson(Map<String, dynamic> json) => _$ChatResultFromJson(json);

@override final  String reply;
@override final  bool available;

/// Create a copy of ChatResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatResultCopyWith<_ChatResult> get copyWith => __$ChatResultCopyWithImpl<_ChatResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatResult&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reply,available);

@override
String toString() {
  return 'ChatResult(reply: $reply, available: $available)';
}


}

/// @nodoc
abstract mixin class _$ChatResultCopyWith<$Res> implements $ChatResultCopyWith<$Res> {
  factory _$ChatResultCopyWith(_ChatResult value, $Res Function(_ChatResult) _then) = __$ChatResultCopyWithImpl;
@override @useResult
$Res call({
 String reply, bool available
});




}
/// @nodoc
class __$ChatResultCopyWithImpl<$Res>
    implements _$ChatResultCopyWith<$Res> {
  __$ChatResultCopyWithImpl(this._self, this._then);

  final _ChatResult _self;
  final $Res Function(_ChatResult) _then;

/// Create a copy of ChatResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reply = null,Object? available = null,}) {
  return _then(_ChatResult(
reply: null == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AffordabilityResult {

@AmountConverter() String get amount;@AmountConverter() String get currentBalance;@AmountConverter() String get projectedBalanceIfWaited;@AmountConverter() String get projectedBalanceIfPurchased;@AmountConverter() String get totalOwedToOthers; bool get canAfford; String get narrative; String get disclaimer;@AmountConverter() String get upcomingBillsTotal;@AmountConverter() String get debtRepaymentsTotal;@AmountConverter() String get totalObligations;@NullableAmountConverter() String? get averageCreditUtilization;@AmountConverter() String get totalSavingsGoalsRemaining;@AmountConverter() String get budgetRemainingThisPeriod;
/// Create a copy of AffordabilityResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AffordabilityResultCopyWith<AffordabilityResult> get copyWith => _$AffordabilityResultCopyWithImpl<AffordabilityResult>(this as AffordabilityResult, _$identity);

  /// Serializes this AffordabilityResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AffordabilityResult&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.projectedBalanceIfWaited, projectedBalanceIfWaited) || other.projectedBalanceIfWaited == projectedBalanceIfWaited)&&(identical(other.projectedBalanceIfPurchased, projectedBalanceIfPurchased) || other.projectedBalanceIfPurchased == projectedBalanceIfPurchased)&&(identical(other.totalOwedToOthers, totalOwedToOthers) || other.totalOwedToOthers == totalOwedToOthers)&&(identical(other.canAfford, canAfford) || other.canAfford == canAfford)&&(identical(other.narrative, narrative) || other.narrative == narrative)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.upcomingBillsTotal, upcomingBillsTotal) || other.upcomingBillsTotal == upcomingBillsTotal)&&(identical(other.debtRepaymentsTotal, debtRepaymentsTotal) || other.debtRepaymentsTotal == debtRepaymentsTotal)&&(identical(other.totalObligations, totalObligations) || other.totalObligations == totalObligations)&&(identical(other.averageCreditUtilization, averageCreditUtilization) || other.averageCreditUtilization == averageCreditUtilization)&&(identical(other.totalSavingsGoalsRemaining, totalSavingsGoalsRemaining) || other.totalSavingsGoalsRemaining == totalSavingsGoalsRemaining)&&(identical(other.budgetRemainingThisPeriod, budgetRemainingThisPeriod) || other.budgetRemainingThisPeriod == budgetRemainingThisPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,currentBalance,projectedBalanceIfWaited,projectedBalanceIfPurchased,totalOwedToOthers,canAfford,narrative,disclaimer,upcomingBillsTotal,debtRepaymentsTotal,totalObligations,averageCreditUtilization,totalSavingsGoalsRemaining,budgetRemainingThisPeriod);

@override
String toString() {
  return 'AffordabilityResult(amount: $amount, currentBalance: $currentBalance, projectedBalanceIfWaited: $projectedBalanceIfWaited, projectedBalanceIfPurchased: $projectedBalanceIfPurchased, totalOwedToOthers: $totalOwedToOthers, canAfford: $canAfford, narrative: $narrative, disclaimer: $disclaimer, upcomingBillsTotal: $upcomingBillsTotal, debtRepaymentsTotal: $debtRepaymentsTotal, totalObligations: $totalObligations, averageCreditUtilization: $averageCreditUtilization, totalSavingsGoalsRemaining: $totalSavingsGoalsRemaining, budgetRemainingThisPeriod: $budgetRemainingThisPeriod)';
}


}

/// @nodoc
abstract mixin class $AffordabilityResultCopyWith<$Res>  {
  factory $AffordabilityResultCopyWith(AffordabilityResult value, $Res Function(AffordabilityResult) _then) = _$AffordabilityResultCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String amount,@AmountConverter() String currentBalance,@AmountConverter() String projectedBalanceIfWaited,@AmountConverter() String projectedBalanceIfPurchased,@AmountConverter() String totalOwedToOthers, bool canAfford, String narrative, String disclaimer,@AmountConverter() String upcomingBillsTotal,@AmountConverter() String debtRepaymentsTotal,@AmountConverter() String totalObligations,@NullableAmountConverter() String? averageCreditUtilization,@AmountConverter() String totalSavingsGoalsRemaining,@AmountConverter() String budgetRemainingThisPeriod
});




}
/// @nodoc
class _$AffordabilityResultCopyWithImpl<$Res>
    implements $AffordabilityResultCopyWith<$Res> {
  _$AffordabilityResultCopyWithImpl(this._self, this._then);

  final AffordabilityResult _self;
  final $Res Function(AffordabilityResult) _then;

/// Create a copy of AffordabilityResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? currentBalance = null,Object? projectedBalanceIfWaited = null,Object? projectedBalanceIfPurchased = null,Object? totalOwedToOthers = null,Object? canAfford = null,Object? narrative = null,Object? disclaimer = null,Object? upcomingBillsTotal = null,Object? debtRepaymentsTotal = null,Object? totalObligations = null,Object? averageCreditUtilization = freezed,Object? totalSavingsGoalsRemaining = null,Object? budgetRemainingThisPeriod = null,}) {
  return _then(AffordabilityResult(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as String,projectedBalanceIfWaited: null == projectedBalanceIfWaited ? _self.projectedBalanceIfWaited : projectedBalanceIfWaited // ignore: cast_nullable_to_non_nullable
as String,projectedBalanceIfPurchased: null == projectedBalanceIfPurchased ? _self.projectedBalanceIfPurchased : projectedBalanceIfPurchased // ignore: cast_nullable_to_non_nullable
as String,totalOwedToOthers: null == totalOwedToOthers ? _self.totalOwedToOthers : totalOwedToOthers // ignore: cast_nullable_to_non_nullable
as String,canAfford: null == canAfford ? _self.canAfford : canAfford // ignore: cast_nullable_to_non_nullable
as bool,narrative: null == narrative ? _self.narrative : narrative // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,upcomingBillsTotal: null == upcomingBillsTotal ? _self.upcomingBillsTotal : upcomingBillsTotal // ignore: cast_nullable_to_non_nullable
as String,debtRepaymentsTotal: null == debtRepaymentsTotal ? _self.debtRepaymentsTotal : debtRepaymentsTotal // ignore: cast_nullable_to_non_nullable
as String,totalObligations: null == totalObligations ? _self.totalObligations : totalObligations // ignore: cast_nullable_to_non_nullable
as String,averageCreditUtilization: freezed == averageCreditUtilization ? _self.averageCreditUtilization : averageCreditUtilization // ignore: cast_nullable_to_non_nullable
as String?,totalSavingsGoalsRemaining: null == totalSavingsGoalsRemaining ? _self.totalSavingsGoalsRemaining : totalSavingsGoalsRemaining // ignore: cast_nullable_to_non_nullable
as String,budgetRemainingThisPeriod: null == budgetRemainingThisPeriod ? _self.budgetRemainingThisPeriod : budgetRemainingThisPeriod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AffordabilityResult].
extension AffordabilityResultPatterns on AffordabilityResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AffordabilityResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AffordabilityResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AffordabilityResult value)  $default,){
final _that = this;
switch (_that) {
case _AffordabilityResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AffordabilityResult value)?  $default,){
final _that = this;
switch (_that) {
case _AffordabilityResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String amount, @AmountConverter()  String currentBalance, @AmountConverter()  String projectedBalanceIfWaited, @AmountConverter()  String projectedBalanceIfPurchased, @AmountConverter()  String totalOwedToOthers,  bool canAfford,  String narrative,  String disclaimer, @AmountConverter()  String upcomingBillsTotal, @AmountConverter()  String debtRepaymentsTotal, @AmountConverter()  String totalObligations, @NullableAmountConverter()  String? averageCreditUtilization, @AmountConverter()  String totalSavingsGoalsRemaining, @AmountConverter()  String budgetRemainingThisPeriod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AffordabilityResult() when $default != null:
return $default(_that.amount,_that.currentBalance,_that.projectedBalanceIfWaited,_that.projectedBalanceIfPurchased,_that.totalOwedToOthers,_that.canAfford,_that.narrative,_that.disclaimer,_that.upcomingBillsTotal,_that.debtRepaymentsTotal,_that.totalObligations,_that.averageCreditUtilization,_that.totalSavingsGoalsRemaining,_that.budgetRemainingThisPeriod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String amount, @AmountConverter()  String currentBalance, @AmountConverter()  String projectedBalanceIfWaited, @AmountConverter()  String projectedBalanceIfPurchased, @AmountConverter()  String totalOwedToOthers,  bool canAfford,  String narrative,  String disclaimer, @AmountConverter()  String upcomingBillsTotal, @AmountConverter()  String debtRepaymentsTotal, @AmountConverter()  String totalObligations, @NullableAmountConverter()  String? averageCreditUtilization, @AmountConverter()  String totalSavingsGoalsRemaining, @AmountConverter()  String budgetRemainingThisPeriod)  $default,) {final _that = this;
switch (_that) {
case _AffordabilityResult():
return $default(_that.amount,_that.currentBalance,_that.projectedBalanceIfWaited,_that.projectedBalanceIfPurchased,_that.totalOwedToOthers,_that.canAfford,_that.narrative,_that.disclaimer,_that.upcomingBillsTotal,_that.debtRepaymentsTotal,_that.totalObligations,_that.averageCreditUtilization,_that.totalSavingsGoalsRemaining,_that.budgetRemainingThisPeriod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String amount, @AmountConverter()  String currentBalance, @AmountConverter()  String projectedBalanceIfWaited, @AmountConverter()  String projectedBalanceIfPurchased, @AmountConverter()  String totalOwedToOthers,  bool canAfford,  String narrative,  String disclaimer, @AmountConverter()  String upcomingBillsTotal, @AmountConverter()  String debtRepaymentsTotal, @AmountConverter()  String totalObligations, @NullableAmountConverter()  String? averageCreditUtilization, @AmountConverter()  String totalSavingsGoalsRemaining, @AmountConverter()  String budgetRemainingThisPeriod)?  $default,) {final _that = this;
switch (_that) {
case _AffordabilityResult() when $default != null:
return $default(_that.amount,_that.currentBalance,_that.projectedBalanceIfWaited,_that.projectedBalanceIfPurchased,_that.totalOwedToOthers,_that.canAfford,_that.narrative,_that.disclaimer,_that.upcomingBillsTotal,_that.debtRepaymentsTotal,_that.totalObligations,_that.averageCreditUtilization,_that.totalSavingsGoalsRemaining,_that.budgetRemainingThisPeriod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AffordabilityResult implements AffordabilityResult {
  const _AffordabilityResult({@AmountConverter() required this.amount, @AmountConverter() required this.currentBalance, @AmountConverter() required this.projectedBalanceIfWaited, @AmountConverter() required this.projectedBalanceIfPurchased, @AmountConverter() required this.totalOwedToOthers, required this.canAfford, required this.narrative, required this.disclaimer, @AmountConverter() required this.upcomingBillsTotal, @AmountConverter() required this.debtRepaymentsTotal, @AmountConverter() required this.totalObligations, @NullableAmountConverter() this.averageCreditUtilization, @AmountConverter() required this.totalSavingsGoalsRemaining, @AmountConverter() required this.budgetRemainingThisPeriod});
  factory _AffordabilityResult.fromJson(Map<String, dynamic> json) => _$AffordabilityResultFromJson(json);

@override@AmountConverter() final  String amount;
@override@AmountConverter() final  String currentBalance;
@override@AmountConverter() final  String projectedBalanceIfWaited;
@override@AmountConverter() final  String projectedBalanceIfPurchased;
@override@AmountConverter() final  String totalOwedToOthers;
@override final  bool canAfford;
@override final  String narrative;
@override final  String disclaimer;
@override@AmountConverter() final  String upcomingBillsTotal;
@override@AmountConverter() final  String debtRepaymentsTotal;
@override@AmountConverter() final  String totalObligations;
@override@NullableAmountConverter() final  String? averageCreditUtilization;
@override@AmountConverter() final  String totalSavingsGoalsRemaining;
@override@AmountConverter() final  String budgetRemainingThisPeriod;

/// Create a copy of AffordabilityResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AffordabilityResultCopyWith<_AffordabilityResult> get copyWith => __$AffordabilityResultCopyWithImpl<_AffordabilityResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AffordabilityResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AffordabilityResult&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currentBalance, currentBalance) || other.currentBalance == currentBalance)&&(identical(other.projectedBalanceIfWaited, projectedBalanceIfWaited) || other.projectedBalanceIfWaited == projectedBalanceIfWaited)&&(identical(other.projectedBalanceIfPurchased, projectedBalanceIfPurchased) || other.projectedBalanceIfPurchased == projectedBalanceIfPurchased)&&(identical(other.totalOwedToOthers, totalOwedToOthers) || other.totalOwedToOthers == totalOwedToOthers)&&(identical(other.canAfford, canAfford) || other.canAfford == canAfford)&&(identical(other.narrative, narrative) || other.narrative == narrative)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.upcomingBillsTotal, upcomingBillsTotal) || other.upcomingBillsTotal == upcomingBillsTotal)&&(identical(other.debtRepaymentsTotal, debtRepaymentsTotal) || other.debtRepaymentsTotal == debtRepaymentsTotal)&&(identical(other.totalObligations, totalObligations) || other.totalObligations == totalObligations)&&(identical(other.averageCreditUtilization, averageCreditUtilization) || other.averageCreditUtilization == averageCreditUtilization)&&(identical(other.totalSavingsGoalsRemaining, totalSavingsGoalsRemaining) || other.totalSavingsGoalsRemaining == totalSavingsGoalsRemaining)&&(identical(other.budgetRemainingThisPeriod, budgetRemainingThisPeriod) || other.budgetRemainingThisPeriod == budgetRemainingThisPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,currentBalance,projectedBalanceIfWaited,projectedBalanceIfPurchased,totalOwedToOthers,canAfford,narrative,disclaimer,upcomingBillsTotal,debtRepaymentsTotal,totalObligations,averageCreditUtilization,totalSavingsGoalsRemaining,budgetRemainingThisPeriod);

@override
String toString() {
  return 'AffordabilityResult(amount: $amount, currentBalance: $currentBalance, projectedBalanceIfWaited: $projectedBalanceIfWaited, projectedBalanceIfPurchased: $projectedBalanceIfPurchased, totalOwedToOthers: $totalOwedToOthers, canAfford: $canAfford, narrative: $narrative, disclaimer: $disclaimer, upcomingBillsTotal: $upcomingBillsTotal, debtRepaymentsTotal: $debtRepaymentsTotal, totalObligations: $totalObligations, averageCreditUtilization: $averageCreditUtilization, totalSavingsGoalsRemaining: $totalSavingsGoalsRemaining, budgetRemainingThisPeriod: $budgetRemainingThisPeriod)';
}


}

/// @nodoc
abstract mixin class _$AffordabilityResultCopyWith<$Res> implements $AffordabilityResultCopyWith<$Res> {
  factory _$AffordabilityResultCopyWith(_AffordabilityResult value, $Res Function(_AffordabilityResult) _then) = __$AffordabilityResultCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String amount,@AmountConverter() String currentBalance,@AmountConverter() String projectedBalanceIfWaited,@AmountConverter() String projectedBalanceIfPurchased,@AmountConverter() String totalOwedToOthers, bool canAfford, String narrative, String disclaimer,@AmountConverter() String upcomingBillsTotal,@AmountConverter() String debtRepaymentsTotal,@AmountConverter() String totalObligations,@NullableAmountConverter() String? averageCreditUtilization,@AmountConverter() String totalSavingsGoalsRemaining,@AmountConverter() String budgetRemainingThisPeriod
});




}
/// @nodoc
class __$AffordabilityResultCopyWithImpl<$Res>
    implements _$AffordabilityResultCopyWith<$Res> {
  __$AffordabilityResultCopyWithImpl(this._self, this._then);

  final _AffordabilityResult _self;
  final $Res Function(_AffordabilityResult) _then;

/// Create a copy of AffordabilityResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? currentBalance = null,Object? projectedBalanceIfWaited = null,Object? projectedBalanceIfPurchased = null,Object? totalOwedToOthers = null,Object? canAfford = null,Object? narrative = null,Object? disclaimer = null,Object? upcomingBillsTotal = null,Object? debtRepaymentsTotal = null,Object? totalObligations = null,Object? averageCreditUtilization = freezed,Object? totalSavingsGoalsRemaining = null,Object? budgetRemainingThisPeriod = null,}) {
  return _then(_AffordabilityResult(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currentBalance: null == currentBalance ? _self.currentBalance : currentBalance // ignore: cast_nullable_to_non_nullable
as String,projectedBalanceIfWaited: null == projectedBalanceIfWaited ? _self.projectedBalanceIfWaited : projectedBalanceIfWaited // ignore: cast_nullable_to_non_nullable
as String,projectedBalanceIfPurchased: null == projectedBalanceIfPurchased ? _self.projectedBalanceIfPurchased : projectedBalanceIfPurchased // ignore: cast_nullable_to_non_nullable
as String,totalOwedToOthers: null == totalOwedToOthers ? _self.totalOwedToOthers : totalOwedToOthers // ignore: cast_nullable_to_non_nullable
as String,canAfford: null == canAfford ? _self.canAfford : canAfford // ignore: cast_nullable_to_non_nullable
as bool,narrative: null == narrative ? _self.narrative : narrative // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,upcomingBillsTotal: null == upcomingBillsTotal ? _self.upcomingBillsTotal : upcomingBillsTotal // ignore: cast_nullable_to_non_nullable
as String,debtRepaymentsTotal: null == debtRepaymentsTotal ? _self.debtRepaymentsTotal : debtRepaymentsTotal // ignore: cast_nullable_to_non_nullable
as String,totalObligations: null == totalObligations ? _self.totalObligations : totalObligations // ignore: cast_nullable_to_non_nullable
as String,averageCreditUtilization: freezed == averageCreditUtilization ? _self.averageCreditUtilization : averageCreditUtilization // ignore: cast_nullable_to_non_nullable
as String?,totalSavingsGoalsRemaining: null == totalSavingsGoalsRemaining ? _self.totalSavingsGoalsRemaining : totalSavingsGoalsRemaining // ignore: cast_nullable_to_non_nullable
as String,budgetRemainingThisPeriod: null == budgetRemainingThisPeriod ? _self.budgetRemainingThisPeriod : budgetRemainingThisPeriod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
