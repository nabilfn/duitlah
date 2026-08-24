// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionCandidate {

 String get id; CandidateSourceType get sourceType;@AmountConverter() String get detectedAmount; String get detectedCurrency; String? get detectedMerchant; String get detectedDate; TransactionDirection get detectedDirection; String? get suggestedAccountId; String? get suggestedCategoryId;@AmountConverter() String get confidence; CandidateStatus get status; String? get duplicateOfTransactionId;@NullableAmountConverter() String? get duplicateConfidence; String? get resultingTransactionId;
/// Create a copy of TransactionCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCandidateCopyWith<TransactionCandidate> get copyWith => _$TransactionCandidateCopyWithImpl<TransactionCandidate>(this as TransactionCandidate, _$identity);

  /// Serializes this TransactionCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.detectedAmount, detectedAmount) || other.detectedAmount == detectedAmount)&&(identical(other.detectedCurrency, detectedCurrency) || other.detectedCurrency == detectedCurrency)&&(identical(other.detectedMerchant, detectedMerchant) || other.detectedMerchant == detectedMerchant)&&(identical(other.detectedDate, detectedDate) || other.detectedDate == detectedDate)&&(identical(other.detectedDirection, detectedDirection) || other.detectedDirection == detectedDirection)&&(identical(other.suggestedAccountId, suggestedAccountId) || other.suggestedAccountId == suggestedAccountId)&&(identical(other.suggestedCategoryId, suggestedCategoryId) || other.suggestedCategoryId == suggestedCategoryId)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.status, status) || other.status == status)&&(identical(other.duplicateOfTransactionId, duplicateOfTransactionId) || other.duplicateOfTransactionId == duplicateOfTransactionId)&&(identical(other.duplicateConfidence, duplicateConfidence) || other.duplicateConfidence == duplicateConfidence)&&(identical(other.resultingTransactionId, resultingTransactionId) || other.resultingTransactionId == resultingTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceType,detectedAmount,detectedCurrency,detectedMerchant,detectedDate,detectedDirection,suggestedAccountId,suggestedCategoryId,confidence,status,duplicateOfTransactionId,duplicateConfidence,resultingTransactionId);

@override
String toString() {
  return 'TransactionCandidate(id: $id, sourceType: $sourceType, detectedAmount: $detectedAmount, detectedCurrency: $detectedCurrency, detectedMerchant: $detectedMerchant, detectedDate: $detectedDate, detectedDirection: $detectedDirection, suggestedAccountId: $suggestedAccountId, suggestedCategoryId: $suggestedCategoryId, confidence: $confidence, status: $status, duplicateOfTransactionId: $duplicateOfTransactionId, duplicateConfidence: $duplicateConfidence, resultingTransactionId: $resultingTransactionId)';
}


}

