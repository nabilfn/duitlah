// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentHandoffLink {

 String get provider; String get instructions; String? get url;
/// Create a copy of PaymentHandoffLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentHandoffLinkCopyWith<PaymentHandoffLink> get copyWith => _$PaymentHandoffLinkCopyWithImpl<PaymentHandoffLink>(this as PaymentHandoffLink, _$identity);

  /// Serializes this PaymentHandoffLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentHandoffLink&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,instructions,url);

@override
String toString() {
  return 'PaymentHandoffLink(provider: $provider, instructions: $instructions, url: $url)';
}


}

/// @nodoc
abstract mixin class $PaymentHandoffLinkCopyWith<$Res>  {
  factory $PaymentHandoffLinkCopyWith(PaymentHandoffLink value, $Res Function(PaymentHandoffLink) _then) = _$PaymentHandoffLinkCopyWithImpl;
@useResult
$Res call({
 String provider, String instructions, String? url
});




}
/// @nodoc
class _$PaymentHandoffLinkCopyWithImpl<$Res>
    implements $PaymentHandoffLinkCopyWith<$Res> {
  _$PaymentHandoffLinkCopyWithImpl(this._self, this._then);

  final PaymentHandoffLink _self;
  final $Res Function(PaymentHandoffLink) _then;

/// Create a copy of PaymentHandoffLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? instructions = null,Object? url = freezed,}) {
  return _then(PaymentHandoffLink(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentHandoffLink].
extension PaymentHandoffLinkPatterns on PaymentHandoffLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentHandoffLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentHandoffLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentHandoffLink value)  $default,){
final _that = this;
switch (_that) {
case _PaymentHandoffLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentHandoffLink value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentHandoffLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String instructions,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentHandoffLink() when $default != null:
return $default(_that.provider,_that.instructions,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String instructions,  String? url)  $default,) {final _that = this;
switch (_that) {
case _PaymentHandoffLink():
return $default(_that.provider,_that.instructions,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String instructions,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _PaymentHandoffLink() when $default != null:
return $default(_that.provider,_that.instructions,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentHandoffLink implements PaymentHandoffLink {
  const _PaymentHandoffLink({required this.provider, required this.instructions, this.url});
  factory _PaymentHandoffLink.fromJson(Map<String, dynamic> json) => _$PaymentHandoffLinkFromJson(json);

@override final  String provider;
@override final  String instructions;
@override final  String? url;

/// Create a copy of PaymentHandoffLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentHandoffLinkCopyWith<_PaymentHandoffLink> get copyWith => __$PaymentHandoffLinkCopyWithImpl<_PaymentHandoffLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentHandoffLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentHandoffLink&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,instructions,url);

@override
String toString() {
  return 'PaymentHandoffLink(provider: $provider, instructions: $instructions, url: $url)';
}


}

/// @nodoc
abstract mixin class _$PaymentHandoffLinkCopyWith<$Res> implements $PaymentHandoffLinkCopyWith<$Res> {
  factory _$PaymentHandoffLinkCopyWith(_PaymentHandoffLink value, $Res Function(_PaymentHandoffLink) _then) = __$PaymentHandoffLinkCopyWithImpl;
@override @useResult
$Res call({
 String provider, String instructions, String? url
});




}
/// @nodoc
class __$PaymentHandoffLinkCopyWithImpl<$Res>
    implements _$PaymentHandoffLinkCopyWith<$Res> {
  __$PaymentHandoffLinkCopyWithImpl(this._self, this._then);

  final _PaymentHandoffLink _self;
  final $Res Function(_PaymentHandoffLink) _then;

/// Create a copy of PaymentHandoffLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? instructions = null,Object? url = freezed,}) {
  return _then(_PaymentHandoffLink(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Settlement {

 String get id; String get fromUserId; String get fromDisplayName; String get toUserId; String get toDisplayName;@AmountConverter() String get amount;@AmountConverter() String get amountPaid;@AmountConverter() String get amountRemaining; SettlementStatus get status; SourceType get sourceType; String get sourceId; String get createdAt; PaymentHandoffLink get handoff;
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementCopyWith<Settlement> get copyWith => _$SettlementCopyWithImpl<Settlement>(this as Settlement, _$identity);

  /// Serializes this Settlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromDisplayName, fromDisplayName) || other.fromDisplayName == fromDisplayName)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.toDisplayName, toDisplayName) || other.toDisplayName == toDisplayName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountRemaining, amountRemaining) || other.amountRemaining == amountRemaining)&&(identical(other.status, status) || other.status == status)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.handoff, handoff) || other.handoff == handoff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,fromDisplayName,toUserId,toDisplayName,amount,amountPaid,amountRemaining,status,sourceType,sourceId,createdAt,handoff);

@override
String toString() {
  return 'Settlement(id: $id, fromUserId: $fromUserId, fromDisplayName: $fromDisplayName, toUserId: $toUserId, toDisplayName: $toDisplayName, amount: $amount, amountPaid: $amountPaid, amountRemaining: $amountRemaining, status: $status, sourceType: $sourceType, sourceId: $sourceId, createdAt: $createdAt, handoff: $handoff)';
}


}

/// @nodoc
abstract mixin class $SettlementCopyWith<$Res>  {
  factory $SettlementCopyWith(Settlement value, $Res Function(Settlement) _then) = _$SettlementCopyWithImpl;
@useResult
$Res call({
 String id, String fromUserId, String fromDisplayName, String toUserId, String toDisplayName,@AmountConverter() String amount,@AmountConverter() String amountPaid,@AmountConverter() String amountRemaining, SettlementStatus status, SourceType sourceType, String sourceId, String createdAt, PaymentHandoffLink handoff
});


$PaymentHandoffLinkCopyWith<$Res> get handoff;

}
/// @nodoc
class _$SettlementCopyWithImpl<$Res>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._self, this._then);

  final Settlement _self;
  final $Res Function(Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUserId = null,Object? fromDisplayName = null,Object? toUserId = null,Object? toDisplayName = null,Object? amount = null,Object? amountPaid = null,Object? amountRemaining = null,Object? status = null,Object? sourceType = null,Object? sourceId = null,Object? createdAt = null,Object? handoff = null,}) {
  return _then(Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromDisplayName: null == fromDisplayName ? _self.fromDisplayName : fromDisplayName // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,toDisplayName: null == toDisplayName ? _self.toDisplayName : toDisplayName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,amountRemaining: null == amountRemaining ? _self.amountRemaining : amountRemaining // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettlementStatus,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as SourceType,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,handoff: null == handoff ? _self.handoff : handoff // ignore: cast_nullable_to_non_nullable
as PaymentHandoffLink,
  ));
}
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentHandoffLinkCopyWith<$Res> get handoff {
  
  return $PaymentHandoffLinkCopyWith<$Res>(_self.handoff, (value) {
    return _then(_self.copyWith(handoff: value));
  });
}
}


/// Adds pattern-matching-related methods to [Settlement].
extension SettlementPatterns on Settlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settlement value)  $default,){
final _that = this;
switch (_that) {
case _Settlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settlement value)?  $default,){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromUserId,  String fromDisplayName,  String toUserId,  String toDisplayName, @AmountConverter()  String amount, @AmountConverter()  String amountPaid, @AmountConverter()  String amountRemaining,  SettlementStatus status,  SourceType sourceType,  String sourceId,  String createdAt,  PaymentHandoffLink handoff)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.fromUserId,_that.fromDisplayName,_that.toUserId,_that.toDisplayName,_that.amount,_that.amountPaid,_that.amountRemaining,_that.status,_that.sourceType,_that.sourceId,_that.createdAt,_that.handoff);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromUserId,  String fromDisplayName,  String toUserId,  String toDisplayName, @AmountConverter()  String amount, @AmountConverter()  String amountPaid, @AmountConverter()  String amountRemaining,  SettlementStatus status,  SourceType sourceType,  String sourceId,  String createdAt,  PaymentHandoffLink handoff)  $default,) {final _that = this;
switch (_that) {
case _Settlement():
return $default(_that.id,_that.fromUserId,_that.fromDisplayName,_that.toUserId,_that.toDisplayName,_that.amount,_that.amountPaid,_that.amountRemaining,_that.status,_that.sourceType,_that.sourceId,_that.createdAt,_that.handoff);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromUserId,  String fromDisplayName,  String toUserId,  String toDisplayName, @AmountConverter()  String amount, @AmountConverter()  String amountPaid, @AmountConverter()  String amountRemaining,  SettlementStatus status,  SourceType sourceType,  String sourceId,  String createdAt,  PaymentHandoffLink handoff)?  $default,) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.fromUserId,_that.fromDisplayName,_that.toUserId,_that.toDisplayName,_that.amount,_that.amountPaid,_that.amountRemaining,_that.status,_that.sourceType,_that.sourceId,_that.createdAt,_that.handoff);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settlement implements Settlement {
  const _Settlement({required this.id, required this.fromUserId, required this.fromDisplayName, required this.toUserId, required this.toDisplayName, @AmountConverter() required this.amount, @AmountConverter() required this.amountPaid, @AmountConverter() required this.amountRemaining, required this.status, required this.sourceType, required this.sourceId, required this.createdAt, required this.handoff});
  factory _Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);

