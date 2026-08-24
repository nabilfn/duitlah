// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reconciliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessStatementImportResponse {

 String get id; String get businessAccountId; StatementProvider get provider; String get originalFilename; BusinessStatementImportStatus get status; int get rowCount; String? get errorMessage; String? get reconciliationSessionId;
/// Create a copy of BusinessStatementImportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessStatementImportResponseCopyWith<BusinessStatementImportResponse> get copyWith => _$BusinessStatementImportResponseCopyWithImpl<BusinessStatementImportResponse>(this as BusinessStatementImportResponse, _$identity);

  /// Serializes this BusinessStatementImportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessStatementImportResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.status, status) || other.status == status)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.reconciliationSessionId, reconciliationSessionId) || other.reconciliationSessionId == reconciliationSessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,provider,originalFilename,status,rowCount,errorMessage,reconciliationSessionId);

@override
String toString() {
  return 'BusinessStatementImportResponse(id: $id, businessAccountId: $businessAccountId, provider: $provider, originalFilename: $originalFilename, status: $status, rowCount: $rowCount, errorMessage: $errorMessage, reconciliationSessionId: $reconciliationSessionId)';
}


}

/// @nodoc
abstract mixin class $BusinessStatementImportResponseCopyWith<$Res>  {
  factory $BusinessStatementImportResponseCopyWith(BusinessStatementImportResponse value, $Res Function(BusinessStatementImportResponse) _then) = _$BusinessStatementImportResponseCopyWithImpl;
@useResult
$Res call({
 String id, String businessAccountId, StatementProvider provider, String originalFilename, BusinessStatementImportStatus status, int rowCount, String? errorMessage, String? reconciliationSessionId
});




}
/// @nodoc
class _$BusinessStatementImportResponseCopyWithImpl<$Res>
    implements $BusinessStatementImportResponseCopyWith<$Res> {
  _$BusinessStatementImportResponseCopyWithImpl(this._self, this._then);

  final BusinessStatementImportResponse _self;
  final $Res Function(BusinessStatementImportResponse) _then;

/// Create a copy of BusinessStatementImportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessAccountId = null,Object? provider = null,Object? originalFilename = null,Object? status = null,Object? rowCount = null,Object? errorMessage = freezed,Object? reconciliationSessionId = freezed,}) {
  return _then(BusinessStatementImportResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as StatementProvider,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BusinessStatementImportStatus,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,reconciliationSessionId: freezed == reconciliationSessionId ? _self.reconciliationSessionId : reconciliationSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessStatementImportResponse].
extension BusinessStatementImportResponsePatterns on BusinessStatementImportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessStatementImportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessStatementImportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessStatementImportResponse value)  $default,){
final _that = this;
switch (_that) {
case _BusinessStatementImportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessStatementImportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessStatementImportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessAccountId,  StatementProvider provider,  String originalFilename,  BusinessStatementImportStatus status,  int rowCount,  String? errorMessage,  String? reconciliationSessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessStatementImportResponse() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.provider,_that.originalFilename,_that.status,_that.rowCount,_that.errorMessage,_that.reconciliationSessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessAccountId,  StatementProvider provider,  String originalFilename,  BusinessStatementImportStatus status,  int rowCount,  String? errorMessage,  String? reconciliationSessionId)  $default,) {final _that = this;
switch (_that) {
case _BusinessStatementImportResponse():
return $default(_that.id,_that.businessAccountId,_that.provider,_that.originalFilename,_that.status,_that.rowCount,_that.errorMessage,_that.reconciliationSessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessAccountId,  StatementProvider provider,  String originalFilename,  BusinessStatementImportStatus status,  int rowCount,  String? errorMessage,  String? reconciliationSessionId)?  $default,) {final _that = this;
switch (_that) {
case _BusinessStatementImportResponse() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.provider,_that.originalFilename,_that.status,_that.rowCount,_that.errorMessage,_that.reconciliationSessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessStatementImportResponse implements BusinessStatementImportResponse {
  const _BusinessStatementImportResponse({required this.id, required this.businessAccountId, required this.provider, required this.originalFilename, required this.status, required this.rowCount, this.errorMessage, this.reconciliationSessionId});
  factory _BusinessStatementImportResponse.fromJson(Map<String, dynamic> json) => _$BusinessStatementImportResponseFromJson(json);

@override final  String id;
@override final  String businessAccountId;
@override final  StatementProvider provider;
@override final  String originalFilename;
@override final  BusinessStatementImportStatus status;
@override final  int rowCount;
@override final  String? errorMessage;
@override final  String? reconciliationSessionId;

/// Create a copy of BusinessStatementImportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessStatementImportResponseCopyWith<_BusinessStatementImportResponse> get copyWith => __$BusinessStatementImportResponseCopyWithImpl<_BusinessStatementImportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessStatementImportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessStatementImportResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.status, status) || other.status == status)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.reconciliationSessionId, reconciliationSessionId) || other.reconciliationSessionId == reconciliationSessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,provider,originalFilename,status,rowCount,errorMessage,reconciliationSessionId);

@override
String toString() {
  return 'BusinessStatementImportResponse(id: $id, businessAccountId: $businessAccountId, provider: $provider, originalFilename: $originalFilename, status: $status, rowCount: $rowCount, errorMessage: $errorMessage, reconciliationSessionId: $reconciliationSessionId)';
}


}

/// @nodoc
abstract mixin class _$BusinessStatementImportResponseCopyWith<$Res> implements $BusinessStatementImportResponseCopyWith<$Res> {
  factory _$BusinessStatementImportResponseCopyWith(_BusinessStatementImportResponse value, $Res Function(_BusinessStatementImportResponse) _then) = __$BusinessStatementImportResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessAccountId, StatementProvider provider, String originalFilename, BusinessStatementImportStatus status, int rowCount, String? errorMessage, String? reconciliationSessionId
});




}
/// @nodoc
class __$BusinessStatementImportResponseCopyWithImpl<$Res>
    implements _$BusinessStatementImportResponseCopyWith<$Res> {
  __$BusinessStatementImportResponseCopyWithImpl(this._self, this._then);

  final _BusinessStatementImportResponse _self;
  final $Res Function(_BusinessStatementImportResponse) _then;

/// Create a copy of BusinessStatementImportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessAccountId = null,Object? provider = null,Object? originalFilename = null,Object? status = null,Object? rowCount = null,Object? errorMessage = freezed,Object? reconciliationSessionId = freezed,}) {
  return _then(_BusinessStatementImportResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as StatementProvider,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BusinessStatementImportStatus,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,reconciliationSessionId: freezed == reconciliationSessionId ? _self.reconciliationSessionId : reconciliationSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StatementLineResponse {

 String get id; String get occurredOn; String? get description;@AmountConverter() String get amount; StatementLineStatus get status;
/// Create a copy of StatementLineResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatementLineResponseCopyWith<StatementLineResponse> get copyWith => _$StatementLineResponseCopyWithImpl<StatementLineResponse>(this as StatementLineResponse, _$identity);

  /// Serializes this StatementLineResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatementLineResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,occurredOn,description,amount,status);

@override
String toString() {
  return 'StatementLineResponse(id: $id, occurredOn: $occurredOn, description: $description, amount: $amount, status: $status)';
}


}

/// @nodoc
abstract mixin class $StatementLineResponseCopyWith<$Res>  {
  factory $StatementLineResponseCopyWith(StatementLineResponse value, $Res Function(StatementLineResponse) _then) = _$StatementLineResponseCopyWithImpl;
@useResult
$Res call({
 String id, String occurredOn, String? description,@AmountConverter() String amount, StatementLineStatus status
});




}
/// @nodoc
class _$StatementLineResponseCopyWithImpl<$Res>
    implements $StatementLineResponseCopyWith<$Res> {
  _$StatementLineResponseCopyWithImpl(this._self, this._then);

  final StatementLineResponse _self;
  final $Res Function(StatementLineResponse) _then;

/// Create a copy of StatementLineResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? occurredOn = null,Object? description = freezed,Object? amount = null,Object? status = null,}) {
  return _then(StatementLineResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StatementLineStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [StatementLineResponse].
extension StatementLineResponsePatterns on StatementLineResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatementLineResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatementLineResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatementLineResponse value)  $default,){
final _that = this;
switch (_that) {
case _StatementLineResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatementLineResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StatementLineResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String occurredOn,  String? description, @AmountConverter()  String amount,  StatementLineStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatementLineResponse() when $default != null:
return $default(_that.id,_that.occurredOn,_that.description,_that.amount,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String occurredOn,  String? description, @AmountConverter()  String amount,  StatementLineStatus status)  $default,) {final _that = this;
switch (_that) {
case _StatementLineResponse():
return $default(_that.id,_that.occurredOn,_that.description,_that.amount,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String occurredOn,  String? description, @AmountConverter()  String amount,  StatementLineStatus status)?  $default,) {final _that = this;
switch (_that) {
case _StatementLineResponse() when $default != null:
return $default(_that.id,_that.occurredOn,_that.description,_that.amount,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatementLineResponse implements StatementLineResponse {
  const _StatementLineResponse({required this.id, required this.occurredOn, this.description, @AmountConverter() required this.amount, required this.status});
  factory _StatementLineResponse.fromJson(Map<String, dynamic> json) => _$StatementLineResponseFromJson(json);

@override final  String id;
@override final  String occurredOn;
@override final  String? description;
@override@AmountConverter() final  String amount;
@override final  StatementLineStatus status;

/// Create a copy of StatementLineResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatementLineResponseCopyWith<_StatementLineResponse> get copyWith => __$StatementLineResponseCopyWithImpl<_StatementLineResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatementLineResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatementLineResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,occurredOn,description,amount,status);

@override
String toString() {
  return 'StatementLineResponse(id: $id, occurredOn: $occurredOn, description: $description, amount: $amount, status: $status)';
}


}

/// @nodoc
abstract mixin class _$StatementLineResponseCopyWith<$Res> implements $StatementLineResponseCopyWith<$Res> {
  factory _$StatementLineResponseCopyWith(_StatementLineResponse value, $Res Function(_StatementLineResponse) _then) = __$StatementLineResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String occurredOn, String? description,@AmountConverter() String amount, StatementLineStatus status
});




}
/// @nodoc
class __$StatementLineResponseCopyWithImpl<$Res>
    implements _$StatementLineResponseCopyWith<$Res> {
  __$StatementLineResponseCopyWithImpl(this._self, this._then);

  final _StatementLineResponse _self;
  final $Res Function(_StatementLineResponse) _then;

/// Create a copy of StatementLineResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? occurredOn = null,Object? description = freezed,Object? amount = null,Object? status = null,}) {
  return _then(_StatementLineResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StatementLineStatus,
  ));
}


}


/// @nodoc
mixin _$MatchSuggestionResponse {

 String get businessAccountEntryId; String get occurredOn; String? get description;@AmountConverter() String get signedAmount; MatchConfidence get confidence;
/// Create a copy of MatchSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchSuggestionResponseCopyWith<MatchSuggestionResponse> get copyWith => _$MatchSuggestionResponseCopyWithImpl<MatchSuggestionResponse>(this as MatchSuggestionResponse, _$identity);

  /// Serializes this MatchSuggestionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchSuggestionResponse&&(identical(other.businessAccountEntryId, businessAccountEntryId) || other.businessAccountEntryId == businessAccountEntryId)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.signedAmount, signedAmount) || other.signedAmount == signedAmount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,businessAccountEntryId,occurredOn,description,signedAmount,confidence);

@override
String toString() {
  return 'MatchSuggestionResponse(businessAccountEntryId: $businessAccountEntryId, occurredOn: $occurredOn, description: $description, signedAmount: $signedAmount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $MatchSuggestionResponseCopyWith<$Res>  {
  factory $MatchSuggestionResponseCopyWith(MatchSuggestionResponse value, $Res Function(MatchSuggestionResponse) _then) = _$MatchSuggestionResponseCopyWithImpl;
@useResult
$Res call({
 String businessAccountEntryId, String occurredOn, String? description,@AmountConverter() String signedAmount, MatchConfidence confidence
});




}
/// @nodoc
class _$MatchSuggestionResponseCopyWithImpl<$Res>
    implements $MatchSuggestionResponseCopyWith<$Res> {
  _$MatchSuggestionResponseCopyWithImpl(this._self, this._then);

  final MatchSuggestionResponse _self;
  final $Res Function(MatchSuggestionResponse) _then;

/// Create a copy of MatchSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? businessAccountEntryId = null,Object? occurredOn = null,Object? description = freezed,Object? signedAmount = null,Object? confidence = null,}) {
  return _then(MatchSuggestionResponse(
businessAccountEntryId: null == businessAccountEntryId ? _self.businessAccountEntryId : businessAccountEntryId // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,signedAmount: null == signedAmount ? _self.signedAmount : signedAmount // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as MatchConfidence,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchSuggestionResponse].
extension MatchSuggestionResponsePatterns on MatchSuggestionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchSuggestionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchSuggestionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchSuggestionResponse value)  $default,){
final _that = this;
switch (_that) {
case _MatchSuggestionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchSuggestionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MatchSuggestionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String businessAccountEntryId,  String occurredOn,  String? description, @AmountConverter()  String signedAmount,  MatchConfidence confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchSuggestionResponse() when $default != null:
return $default(_that.businessAccountEntryId,_that.occurredOn,_that.description,_that.signedAmount,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String businessAccountEntryId,  String occurredOn,  String? description, @AmountConverter()  String signedAmount,  MatchConfidence confidence)  $default,) {final _that = this;
switch (_that) {
case _MatchSuggestionResponse():
return $default(_that.businessAccountEntryId,_that.occurredOn,_that.description,_that.signedAmount,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String businessAccountEntryId,  String occurredOn,  String? description, @AmountConverter()  String signedAmount,  MatchConfidence confidence)?  $default,) {final _that = this;
switch (_that) {
case _MatchSuggestionResponse() when $default != null:
return $default(_that.businessAccountEntryId,_that.occurredOn,_that.description,_that.signedAmount,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchSuggestionResponse implements MatchSuggestionResponse {
  const _MatchSuggestionResponse({required this.businessAccountEntryId, required this.occurredOn, this.description, @AmountConverter() required this.signedAmount, required this.confidence});
  factory _MatchSuggestionResponse.fromJson(Map<String, dynamic> json) => _$MatchSuggestionResponseFromJson(json);

@override final  String businessAccountEntryId;
@override final  String occurredOn;
@override final  String? description;
@override@AmountConverter() final  String signedAmount;
@override final  MatchConfidence confidence;

/// Create a copy of MatchSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchSuggestionResponseCopyWith<_MatchSuggestionResponse> get copyWith => __$MatchSuggestionResponseCopyWithImpl<_MatchSuggestionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchSuggestionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchSuggestionResponse&&(identical(other.businessAccountEntryId, businessAccountEntryId) || other.businessAccountEntryId == businessAccountEntryId)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.description, description) || other.description == description)&&(identical(other.signedAmount, signedAmount) || other.signedAmount == signedAmount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,businessAccountEntryId,occurredOn,description,signedAmount,confidence);

@override
String toString() {
  return 'MatchSuggestionResponse(businessAccountEntryId: $businessAccountEntryId, occurredOn: $occurredOn, description: $description, signedAmount: $signedAmount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$MatchSuggestionResponseCopyWith<$Res> implements $MatchSuggestionResponseCopyWith<$Res> {
  factory _$MatchSuggestionResponseCopyWith(_MatchSuggestionResponse value, $Res Function(_MatchSuggestionResponse) _then) = __$MatchSuggestionResponseCopyWithImpl;
@override @useResult
$Res call({
 String businessAccountEntryId, String occurredOn, String? description,@AmountConverter() String signedAmount, MatchConfidence confidence
});




}
/// @nodoc
class __$MatchSuggestionResponseCopyWithImpl<$Res>
    implements _$MatchSuggestionResponseCopyWith<$Res> {
  __$MatchSuggestionResponseCopyWithImpl(this._self, this._then);

  final _MatchSuggestionResponse _self;
  final $Res Function(_MatchSuggestionResponse) _then;

/// Create a copy of MatchSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? businessAccountEntryId = null,Object? occurredOn = null,Object? description = freezed,Object? signedAmount = null,Object? confidence = null,}) {
  return _then(_MatchSuggestionResponse(
businessAccountEntryId: null == businessAccountEntryId ? _self.businessAccountEntryId : businessAccountEntryId // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,signedAmount: null == signedAmount ? _self.signedAmount : signedAmount // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as MatchConfidence,
  ));
}


}


/// @nodoc
mixin _$ReconciliationSessionResponse {

 String get id; String get businessAccountId; String get businessStatementImportId;@NullableAmountConverter() String? get statementEndingBalance; ReconciliationSessionStatus get status; String get startedAt; String? get completedAt;
/// Create a copy of ReconciliationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReconciliationSessionResponseCopyWith<ReconciliationSessionResponse> get copyWith => _$ReconciliationSessionResponseCopyWithImpl<ReconciliationSessionResponse>(this as ReconciliationSessionResponse, _$identity);

  /// Serializes this ReconciliationSessionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReconciliationSessionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.businessStatementImportId, businessStatementImportId) || other.businessStatementImportId == businessStatementImportId)&&(identical(other.statementEndingBalance, statementEndingBalance) || other.statementEndingBalance == statementEndingBalance)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,businessStatementImportId,statementEndingBalance,status,startedAt,completedAt);

@override
String toString() {
  return 'ReconciliationSessionResponse(id: $id, businessAccountId: $businessAccountId, businessStatementImportId: $businessStatementImportId, statementEndingBalance: $statementEndingBalance, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $ReconciliationSessionResponseCopyWith<$Res>  {
  factory $ReconciliationSessionResponseCopyWith(ReconciliationSessionResponse value, $Res Function(ReconciliationSessionResponse) _then) = _$ReconciliationSessionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String businessAccountId, String businessStatementImportId,@NullableAmountConverter() String? statementEndingBalance, ReconciliationSessionStatus status, String startedAt, String? completedAt
});




}
/// @nodoc
class _$ReconciliationSessionResponseCopyWithImpl<$Res>
    implements $ReconciliationSessionResponseCopyWith<$Res> {
  _$ReconciliationSessionResponseCopyWithImpl(this._self, this._then);

  final ReconciliationSessionResponse _self;
  final $Res Function(ReconciliationSessionResponse) _then;

/// Create a copy of ReconciliationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessAccountId = null,Object? businessStatementImportId = null,Object? statementEndingBalance = freezed,Object? status = null,Object? startedAt = null,Object? completedAt = freezed,}) {
  return _then(ReconciliationSessionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,businessStatementImportId: null == businessStatementImportId ? _self.businessStatementImportId : businessStatementImportId // ignore: cast_nullable_to_non_nullable
as String,statementEndingBalance: freezed == statementEndingBalance ? _self.statementEndingBalance : statementEndingBalance // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReconciliationSessionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReconciliationSessionResponse].
extension ReconciliationSessionResponsePatterns on ReconciliationSessionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReconciliationSessionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReconciliationSessionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReconciliationSessionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ReconciliationSessionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReconciliationSessionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ReconciliationSessionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessAccountId,  String businessStatementImportId, @NullableAmountConverter()  String? statementEndingBalance,  ReconciliationSessionStatus status,  String startedAt,  String? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReconciliationSessionResponse() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.businessStatementImportId,_that.statementEndingBalance,_that.status,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessAccountId,  String businessStatementImportId, @NullableAmountConverter()  String? statementEndingBalance,  ReconciliationSessionStatus status,  String startedAt,  String? completedAt)  $default,) {final _that = this;
switch (_that) {
case _ReconciliationSessionResponse():
return $default(_that.id,_that.businessAccountId,_that.businessStatementImportId,_that.statementEndingBalance,_that.status,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessAccountId,  String businessStatementImportId, @NullableAmountConverter()  String? statementEndingBalance,  ReconciliationSessionStatus status,  String startedAt,  String? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReconciliationSessionResponse() when $default != null:
return $default(_that.id,_that.businessAccountId,_that.businessStatementImportId,_that.statementEndingBalance,_that.status,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReconciliationSessionResponse implements ReconciliationSessionResponse {
  const _ReconciliationSessionResponse({required this.id, required this.businessAccountId, required this.businessStatementImportId, @NullableAmountConverter() this.statementEndingBalance, required this.status, required this.startedAt, this.completedAt});
  factory _ReconciliationSessionResponse.fromJson(Map<String, dynamic> json) => _$ReconciliationSessionResponseFromJson(json);

@override final  String id;
@override final  String businessAccountId;
@override final  String businessStatementImportId;
@override@NullableAmountConverter() final  String? statementEndingBalance;
@override final  ReconciliationSessionStatus status;
@override final  String startedAt;
@override final  String? completedAt;

/// Create a copy of ReconciliationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReconciliationSessionResponseCopyWith<_ReconciliationSessionResponse> get copyWith => __$ReconciliationSessionResponseCopyWithImpl<_ReconciliationSessionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReconciliationSessionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReconciliationSessionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.businessAccountId, businessAccountId) || other.businessAccountId == businessAccountId)&&(identical(other.businessStatementImportId, businessStatementImportId) || other.businessStatementImportId == businessStatementImportId)&&(identical(other.statementEndingBalance, statementEndingBalance) || other.statementEndingBalance == statementEndingBalance)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessAccountId,businessStatementImportId,statementEndingBalance,status,startedAt,completedAt);

@override
String toString() {
  return 'ReconciliationSessionResponse(id: $id, businessAccountId: $businessAccountId, businessStatementImportId: $businessStatementImportId, statementEndingBalance: $statementEndingBalance, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$ReconciliationSessionResponseCopyWith<$Res> implements $ReconciliationSessionResponseCopyWith<$Res> {
  factory _$ReconciliationSessionResponseCopyWith(_ReconciliationSessionResponse value, $Res Function(_ReconciliationSessionResponse) _then) = __$ReconciliationSessionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessAccountId, String businessStatementImportId,@NullableAmountConverter() String? statementEndingBalance, ReconciliationSessionStatus status, String startedAt, String? completedAt
});




}
/// @nodoc
class __$ReconciliationSessionResponseCopyWithImpl<$Res>
    implements _$ReconciliationSessionResponseCopyWith<$Res> {
  __$ReconciliationSessionResponseCopyWithImpl(this._self, this._then);

  final _ReconciliationSessionResponse _self;
  final $Res Function(_ReconciliationSessionResponse) _then;

/// Create a copy of ReconciliationSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessAccountId = null,Object? businessStatementImportId = null,Object? statementEndingBalance = freezed,Object? status = null,Object? startedAt = null,Object? completedAt = freezed,}) {
  return _then(_ReconciliationSessionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessAccountId: null == businessAccountId ? _self.businessAccountId : businessAccountId // ignore: cast_nullable_to_non_nullable
as String,businessStatementImportId: null == businessStatementImportId ? _self.businessStatementImportId : businessStatementImportId // ignore: cast_nullable_to_non_nullable
as String,statementEndingBalance: freezed == statementEndingBalance ? _self.statementEndingBalance : statementEndingBalance // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReconciliationSessionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReconciliationSummaryResponse {

 int get unmatchedCount; int get matchedCount; int get createdCount; int get ignoredCount; int get splitCount;@NullableAmountConverter() String? get statementEndingBalance;@AmountConverter() String get ledgerBalance;@NullableAmountConverter() String? get difference;
/// Create a copy of ReconciliationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReconciliationSummaryResponseCopyWith<ReconciliationSummaryResponse> get copyWith => _$ReconciliationSummaryResponseCopyWithImpl<ReconciliationSummaryResponse>(this as ReconciliationSummaryResponse, _$identity);

  /// Serializes this ReconciliationSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReconciliationSummaryResponse&&(identical(other.unmatchedCount, unmatchedCount) || other.unmatchedCount == unmatchedCount)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.createdCount, createdCount) || other.createdCount == createdCount)&&(identical(other.ignoredCount, ignoredCount) || other.ignoredCount == ignoredCount)&&(identical(other.splitCount, splitCount) || other.splitCount == splitCount)&&(identical(other.statementEndingBalance, statementEndingBalance) || other.statementEndingBalance == statementEndingBalance)&&(identical(other.ledgerBalance, ledgerBalance) || other.ledgerBalance == ledgerBalance)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unmatchedCount,matchedCount,createdCount,ignoredCount,splitCount,statementEndingBalance,ledgerBalance,difference);

@override
String toString() {
  return 'ReconciliationSummaryResponse(unmatchedCount: $unmatchedCount, matchedCount: $matchedCount, createdCount: $createdCount, ignoredCount: $ignoredCount, splitCount: $splitCount, statementEndingBalance: $statementEndingBalance, ledgerBalance: $ledgerBalance, difference: $difference)';
}


}

/// @nodoc
abstract mixin class $ReconciliationSummaryResponseCopyWith<$Res>  {
  factory $ReconciliationSummaryResponseCopyWith(ReconciliationSummaryResponse value, $Res Function(ReconciliationSummaryResponse) _then) = _$ReconciliationSummaryResponseCopyWithImpl;
@useResult
$Res call({
 int unmatchedCount, int matchedCount, int createdCount, int ignoredCount, int splitCount,@NullableAmountConverter() String? statementEndingBalance,@AmountConverter() String ledgerBalance,@NullableAmountConverter() String? difference
});




}
/// @nodoc
class _$ReconciliationSummaryResponseCopyWithImpl<$Res>
    implements $ReconciliationSummaryResponseCopyWith<$Res> {
  _$ReconciliationSummaryResponseCopyWithImpl(this._self, this._then);

  final ReconciliationSummaryResponse _self;
  final $Res Function(ReconciliationSummaryResponse) _then;

/// Create a copy of ReconciliationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unmatchedCount = null,Object? matchedCount = null,Object? createdCount = null,Object? ignoredCount = null,Object? splitCount = null,Object? statementEndingBalance = freezed,Object? ledgerBalance = null,Object? difference = freezed,}) {
  return _then(ReconciliationSummaryResponse(
unmatchedCount: null == unmatchedCount ? _self.unmatchedCount : unmatchedCount // ignore: cast_nullable_to_non_nullable
as int,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,createdCount: null == createdCount ? _self.createdCount : createdCount // ignore: cast_nullable_to_non_nullable
as int,ignoredCount: null == ignoredCount ? _self.ignoredCount : ignoredCount // ignore: cast_nullable_to_non_nullable
as int,splitCount: null == splitCount ? _self.splitCount : splitCount // ignore: cast_nullable_to_non_nullable
as int,statementEndingBalance: freezed == statementEndingBalance ? _self.statementEndingBalance : statementEndingBalance // ignore: cast_nullable_to_non_nullable
as String?,ledgerBalance: null == ledgerBalance ? _self.ledgerBalance : ledgerBalance // ignore: cast_nullable_to_non_nullable
as String,difference: freezed == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReconciliationSummaryResponse].
extension ReconciliationSummaryResponsePatterns on ReconciliationSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReconciliationSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReconciliationSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReconciliationSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _ReconciliationSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReconciliationSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ReconciliationSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int unmatchedCount,  int matchedCount,  int createdCount,  int ignoredCount,  int splitCount, @NullableAmountConverter()  String? statementEndingBalance, @AmountConverter()  String ledgerBalance, @NullableAmountConverter()  String? difference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReconciliationSummaryResponse() when $default != null:
return $default(_that.unmatchedCount,_that.matchedCount,_that.createdCount,_that.ignoredCount,_that.splitCount,_that.statementEndingBalance,_that.ledgerBalance,_that.difference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int unmatchedCount,  int matchedCount,  int createdCount,  int ignoredCount,  int splitCount, @NullableAmountConverter()  String? statementEndingBalance, @AmountConverter()  String ledgerBalance, @NullableAmountConverter()  String? difference)  $default,) {final _that = this;
switch (_that) {
case _ReconciliationSummaryResponse():
return $default(_that.unmatchedCount,_that.matchedCount,_that.createdCount,_that.ignoredCount,_that.splitCount,_that.statementEndingBalance,_that.ledgerBalance,_that.difference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int unmatchedCount,  int matchedCount,  int createdCount,  int ignoredCount,  int splitCount, @NullableAmountConverter()  String? statementEndingBalance, @AmountConverter()  String ledgerBalance, @NullableAmountConverter()  String? difference)?  $default,) {final _that = this;
switch (_that) {
case _ReconciliationSummaryResponse() when $default != null:
return $default(_that.unmatchedCount,_that.matchedCount,_that.createdCount,_that.ignoredCount,_that.splitCount,_that.statementEndingBalance,_that.ledgerBalance,_that.difference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReconciliationSummaryResponse implements ReconciliationSummaryResponse {
  const _ReconciliationSummaryResponse({required this.unmatchedCount, required this.matchedCount, required this.createdCount, required this.ignoredCount, required this.splitCount, @NullableAmountConverter() this.statementEndingBalance, @AmountConverter() required this.ledgerBalance, @NullableAmountConverter() this.difference});
  factory _ReconciliationSummaryResponse.fromJson(Map<String, dynamic> json) => _$ReconciliationSummaryResponseFromJson(json);

@override final  int unmatchedCount;
@override final  int matchedCount;
@override final  int createdCount;
@override final  int ignoredCount;
@override final  int splitCount;
@override@NullableAmountConverter() final  String? statementEndingBalance;
@override@AmountConverter() final  String ledgerBalance;
@override@NullableAmountConverter() final  String? difference;

/// Create a copy of ReconciliationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReconciliationSummaryResponseCopyWith<_ReconciliationSummaryResponse> get copyWith => __$ReconciliationSummaryResponseCopyWithImpl<_ReconciliationSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReconciliationSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReconciliationSummaryResponse&&(identical(other.unmatchedCount, unmatchedCount) || other.unmatchedCount == unmatchedCount)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.createdCount, createdCount) || other.createdCount == createdCount)&&(identical(other.ignoredCount, ignoredCount) || other.ignoredCount == ignoredCount)&&(identical(other.splitCount, splitCount) || other.splitCount == splitCount)&&(identical(other.statementEndingBalance, statementEndingBalance) || other.statementEndingBalance == statementEndingBalance)&&(identical(other.ledgerBalance, ledgerBalance) || other.ledgerBalance == ledgerBalance)&&(identical(other.difference, difference) || other.difference == difference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unmatchedCount,matchedCount,createdCount,ignoredCount,splitCount,statementEndingBalance,ledgerBalance,difference);

@override
String toString() {
  return 'ReconciliationSummaryResponse(unmatchedCount: $unmatchedCount, matchedCount: $matchedCount, createdCount: $createdCount, ignoredCount: $ignoredCount, splitCount: $splitCount, statementEndingBalance: $statementEndingBalance, ledgerBalance: $ledgerBalance, difference: $difference)';
}


}

/// @nodoc
abstract mixin class _$ReconciliationSummaryResponseCopyWith<$Res> implements $ReconciliationSummaryResponseCopyWith<$Res> {
  factory _$ReconciliationSummaryResponseCopyWith(_ReconciliationSummaryResponse value, $Res Function(_ReconciliationSummaryResponse) _then) = __$ReconciliationSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 int unmatchedCount, int matchedCount, int createdCount, int ignoredCount, int splitCount,@NullableAmountConverter() String? statementEndingBalance,@AmountConverter() String ledgerBalance,@NullableAmountConverter() String? difference
});




}
/// @nodoc
class __$ReconciliationSummaryResponseCopyWithImpl<$Res>
    implements _$ReconciliationSummaryResponseCopyWith<$Res> {
  __$ReconciliationSummaryResponseCopyWithImpl(this._self, this._then);

  final _ReconciliationSummaryResponse _self;
  final $Res Function(_ReconciliationSummaryResponse) _then;

/// Create a copy of ReconciliationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unmatchedCount = null,Object? matchedCount = null,Object? createdCount = null,Object? ignoredCount = null,Object? splitCount = null,Object? statementEndingBalance = freezed,Object? ledgerBalance = null,Object? difference = freezed,}) {
  return _then(_ReconciliationSummaryResponse(
unmatchedCount: null == unmatchedCount ? _self.unmatchedCount : unmatchedCount // ignore: cast_nullable_to_non_nullable
as int,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,createdCount: null == createdCount ? _self.createdCount : createdCount // ignore: cast_nullable_to_non_nullable
as int,ignoredCount: null == ignoredCount ? _self.ignoredCount : ignoredCount // ignore: cast_nullable_to_non_nullable
as int,splitCount: null == splitCount ? _self.splitCount : splitCount // ignore: cast_nullable_to_non_nullable
as int,statementEndingBalance: freezed == statementEndingBalance ? _self.statementEndingBalance : statementEndingBalance // ignore: cast_nullable_to_non_nullable
as String?,ledgerBalance: null == ledgerBalance ? _self.ledgerBalance : ledgerBalance // ignore: cast_nullable_to_non_nullable
as String,difference: freezed == difference ? _self.difference : difference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AutoMatchResult {

 int get matchedCount; int get skippedCount;
/// Create a copy of AutoMatchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutoMatchResultCopyWith<AutoMatchResult> get copyWith => _$AutoMatchResultCopyWithImpl<AutoMatchResult>(this as AutoMatchResult, _$identity);

  /// Serializes this AutoMatchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoMatchResult&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.skippedCount, skippedCount) || other.skippedCount == skippedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchedCount,skippedCount);

@override
String toString() {
  return 'AutoMatchResult(matchedCount: $matchedCount, skippedCount: $skippedCount)';
}


}

/// @nodoc
abstract mixin class $AutoMatchResultCopyWith<$Res>  {
  factory $AutoMatchResultCopyWith(AutoMatchResult value, $Res Function(AutoMatchResult) _then) = _$AutoMatchResultCopyWithImpl;
@useResult
$Res call({
 int matchedCount, int skippedCount
});




}
/// @nodoc
class _$AutoMatchResultCopyWithImpl<$Res>
    implements $AutoMatchResultCopyWith<$Res> {
  _$AutoMatchResultCopyWithImpl(this._self, this._then);

  final AutoMatchResult _self;
  final $Res Function(AutoMatchResult) _then;

/// Create a copy of AutoMatchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchedCount = null,Object? skippedCount = null,}) {
  return _then(AutoMatchResult(
matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,skippedCount: null == skippedCount ? _self.skippedCount : skippedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AutoMatchResult].
extension AutoMatchResultPatterns on AutoMatchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutoMatchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutoMatchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutoMatchResult value)  $default,){
final _that = this;
switch (_that) {
case _AutoMatchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutoMatchResult value)?  $default,){
final _that = this;
switch (_that) {
case _AutoMatchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int matchedCount,  int skippedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutoMatchResult() when $default != null:
return $default(_that.matchedCount,_that.skippedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int matchedCount,  int skippedCount)  $default,) {final _that = this;
switch (_that) {
case _AutoMatchResult():
return $default(_that.matchedCount,_that.skippedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int matchedCount,  int skippedCount)?  $default,) {final _that = this;
switch (_that) {
case _AutoMatchResult() when $default != null:
return $default(_that.matchedCount,_that.skippedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutoMatchResult implements AutoMatchResult {
  const _AutoMatchResult({required this.matchedCount, required this.skippedCount});
  factory _AutoMatchResult.fromJson(Map<String, dynamic> json) => _$AutoMatchResultFromJson(json);

@override final  int matchedCount;
@override final  int skippedCount;

/// Create a copy of AutoMatchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutoMatchResultCopyWith<_AutoMatchResult> get copyWith => __$AutoMatchResultCopyWithImpl<_AutoMatchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutoMatchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutoMatchResult&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.skippedCount, skippedCount) || other.skippedCount == skippedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchedCount,skippedCount);

@override
String toString() {
  return 'AutoMatchResult(matchedCount: $matchedCount, skippedCount: $skippedCount)';
}


}

/// @nodoc
abstract mixin class _$AutoMatchResultCopyWith<$Res> implements $AutoMatchResultCopyWith<$Res> {
  factory _$AutoMatchResultCopyWith(_AutoMatchResult value, $Res Function(_AutoMatchResult) _then) = __$AutoMatchResultCopyWithImpl;
@override @useResult
$Res call({
 int matchedCount, int skippedCount
});




}
/// @nodoc
class __$AutoMatchResultCopyWithImpl<$Res>
    implements _$AutoMatchResultCopyWith<$Res> {
  __$AutoMatchResultCopyWithImpl(this._self, this._then);

  final _AutoMatchResult _self;
  final $Res Function(_AutoMatchResult) _then;

/// Create a copy of AutoMatchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchedCount = null,Object? skippedCount = null,}) {
  return _then(_AutoMatchResult(
matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,skippedCount: null == skippedCount ? _self.skippedCount : skippedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