/// @nodoc
abstract mixin class $TransactionCandidateCopyWith<$Res>  {
  factory $TransactionCandidateCopyWith(TransactionCandidate value, $Res Function(TransactionCandidate) _then) = _$TransactionCandidateCopyWithImpl;
@useResult
$Res call({
 String id, CandidateSourceType sourceType,@AmountConverter() String detectedAmount, String detectedCurrency, String? detectedMerchant, String detectedDate, TransactionDirection detectedDirection, String? suggestedAccountId, String? suggestedCategoryId,@AmountConverter() String confidence, CandidateStatus status, String? duplicateOfTransactionId,@NullableAmountConverter() String? duplicateConfidence, String? resultingTransactionId
});




}
/// @nodoc
class _$TransactionCandidateCopyWithImpl<$Res>
    implements $TransactionCandidateCopyWith<$Res> {
  _$TransactionCandidateCopyWithImpl(this._self, this._then);

  final TransactionCandidate _self;
  final $Res Function(TransactionCandidate) _then;

/// Create a copy of TransactionCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceType = null,Object? detectedAmount = null,Object? detectedCurrency = null,Object? detectedMerchant = freezed,Object? detectedDate = null,Object? detectedDirection = null,Object? suggestedAccountId = freezed,Object? suggestedCategoryId = freezed,Object? confidence = null,Object? status = null,Object? duplicateOfTransactionId = freezed,Object? duplicateConfidence = freezed,Object? resultingTransactionId = freezed,}) {
  return _then(TransactionCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as CandidateSourceType,detectedAmount: null == detectedAmount ? _self.detectedAmount : detectedAmount // ignore: cast_nullable_to_non_nullable
as String,detectedCurrency: null == detectedCurrency ? _self.detectedCurrency : detectedCurrency // ignore: cast_nullable_to_non_nullable
as String,detectedMerchant: freezed == detectedMerchant ? _self.detectedMerchant : detectedMerchant // ignore: cast_nullable_to_non_nullable
as String?,detectedDate: null == detectedDate ? _self.detectedDate : detectedDate // ignore: cast_nullable_to_non_nullable
as String,detectedDirection: null == detectedDirection ? _self.detectedDirection : detectedDirection // ignore: cast_nullable_to_non_nullable
as TransactionDirection,suggestedAccountId: freezed == suggestedAccountId ? _self.suggestedAccountId : suggestedAccountId // ignore: cast_nullable_to_non_nullable
as String?,suggestedCategoryId: freezed == suggestedCategoryId ? _self.suggestedCategoryId : suggestedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CandidateStatus,duplicateOfTransactionId: freezed == duplicateOfTransactionId ? _self.duplicateOfTransactionId : duplicateOfTransactionId // ignore: cast_nullable_to_non_nullable
as String?,duplicateConfidence: freezed == duplicateConfidence ? _self.duplicateConfidence : duplicateConfidence // ignore: cast_nullable_to_non_nullable
as String?,resultingTransactionId: freezed == resultingTransactionId ? _self.resultingTransactionId : resultingTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionCandidate].
extension TransactionCandidatePatterns on TransactionCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionCandidate value)  $default,){
final _that = this;
switch (_that) {
case _TransactionCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CandidateSourceType sourceType, @AmountConverter()  String detectedAmount,  String detectedCurrency,  String? detectedMerchant,  String detectedDate,  TransactionDirection detectedDirection,  String? suggestedAccountId,  String? suggestedCategoryId, @AmountConverter()  String confidence,  CandidateStatus status,  String? duplicateOfTransactionId, @NullableAmountConverter()  String? duplicateConfidence,  String? resultingTransactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionCandidate() when $default != null:
return $default(_that.id,_that.sourceType,_that.detectedAmount,_that.detectedCurrency,_that.detectedMerchant,_that.detectedDate,_that.detectedDirection,_that.suggestedAccountId,_that.suggestedCategoryId,_that.confidence,_that.status,_that.duplicateOfTransactionId,_that.duplicateConfidence,_that.resultingTransactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CandidateSourceType sourceType, @AmountConverter()  String detectedAmount,  String detectedCurrency,  String? detectedMerchant,  String detectedDate,  TransactionDirection detectedDirection,  String? suggestedAccountId,  String? suggestedCategoryId, @AmountConverter()  String confidence,  CandidateStatus status,  String? duplicateOfTransactionId, @NullableAmountConverter()  String? duplicateConfidence,  String? resultingTransactionId)  $default,) {final _that = this;
switch (_that) {
case _TransactionCandidate():
return $default(_that.id,_that.sourceType,_that.detectedAmount,_that.detectedCurrency,_that.detectedMerchant,_that.detectedDate,_that.detectedDirection,_that.suggestedAccountId,_that.suggestedCategoryId,_that.confidence,_that.status,_that.duplicateOfTransactionId,_that.duplicateConfidence,_that.resultingTransactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CandidateSourceType sourceType, @AmountConverter()  String detectedAmount,  String detectedCurrency,  String? detectedMerchant,  String detectedDate,  TransactionDirection detectedDirection,  String? suggestedAccountId,  String? suggestedCategoryId, @AmountConverter()  String confidence,  CandidateStatus status,  String? duplicateOfTransactionId, @NullableAmountConverter()  String? duplicateConfidence,  String? resultingTransactionId)?  $default,) {final _that = this;
switch (_that) {
case _TransactionCandidate() when $default != null:
return $default(_that.id,_that.sourceType,_that.detectedAmount,_that.detectedCurrency,_that.detectedMerchant,_that.detectedDate,_that.detectedDirection,_that.suggestedAccountId,_that.suggestedCategoryId,_that.confidence,_that.status,_that.duplicateOfTransactionId,_that.duplicateConfidence,_that.resultingTransactionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionCandidate implements TransactionCandidate {
  const _TransactionCandidate({required this.id, required this.sourceType, @AmountConverter() required this.detectedAmount, required this.detectedCurrency, this.detectedMerchant, required this.detectedDate, required this.detectedDirection, this.suggestedAccountId, this.suggestedCategoryId, @AmountConverter() required this.confidence, required this.status, this.duplicateOfTransactionId, @NullableAmountConverter() this.duplicateConfidence, this.resultingTransactionId});
  factory _TransactionCandidate.fromJson(Map<String, dynamic> json) => _$TransactionCandidateFromJson(json);

@override final  String id;
@override final  CandidateSourceType sourceType;
@override@AmountConverter() final  String detectedAmount;
@override final  String detectedCurrency;
@override final  String? detectedMerchant;
@override final  String detectedDate;
@override final  TransactionDirection detectedDirection;
@override final  String? suggestedAccountId;
@override final  String? suggestedCategoryId;
@override@AmountConverter() final  String confidence;
@override final  CandidateStatus status;
@override final  String? duplicateOfTransactionId;
@override@NullableAmountConverter() final  String? duplicateConfidence;
@override final  String? resultingTransactionId;

/// Create a copy of TransactionCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCandidateCopyWith<_TransactionCandidate> get copyWith => __$TransactionCandidateCopyWithImpl<_TransactionCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.detectedAmount, detectedAmount) || other.detectedAmount == detectedAmount)&&(identical(other.detectedCurrency, detectedCurrency) || other.detectedCurrency == detectedCurrency)&&(identical(other.detectedMerchant, detectedMerchant) || other.detectedMerchant == detectedMerchant)&&(identical(other.detectedDate, detectedDate) || other.detectedDate == detectedDate)&&(identical(other.detectedDirection, detectedDirection) || other.detectedDirection == detectedDirection)&&(identical(other.suggestedAccountId, suggestedAccountId) || other.suggestedAccountId == suggestedAccountId)&&(identical(other.suggestedCategoryId, suggestedCategoryId) || other.suggestedCategoryId == suggestedCategoryId)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.status, status) || other.status == status)&&(identical(other.duplicateOfTransactionId, duplicateOfTransactionId) || other.duplicateOfTransactionId == duplicateOfTransactionId)&&(identical(other.duplicateConfidence, duplicateConfidence) || other.duplicateConfidence == duplicateConfidence)&&(identical(other.resultingTransactionId, resultingTransactionId) || other.resultingTransactionId == resultingTransactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceType,detectedAmount,detectedCurrency,detectedMerchant,detectedDate,detectedDirection,suggestedAccountId,suggestedCategoryId,confidence,status,duplicateOfTransactionId,duplicateConfidence,resultingTransactionId);

@override
String toString() {
  return 'TransactionCandidate(id: $id, sourceType: $sourceType, detectedAmount: $detectedAmount, detectedCurrency: $detectedCurrency, detectedMerchant: $detectedMerchant, detectedDate: $detectedDate, detectedDirection: $detectedDirection, suggestedAccountId: $suggestedAccountId, suggestedCategoryId: $suggestedCategoryId, confidence: $confidence, status: $status, duplicateOfTransactionId: $duplicateOfTransactionId, duplicateConfidence: $duplicateConfidence, resultingTransactionId: $resultingTransactionId)';
}


}

/// @nodoc
abstract mixin class _$TransactionCandidateCopyWith<$Res> implements $TransactionCandidateCopyWith<$Res> {
  factory _$TransactionCandidateCopyWith(_TransactionCandidate value, $Res Function(_TransactionCandidate) _then) = __$TransactionCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, CandidateSourceType sourceType,@AmountConverter() String detectedAmount, String detectedCurrency, String? detectedMerchant, String detectedDate, TransactionDirection detectedDirection, String? suggestedAccountId, String? suggestedCategoryId,@AmountConverter() String confidence, CandidateStatus status, String? duplicateOfTransactionId,@NullableAmountConverter() String? duplicateConfidence, String? resultingTransactionId
});




}
/// @nodoc
class __$TransactionCandidateCopyWithImpl<$Res>
    implements _$TransactionCandidateCopyWith<$Res> {
  __$TransactionCandidateCopyWithImpl(this._self, this._then);

  final _TransactionCandidate _self;
  final $Res Function(_TransactionCandidate) _then;

/// Create a copy of TransactionCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceType = null,Object? detectedAmount = null,Object? detectedCurrency = null,Object? detectedMerchant = freezed,Object? detectedDate = null,Object? detectedDirection = null,Object? suggestedAccountId = freezed,Object? suggestedCategoryId = freezed,Object? confidence = null,Object? status = null,Object? duplicateOfTransactionId = freezed,Object? duplicateConfidence = freezed,Object? resultingTransactionId = freezed,}) {
  return _then(_TransactionCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as CandidateSourceType,detectedAmount: null == detectedAmount ? _self.detectedAmount : detectedAmount // ignore: cast_nullable_to_non_nullable
as String,detectedCurrency: null == detectedCurrency ? _self.detectedCurrency : detectedCurrency // ignore: cast_nullable_to_non_nullable
as String,detectedMerchant: freezed == detectedMerchant ? _self.detectedMerchant : detectedMerchant // ignore: cast_nullable_to_non_nullable
as String?,detectedDate: null == detectedDate ? _self.detectedDate : detectedDate // ignore: cast_nullable_to_non_nullable
as String,detectedDirection: null == detectedDirection ? _self.detectedDirection : detectedDirection // ignore: cast_nullable_to_non_nullable
as TransactionDirection,suggestedAccountId: freezed == suggestedAccountId ? _self.suggestedAccountId : suggestedAccountId // ignore: cast_nullable_to_non_nullable
as String?,suggestedCategoryId: freezed == suggestedCategoryId ? _self.suggestedCategoryId : suggestedCategoryId // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CandidateStatus,duplicateOfTransactionId: freezed == duplicateOfTransactionId ? _self.duplicateOfTransactionId : duplicateOfTransactionId // ignore: cast_nullable_to_non_nullable
as String?,duplicateConfidence: freezed == duplicateConfidence ? _self.duplicateConfidence : duplicateConfidence // ignore: cast_nullable_to_non_nullable
as String?,resultingTransactionId: freezed == resultingTransactionId ? _self.resultingTransactionId : resultingTransactionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StatementImport {

 String get id; String get accountId; StatementProvider get provider; String get originalFilename; StatementImportStatus get status; int get rowCount; String? get errorMessage;
/// Create a copy of StatementImport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatementImportCopyWith<StatementImport> get copyWith => _$StatementImportCopyWithImpl<StatementImport>(this as StatementImport, _$identity);

  /// Serializes this StatementImport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatementImport&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.status, status) || other.status == status)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,provider,originalFilename,status,rowCount,errorMessage);

@override
String toString() {
  return 'StatementImport(id: $id, accountId: $accountId, provider: $provider, originalFilename: $originalFilename, status: $status, rowCount: $rowCount, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $StatementImportCopyWith<$Res>  {
  factory $StatementImportCopyWith(StatementImport value, $Res Function(StatementImport) _then) = _$StatementImportCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, StatementProvider provider, String originalFilename, StatementImportStatus status, int rowCount, String? errorMessage
});




}
/// @nodoc
class _$StatementImportCopyWithImpl<$Res>
    implements $StatementImportCopyWith<$Res> {
  _$StatementImportCopyWithImpl(this._self, this._then);

  final StatementImport _self;
  final $Res Function(StatementImport) _then;

/// Create a copy of StatementImport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? provider = null,Object? originalFilename = null,Object? status = null,Object? rowCount = null,Object? errorMessage = freezed,}) {
  return _then(StatementImport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as StatementProvider,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StatementImportStatus,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatementImport].
extension StatementImportPatterns on StatementImport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatementImport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatementImport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatementImport value)  $default,){
final _that = this;
switch (_that) {
case _StatementImport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatementImport value)?  $default,){
final _that = this;
switch (_that) {
case _StatementImport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String accountId,  StatementProvider provider,  String originalFilename,  StatementImportStatus status,  int rowCount,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatementImport() when $default != null:
return $default(_that.id,_that.accountId,_that.provider,_that.originalFilename,_that.status,_that.rowCount,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String accountId,  StatementProvider provider,  String originalFilename,  StatementImportStatus status,  int rowCount,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _StatementImport():
return $default(_that.id,_that.accountId,_that.provider,_that.originalFilename,_that.status,_that.rowCount,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String accountId,  StatementProvider provider,  String originalFilename,  StatementImportStatus status,  int rowCount,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _StatementImport() when $default != null:
return $default(_that.id,_that.accountId,_that.provider,_that.originalFilename,_that.status,_that.rowCount,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatementImport implements StatementImport {
  const _StatementImport({required this.id, required this.accountId, required this.provider, required this.originalFilename, required this.status, required this.rowCount, this.errorMessage});
  factory _StatementImport.fromJson(Map<String, dynamic> json) => _$StatementImportFromJson(json);

@override final  String id;
@override final  String accountId;
@override final  StatementProvider provider;
@override final  String originalFilename;
@override final  StatementImportStatus status;
@override final  int rowCount;
@override final  String? errorMessage;

/// Create a copy of StatementImport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatementImportCopyWith<_StatementImport> get copyWith => __$StatementImportCopyWithImpl<_StatementImport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatementImportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatementImport&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.status, status) || other.status == status)&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,provider,originalFilename,status,rowCount,errorMessage);

@override
String toString() {
  return 'StatementImport(id: $id, accountId: $accountId, provider: $provider, originalFilename: $originalFilename, status: $status, rowCount: $rowCount, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$StatementImportCopyWith<$Res> implements $StatementImportCopyWith<$Res> {
  factory _$StatementImportCopyWith(_StatementImport value, $Res Function(_StatementImport) _then) = __$StatementImportCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, StatementProvider provider, String originalFilename, StatementImportStatus status, int rowCount, String? errorMessage
});




}
/// @nodoc
class __$StatementImportCopyWithImpl<$Res>
    implements _$StatementImportCopyWith<$Res> {
  __$StatementImportCopyWithImpl(this._self, this._then);

  final _StatementImport _self;
  final $Res Function(_StatementImport) _then;

/// Create a copy of StatementImport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? provider = null,Object? originalFilename = null,Object? status = null,Object? rowCount = null,Object? errorMessage = freezed,}) {
  return _then(_StatementImport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as StatementProvider,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StatementImportStatus,rowCount: null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