@override final  String id;
@override final  String fromUserId;
@override final  String fromDisplayName;
@override final  String toUserId;
@override final  String toDisplayName;
@override@AmountConverter() final  String amount;
@override@AmountConverter() final  String amountPaid;
@override@AmountConverter() final  String amountRemaining;
@override final  SettlementStatus status;
@override final  SourceType sourceType;
@override final  String sourceId;
@override final  String createdAt;
@override final  PaymentHandoffLink handoff;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementCopyWith<_Settlement> get copyWith => __$SettlementCopyWithImpl<_Settlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromDisplayName, fromDisplayName) || other.fromDisplayName == fromDisplayName)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.toDisplayName, toDisplayName) || other.toDisplayName == toDisplayName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountRemaining, amountRemaining) || other.amountRemaining == amountRemaining)&&(identical(other.status, status) || other.status == status)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.handoff, handoff) || other.handoff == handoff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUserId,fromDisplayName,toUserId,toDisplayName,amount,amountPaid,amountRemaining,status,sourceType,sourceId,createdAt,handoff);

@override
String toString() {
  return 'Settlement(id: $id, fromUserId: $fromUserId, fromDisplayName: $fromDisplayName, toUserId: $toUserId, toDisplayName: $toDisplayName, amount: $amount, amountPaid: $amountPaid, amountRemaining: $amountRemaining, status: $status, sourceType: $sourceType, sourceId: $sourceId, createdAt: $createdAt, handoff: $handoff)';
}


}

/// @nodoc
abstract mixin class _$SettlementCopyWith<$Res> implements $SettlementCopyWith<$Res> {
  factory _$SettlementCopyWith(_Settlement value, $Res Function(_Settlement) _then) = __$SettlementCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromUserId, String fromDisplayName, String toUserId, String toDisplayName,@AmountConverter() String amount,@AmountConverter() String amountPaid,@AmountConverter() String amountRemaining, SettlementStatus status, SourceType sourceType, String sourceId, String createdAt, PaymentHandoffLink handoff
});


@override $PaymentHandoffLinkCopyWith<$Res> get handoff;

}
/// @nodoc
class __$SettlementCopyWithImpl<$Res>
    implements _$SettlementCopyWith<$Res> {
  __$SettlementCopyWithImpl(this._self, this._then);

  final _Settlement _self;
  final $Res Function(_Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUserId = null,Object? fromDisplayName = null,Object? toUserId = null,Object? toDisplayName = null,Object? amount = null,Object? amountPaid = null,Object? amountRemaining = null,Object? status = null,Object? sourceType = null,Object? sourceId = null,Object? createdAt = null,Object? handoff = null,}) {
  return _then(_Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromDisplayName: null == fromDisplayName ? _self.fromDisplayName : fromDisplayName // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,toDisplayName: null == toDisplayName ? _self.toDisplayName : toDisplayName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as String,amountRemaining: null == amountRemaining ? _self.amountRemaining : amountRemaining // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettlementStatus,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as SourceType,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,handoff: null == handoff ? _self.handoff : handoff // ignore: cast_nullable_to_non_nullable
as PaymentHandoffLink,
  ));
}

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentHandoffLinkCopyWith<$Res> get handoff {
  
  return $PaymentHandoffLinkCopyWith<$Res>(_self.handoff, (value) {
    return _then(_self.copyWith(handoff: value));
  });
}
}


/// @nodoc
mixin _$SettlementPayment {

 String get id;@AmountConverter() String get amount; String get recordedByUserId; String get recordedByDisplayName; String? get note; String get paidAt;
/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementPaymentCopyWith<SettlementPayment> get copyWith => _$SettlementPaymentCopyWithImpl<SettlementPayment>(this as SettlementPayment, _$identity);

  /// Serializes this SettlementPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettlementPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.recordedByUserId, recordedByUserId) || other.recordedByUserId == recordedByUserId)&&(identical(other.recordedByDisplayName, recordedByDisplayName) || other.recordedByDisplayName == recordedByDisplayName)&&(identical(other.note, note) || other.note == note)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,recordedByUserId,recordedByDisplayName,note,paidAt);

@override
String toString() {
  return 'SettlementPayment(id: $id, amount: $amount, recordedByUserId: $recordedByUserId, recordedByDisplayName: $recordedByDisplayName, note: $note, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class $SettlementPaymentCopyWith<$Res>  {
  factory $SettlementPaymentCopyWith(SettlementPayment value, $Res Function(SettlementPayment) _then) = _$SettlementPaymentCopyWithImpl;
@useResult
$Res call({
 String id,@AmountConverter() String amount, String recordedByUserId, String recordedByDisplayName, String? note, String paidAt
});




}
/// @nodoc
class _$SettlementPaymentCopyWithImpl<$Res>
    implements $SettlementPaymentCopyWith<$Res> {
  _$SettlementPaymentCopyWithImpl(this._self, this._then);

  final SettlementPayment _self;
  final $Res Function(SettlementPayment) _then;

/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? recordedByUserId = null,Object? recordedByDisplayName = null,Object? note = freezed,Object? paidAt = null,}) {
  return _then(SettlementPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,recordedByUserId: null == recordedByUserId ? _self.recordedByUserId : recordedByUserId // ignore: cast_nullable_to_non_nullable
as String,recordedByDisplayName: null == recordedByDisplayName ? _self.recordedByDisplayName : recordedByDisplayName // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SettlementPayment].
extension SettlementPaymentPatterns on SettlementPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettlementPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettlementPayment value)  $default,){
final _that = this;
switch (_that) {
case _SettlementPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettlementPayment value)?  $default,){
final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @AmountConverter()  String amount,  String recordedByUserId,  String recordedByDisplayName,  String? note,  String paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
return $default(_that.id,_that.amount,_that.recordedByUserId,_that.recordedByDisplayName,_that.note,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @AmountConverter()  String amount,  String recordedByUserId,  String recordedByDisplayName,  String? note,  String paidAt)  $default,) {final _that = this;
switch (_that) {
case _SettlementPayment():
return $default(_that.id,_that.amount,_that.recordedByUserId,_that.recordedByDisplayName,_that.note,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @AmountConverter()  String amount,  String recordedByUserId,  String recordedByDisplayName,  String? note,  String paidAt)?  $default,) {final _that = this;
switch (_that) {
case _SettlementPayment() when $default != null:
return $default(_that.id,_that.amount,_that.recordedByUserId,_that.recordedByDisplayName,_that.note,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettlementPayment implements SettlementPayment {
  const _SettlementPayment({required this.id, @AmountConverter() required this.amount, required this.recordedByUserId, required this.recordedByDisplayName, this.note, required this.paidAt});
  factory _SettlementPayment.fromJson(Map<String, dynamic> json) => _$SettlementPaymentFromJson(json);

@override final  String id;
@override@AmountConverter() final  String amount;
@override final  String recordedByUserId;
@override final  String recordedByDisplayName;
@override final  String? note;
@override final  String paidAt;

/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementPaymentCopyWith<_SettlementPayment> get copyWith => __$SettlementPaymentCopyWithImpl<_SettlementPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettlementPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.recordedByUserId, recordedByUserId) || other.recordedByUserId == recordedByUserId)&&(identical(other.recordedByDisplayName, recordedByDisplayName) || other.recordedByDisplayName == recordedByDisplayName)&&(identical(other.note, note) || other.note == note)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,recordedByUserId,recordedByDisplayName,note,paidAt);

@override
String toString() {
  return 'SettlementPayment(id: $id, amount: $amount, recordedByUserId: $recordedByUserId, recordedByDisplayName: $recordedByDisplayName, note: $note, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$SettlementPaymentCopyWith<$Res> implements $SettlementPaymentCopyWith<$Res> {
  factory _$SettlementPaymentCopyWith(_SettlementPayment value, $Res Function(_SettlementPayment) _then) = __$SettlementPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id,@AmountConverter() String amount, String recordedByUserId, String recordedByDisplayName, String? note, String paidAt
});




}
/// @nodoc
class __$SettlementPaymentCopyWithImpl<$Res>
    implements _$SettlementPaymentCopyWith<$Res> {
  __$SettlementPaymentCopyWithImpl(this._self, this._then);

  final _SettlementPayment _self;
  final $Res Function(_SettlementPayment) _then;

/// Create a copy of SettlementPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? recordedByUserId = null,Object? recordedByDisplayName = null,Object? note = freezed,Object? paidAt = null,}) {
  return _then(_SettlementPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,recordedByUserId: null == recordedByUserId ? _self.recordedByUserId : recordedByUserId // ignore: cast_nullable_to_non_nullable
as String,recordedByDisplayName: null == recordedByDisplayName ? _self.recordedByDisplayName : recordedByDisplayName // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CounterpartySummary {

 String get userId; String get displayName;@AmountConverter() String get netAmount; int get oldestUnpaidDays;
/// Create a copy of CounterpartySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CounterpartySummaryCopyWith<CounterpartySummary> get copyWith => _$CounterpartySummaryCopyWithImpl<CounterpartySummary>(this as CounterpartySummary, _$identity);

  /// Serializes this CounterpartySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CounterpartySummary&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.oldestUnpaidDays, oldestUnpaidDays) || other.oldestUnpaidDays == oldestUnpaidDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,netAmount,oldestUnpaidDays);

@override
String toString() {
  return 'CounterpartySummary(userId: $userId, displayName: $displayName, netAmount: $netAmount, oldestUnpaidDays: $oldestUnpaidDays)';
}


}

/// @nodoc
abstract mixin class $CounterpartySummaryCopyWith<$Res>  {
  factory $CounterpartySummaryCopyWith(CounterpartySummary value, $Res Function(CounterpartySummary) _then) = _$CounterpartySummaryCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName,@AmountConverter() String netAmount, int oldestUnpaidDays
});




}
/// @nodoc
class _$CounterpartySummaryCopyWithImpl<$Res>
    implements $CounterpartySummaryCopyWith<$Res> {
  _$CounterpartySummaryCopyWithImpl(this._self, this._then);

  final CounterpartySummary _self;
  final $Res Function(CounterpartySummary) _then;

/// Create a copy of CounterpartySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? netAmount = null,Object? oldestUnpaidDays = null,}) {
  return _then(CounterpartySummary(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String,oldestUnpaidDays: null == oldestUnpaidDays ? _self.oldestUnpaidDays : oldestUnpaidDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CounterpartySummary].
extension CounterpartySummaryPatterns on CounterpartySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CounterpartySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CounterpartySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CounterpartySummary value)  $default,){
final _that = this;
switch (_that) {
case _CounterpartySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CounterpartySummary value)?  $default,){
final _that = this;
switch (_that) {
case _CounterpartySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String netAmount,  int oldestUnpaidDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CounterpartySummary() when $default != null:
return $default(_that.userId,_that.displayName,_that.netAmount,_that.oldestUnpaidDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName, @AmountConverter()  String netAmount,  int oldestUnpaidDays)  $default,) {final _that = this;
switch (_that) {
case _CounterpartySummary():
return $default(_that.userId,_that.displayName,_that.netAmount,_that.oldestUnpaidDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName, @AmountConverter()  String netAmount,  int oldestUnpaidDays)?  $default,) {final _that = this;
switch (_that) {
case _CounterpartySummary() when $default != null:
return $default(_that.userId,_that.displayName,_that.netAmount,_that.oldestUnpaidDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CounterpartySummary implements CounterpartySummary {
  const _CounterpartySummary({required this.userId, required this.displayName, @AmountConverter() required this.netAmount, required this.oldestUnpaidDays});
  factory _CounterpartySummary.fromJson(Map<String, dynamic> json) => _$CounterpartySummaryFromJson(json);

@override final  String userId;
@override final  String displayName;
@override@AmountConverter() final  String netAmount;
@override final  int oldestUnpaidDays;

/// Create a copy of CounterpartySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CounterpartySummaryCopyWith<_CounterpartySummary> get copyWith => __$CounterpartySummaryCopyWithImpl<_CounterpartySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CounterpartySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CounterpartySummary&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.oldestUnpaidDays, oldestUnpaidDays) || other.oldestUnpaidDays == oldestUnpaidDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,netAmount,oldestUnpaidDays);

@override
String toString() {
  return 'CounterpartySummary(userId: $userId, displayName: $displayName, netAmount: $netAmount, oldestUnpaidDays: $oldestUnpaidDays)';
}


}

/// @nodoc
abstract mixin class _$CounterpartySummaryCopyWith<$Res> implements $CounterpartySummaryCopyWith<$Res> {
  factory _$CounterpartySummaryCopyWith(_CounterpartySummary value, $Res Function(_CounterpartySummary) _then) = __$CounterpartySummaryCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName,@AmountConverter() String netAmount, int oldestUnpaidDays
});




}
/// @nodoc
class __$CounterpartySummaryCopyWithImpl<$Res>
    implements _$CounterpartySummaryCopyWith<$Res> {
  __$CounterpartySummaryCopyWithImpl(this._self, this._then);

  final _CounterpartySummary _self;
  final $Res Function(_CounterpartySummary) _then;

/// Create a copy of CounterpartySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? netAmount = null,Object? oldestUnpaidDays = null,}) {
  return _then(_CounterpartySummary(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as String,oldestUnpaidDays: null == oldestUnpaidDays ? _self.oldestUnpaidDays : oldestUnpaidDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SettlementSummary {

@AmountConverter() String get totalOwedToMe;@AmountConverter() String get totalIOwe; List<CounterpartySummary> get owedToMe; List<CounterpartySummary> get iOwe;
/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementSummaryCopyWith<SettlementSummary> get copyWith => _$SettlementSummaryCopyWithImpl<SettlementSummary>(this as SettlementSummary, _$identity);

  /// Serializes this SettlementSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettlementSummary&&(identical(other.totalOwedToMe, totalOwedToMe) || other.totalOwedToMe == totalOwedToMe)&&(identical(other.totalIOwe, totalIOwe) || other.totalIOwe == totalIOwe)&&const DeepCollectionEquality().equals(other.owedToMe, owedToMe)&&const DeepCollectionEquality().equals(other.iOwe, iOwe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalOwedToMe,totalIOwe,const DeepCollectionEquality().hash(owedToMe),const DeepCollectionEquality().hash(iOwe));

@override
String toString() {
  return 'SettlementSummary(totalOwedToMe: $totalOwedToMe, totalIOwe: $totalIOwe, owedToMe: $owedToMe, iOwe: $iOwe)';
}


}

/// @nodoc
abstract mixin class $SettlementSummaryCopyWith<$Res>  {
  factory $SettlementSummaryCopyWith(SettlementSummary value, $Res Function(SettlementSummary) _then) = _$SettlementSummaryCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String totalOwedToMe,@AmountConverter() String totalIOwe, List<CounterpartySummary> owedToMe, List<CounterpartySummary> iOwe
});




}
/// @nodoc
class _$SettlementSummaryCopyWithImpl<$Res>
    implements $SettlementSummaryCopyWith<$Res> {
  _$SettlementSummaryCopyWithImpl(this._self, this._then);

  final SettlementSummary _self;
  final $Res Function(SettlementSummary) _then;

/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalOwedToMe = null,Object? totalIOwe = null,Object? owedToMe = null,Object? iOwe = null,}) {
  return _then(SettlementSummary(
totalOwedToMe: null == totalOwedToMe ? _self.totalOwedToMe : totalOwedToMe // ignore: cast_nullable_to_non_nullable
as String,totalIOwe: null == totalIOwe ? _self.totalIOwe : totalIOwe // ignore: cast_nullable_to_non_nullable
as String,owedToMe: null == owedToMe ? _self.owedToMe : owedToMe // ignore: cast_nullable_to_non_nullable
as List<CounterpartySummary>,iOwe: null == iOwe ? _self.iOwe : iOwe // ignore: cast_nullable_to_non_nullable
as List<CounterpartySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [SettlementSummary].
extension SettlementSummaryPatterns on SettlementSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettlementSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettlementSummary value)  $default,){
final _that = this;
switch (_that) {
case _SettlementSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettlementSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String totalOwedToMe, @AmountConverter()  String totalIOwe,  List<CounterpartySummary> owedToMe,  List<CounterpartySummary> iOwe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
return $default(_that.totalOwedToMe,_that.totalIOwe,_that.owedToMe,_that.iOwe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String totalOwedToMe, @AmountConverter()  String totalIOwe,  List<CounterpartySummary> owedToMe,  List<CounterpartySummary> iOwe)  $default,) {final _that = this;
switch (_that) {
case _SettlementSummary():
return $default(_that.totalOwedToMe,_that.totalIOwe,_that.owedToMe,_that.iOwe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String totalOwedToMe, @AmountConverter()  String totalIOwe,  List<CounterpartySummary> owedToMe,  List<CounterpartySummary> iOwe)?  $default,) {final _that = this;
switch (_that) {
case _SettlementSummary() when $default != null:
return $default(_that.totalOwedToMe,_that.totalIOwe,_that.owedToMe,_that.iOwe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettlementSummary implements SettlementSummary {
  const _SettlementSummary({@AmountConverter() required this.totalOwedToMe, @AmountConverter() required this.totalIOwe, required  List<CounterpartySummary> owedToMe, required  List<CounterpartySummary> iOwe}): _owedToMe = owedToMe,_iOwe = iOwe;
  factory _SettlementSummary.fromJson(Map<String, dynamic> json) => _$SettlementSummaryFromJson(json);

@override@AmountConverter() final  String totalOwedToMe;
@override@AmountConverter() final  String totalIOwe;
 final  List<CounterpartySummary> _owedToMe;
@override List<CounterpartySummary> get owedToMe {
  if (_owedToMe is EqualUnmodifiableListView) return _owedToMe;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_owedToMe);
}

 final  List<CounterpartySummary> _iOwe;
@override List<CounterpartySummary> get iOwe {
  if (_iOwe is EqualUnmodifiableListView) return _iOwe;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_iOwe);
}


/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementSummaryCopyWith<_SettlementSummary> get copyWith => __$SettlementSummaryCopyWithImpl<_SettlementSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettlementSummary&&(identical(other.totalOwedToMe, totalOwedToMe) || other.totalOwedToMe == totalOwedToMe)&&(identical(other.totalIOwe, totalIOwe) || other.totalIOwe == totalIOwe)&&const DeepCollectionEquality().equals(other._owedToMe, _owedToMe)&&const DeepCollectionEquality().equals(other._iOwe, _iOwe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalOwedToMe,totalIOwe,const DeepCollectionEquality().hash(_owedToMe),const DeepCollectionEquality().hash(_iOwe));

@override
String toString() {
  return 'SettlementSummary(totalOwedToMe: $totalOwedToMe, totalIOwe: $totalIOwe, owedToMe: $owedToMe, iOwe: $iOwe)';
}


}

/// @nodoc
abstract mixin class _$SettlementSummaryCopyWith<$Res> implements $SettlementSummaryCopyWith<$Res> {
  factory _$SettlementSummaryCopyWith(_SettlementSummary value, $Res Function(_SettlementSummary) _then) = __$SettlementSummaryCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String totalOwedToMe,@AmountConverter() String totalIOwe, List<CounterpartySummary> owedToMe, List<CounterpartySummary> iOwe
});




}
/// @nodoc
class __$SettlementSummaryCopyWithImpl<$Res>
    implements _$SettlementSummaryCopyWith<$Res> {
  __$SettlementSummaryCopyWithImpl(this._self, this._then);

  final _SettlementSummary _self;
  final $Res Function(_SettlementSummary) _then;

/// Create a copy of SettlementSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalOwedToMe = null,Object? totalIOwe = null,Object? owedToMe = null,Object? iOwe = null,}) {
  return _then(_SettlementSummary(
totalOwedToMe: null == totalOwedToMe ? _self.totalOwedToMe : totalOwedToMe // ignore: cast_nullable_to_non_nullable
as String,totalIOwe: null == totalIOwe ? _self.totalIOwe : totalIOwe // ignore: cast_nullable_to_non_nullable
as String,owedToMe: null == owedToMe ? _self._owedToMe : owedToMe // ignore: cast_nullable_to_non_nullable
as List<CounterpartySummary>,iOwe: null == iOwe ? _self._iOwe : iOwe // ignore: cast_nullable_to_non_nullable
as List<CounterpartySummary>,
  ));
}


}

// dart format on
