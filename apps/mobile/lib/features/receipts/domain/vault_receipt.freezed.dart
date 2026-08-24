// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VaultReceipt {

 String get id; ReceiptPurpose get purpose; VaultOcrStatus get ocrStatus; String? get merchant; String? get receiptDate;@NullableAmountConverter() String? get totalAmount; String? get folder; List<String> get tags; String? get linkedTransactionId; String? get linkedBillId; String get imageUrl;/// Server-computed, same threshold as the Bagilah scan flow's
/// `ReceiptScan.needsReview` — true when OCR confidence on this receipt
/// is genuinely low.
 bool get needsReview;
/// Create a copy of VaultReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaultReceiptCopyWith<VaultReceipt> get copyWith => _$VaultReceiptCopyWithImpl<VaultReceipt>(this as VaultReceipt, _$identity);

  /// Serializes this VaultReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaultReceipt&&(identical(other.id, id) || other.id == id)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.ocrStatus, ocrStatus) || other.ocrStatus == ocrStatus)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.receiptDate, receiptDate) || other.receiptDate == receiptDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.folder, folder) || other.folder == folder)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.linkedTransactionId, linkedTransactionId) || other.linkedTransactionId == linkedTransactionId)&&(identical(other.linkedBillId, linkedBillId) || other.linkedBillId == linkedBillId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.needsReview, needsReview) || other.needsReview == needsReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purpose,ocrStatus,merchant,receiptDate,totalAmount,folder,const DeepCollectionEquality().hash(tags),linkedTransactionId,linkedBillId,imageUrl,needsReview);

@override
String toString() {
  return 'VaultReceipt(id: $id, purpose: $purpose, ocrStatus: $ocrStatus, merchant: $merchant, receiptDate: $receiptDate, totalAmount: $totalAmount, folder: $folder, tags: $tags, linkedTransactionId: $linkedTransactionId, linkedBillId: $linkedBillId, imageUrl: $imageUrl, needsReview: $needsReview)';
}


}

/// @nodoc
abstract mixin class $VaultReceiptCopyWith<$Res>  {
  factory $VaultReceiptCopyWith(VaultReceipt value, $Res Function(VaultReceipt) _then) = _$VaultReceiptCopyWithImpl;
@useResult
$Res call({
 String id, ReceiptPurpose purpose, VaultOcrStatus ocrStatus, String? merchant, String? receiptDate,@NullableAmountConverter() String? totalAmount, String? folder, List<String> tags, String? linkedTransactionId, String? linkedBillId, String imageUrl, bool needsReview
});




}
/// @nodoc
class _$VaultReceiptCopyWithImpl<$Res>
    implements $VaultReceiptCopyWith<$Res> {
  _$VaultReceiptCopyWithImpl(this._self, this._then);

  final VaultReceipt _self;
  final $Res Function(VaultReceipt) _then;

/// Create a copy of VaultReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? purpose = null,Object? ocrStatus = null,Object? merchant = freezed,Object? receiptDate = freezed,Object? totalAmount = freezed,Object? folder = freezed,Object? tags = null,Object? linkedTransactionId = freezed,Object? linkedBillId = freezed,Object? imageUrl = null,Object? needsReview = null,}) {
  return _then(VaultReceipt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ReceiptPurpose,ocrStatus: null == ocrStatus ? _self.ocrStatus : ocrStatus // ignore: cast_nullable_to_non_nullable
as VaultOcrStatus,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptDate: freezed == receiptDate ? _self.receiptDate : receiptDate // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,linkedTransactionId: freezed == linkedTransactionId ? _self.linkedTransactionId : linkedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,linkedBillId: freezed == linkedBillId ? _self.linkedBillId : linkedBillId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,needsReview: null == needsReview ? _self.needsReview : needsReview // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VaultReceipt].
extension VaultReceiptPatterns on VaultReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaultReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaultReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaultReceipt value)  $default,){
final _that = this;
switch (_that) {
case _VaultReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaultReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _VaultReceipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ReceiptPurpose purpose,  VaultOcrStatus ocrStatus,  String? merchant,  String? receiptDate, @NullableAmountConverter()  String? totalAmount,  String? folder,  List<String> tags,  String? linkedTransactionId,  String? linkedBillId,  String imageUrl,  bool needsReview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaultReceipt() when $default != null:
return $default(_that.id,_that.purpose,_that.ocrStatus,_that.merchant,_that.receiptDate,_that.totalAmount,_that.folder,_that.tags,_that.linkedTransactionId,_that.linkedBillId,_that.imageUrl,_that.needsReview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ReceiptPurpose purpose,  VaultOcrStatus ocrStatus,  String? merchant,  String? receiptDate, @NullableAmountConverter()  String? totalAmount,  String? folder,  List<String> tags,  String? linkedTransactionId,  String? linkedBillId,  String imageUrl,  bool needsReview)  $default,) {final _that = this;
switch (_that) {
case _VaultReceipt():
return $default(_that.id,_that.purpose,_that.ocrStatus,_that.merchant,_that.receiptDate,_that.totalAmount,_that.folder,_that.tags,_that.linkedTransactionId,_that.linkedBillId,_that.imageUrl,_that.needsReview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ReceiptPurpose purpose,  VaultOcrStatus ocrStatus,  String? merchant,  String? receiptDate, @NullableAmountConverter()  String? totalAmount,  String? folder,  List<String> tags,  String? linkedTransactionId,  String? linkedBillId,  String imageUrl,  bool needsReview)?  $default,) {final _that = this;
switch (_that) {
case _VaultReceipt() when $default != null:
return $default(_that.id,_that.purpose,_that.ocrStatus,_that.merchant,_that.receiptDate,_that.totalAmount,_that.folder,_that.tags,_that.linkedTransactionId,_that.linkedBillId,_that.imageUrl,_that.needsReview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaultReceipt implements VaultReceipt {
  const _VaultReceipt({required this.id, required this.purpose, required this.ocrStatus, this.merchant, this.receiptDate, @NullableAmountConverter() this.totalAmount, this.folder, required  List<String> tags, this.linkedTransactionId, this.linkedBillId, required this.imageUrl, this.needsReview = false}): _tags = tags;
  factory _VaultReceipt.fromJson(Map<String, dynamic> json) => _$VaultReceiptFromJson(json);

@override final  String id;
@override final  ReceiptPurpose purpose;
@override final  VaultOcrStatus ocrStatus;
@override final  String? merchant;
@override final  String? receiptDate;
@override@NullableAmountConverter() final  String? totalAmount;
@override final  String? folder;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? linkedTransactionId;
@override final  String? linkedBillId;
@override final  String imageUrl;
/// Server-computed, same threshold as the Bagilah scan flow's
/// `ReceiptScan.needsReview` — true when OCR confidence on this receipt
/// is genuinely low.
@override@JsonKey() final  bool needsReview;

/// Create a copy of VaultReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaultReceiptCopyWith<_VaultReceipt> get copyWith => __$VaultReceiptCopyWithImpl<_VaultReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaultReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaultReceipt&&(identical(other.id, id) || other.id == id)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.ocrStatus, ocrStatus) || other.ocrStatus == ocrStatus)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.receiptDate, receiptDate) || other.receiptDate == receiptDate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.folder, folder) || other.folder == folder)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.linkedTransactionId, linkedTransactionId) || other.linkedTransactionId == linkedTransactionId)&&(identical(other.linkedBillId, linkedBillId) || other.linkedBillId == linkedBillId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.needsReview, needsReview) || other.needsReview == needsReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purpose,ocrStatus,merchant,receiptDate,totalAmount,folder,const DeepCollectionEquality().hash(_tags),linkedTransactionId,linkedBillId,imageUrl,needsReview);

@override
String toString() {
  return 'VaultReceipt(id: $id, purpose: $purpose, ocrStatus: $ocrStatus, merchant: $merchant, receiptDate: $receiptDate, totalAmount: $totalAmount, folder: $folder, tags: $tags, linkedTransactionId: $linkedTransactionId, linkedBillId: $linkedBillId, imageUrl: $imageUrl, needsReview: $needsReview)';
}


}

/// @nodoc
abstract mixin class _$VaultReceiptCopyWith<$Res> implements $VaultReceiptCopyWith<$Res> {
  factory _$VaultReceiptCopyWith(_VaultReceipt value, $Res Function(_VaultReceipt) _then) = __$VaultReceiptCopyWithImpl;
@override @useResult
$Res call({
 String id, ReceiptPurpose purpose, VaultOcrStatus ocrStatus, String? merchant, String? receiptDate,@NullableAmountConverter() String? totalAmount, String? folder, List<String> tags, String? linkedTransactionId, String? linkedBillId, String imageUrl, bool needsReview
});




}
/// @nodoc
class __$VaultReceiptCopyWithImpl<$Res>
    implements _$VaultReceiptCopyWith<$Res> {
  __$VaultReceiptCopyWithImpl(this._self, this._then);

  final _VaultReceipt _self;
  final $Res Function(_VaultReceipt) _then;

/// Create a copy of VaultReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? purpose = null,Object? ocrStatus = null,Object? merchant = freezed,Object? receiptDate = freezed,Object? totalAmount = freezed,Object? folder = freezed,Object? tags = null,Object? linkedTransactionId = freezed,Object? linkedBillId = freezed,Object? imageUrl = null,Object? needsReview = null,}) {
  return _then(_VaultReceipt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as ReceiptPurpose,ocrStatus: null == ocrStatus ? _self.ocrStatus : ocrStatus // ignore: cast_nullable_to_non_nullable
as VaultOcrStatus,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,receiptDate: freezed == receiptDate ? _self.receiptDate : receiptDate // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,linkedTransactionId: freezed == linkedTransactionId ? _self.linkedTransactionId : linkedTransactionId // ignore: cast_nullable_to_non_nullable
as String?,linkedBillId: freezed == linkedBillId ? _self.linkedBillId : linkedBillId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,needsReview: null == needsReview ? _self.needsReview : needsReview // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ReceiptMatchSuggestion {

 String get transactionId; String get occurredOn; String? get merchant;@AmountConverter() String get amount; ReceiptMatchConfidence get confidence;
/// Create a copy of ReceiptMatchSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptMatchSuggestionCopyWith<ReceiptMatchSuggestion> get copyWith => _$ReceiptMatchSuggestionCopyWithImpl<ReceiptMatchSuggestion>(this as ReceiptMatchSuggestion, _$identity);

  /// Serializes this ReceiptMatchSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptMatchSuggestion&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionId,occurredOn,merchant,amount,confidence);

@override
String toString() {
  return 'ReceiptMatchSuggestion(transactionId: $transactionId, occurredOn: $occurredOn, merchant: $merchant, amount: $amount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $ReceiptMatchSuggestionCopyWith<$Res>  {
  factory $ReceiptMatchSuggestionCopyWith(ReceiptMatchSuggestion value, $Res Function(ReceiptMatchSuggestion) _then) = _$ReceiptMatchSuggestionCopyWithImpl;
@useResult
$Res call({
 String transactionId, String occurredOn, String? merchant,@AmountConverter() String amount, ReceiptMatchConfidence confidence
});




}
/// @nodoc
class _$ReceiptMatchSuggestionCopyWithImpl<$Res>
    implements $ReceiptMatchSuggestionCopyWith<$Res> {
  _$ReceiptMatchSuggestionCopyWithImpl(this._self, this._then);

  final ReceiptMatchSuggestion _self;
  final $Res Function(ReceiptMatchSuggestion) _then;

/// Create a copy of ReceiptMatchSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? occurredOn = null,Object? merchant = freezed,Object? amount = null,Object? confidence = null,}) {
  return _then(ReceiptMatchSuggestion(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ReceiptMatchConfidence,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptMatchSuggestion].
extension ReceiptMatchSuggestionPatterns on ReceiptMatchSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptMatchSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptMatchSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptMatchSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptMatchSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptMatchSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptMatchSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transactionId,  String occurredOn,  String? merchant, @AmountConverter()  String amount,  ReceiptMatchConfidence confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptMatchSuggestion() when $default != null:
return $default(_that.transactionId,_that.occurredOn,_that.merchant,_that.amount,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transactionId,  String occurredOn,  String? merchant, @AmountConverter()  String amount,  ReceiptMatchConfidence confidence)  $default,) {final _that = this;
switch (_that) {
case _ReceiptMatchSuggestion():
return $default(_that.transactionId,_that.occurredOn,_that.merchant,_that.amount,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transactionId,  String occurredOn,  String? merchant, @AmountConverter()  String amount,  ReceiptMatchConfidence confidence)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptMatchSuggestion() when $default != null:
return $default(_that.transactionId,_that.occurredOn,_that.merchant,_that.amount,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptMatchSuggestion implements ReceiptMatchSuggestion {
  const _ReceiptMatchSuggestion({required this.transactionId, required this.occurredOn, this.merchant, @AmountConverter() required this.amount, required this.confidence});
  factory _ReceiptMatchSuggestion.fromJson(Map<String, dynamic> json) => _$ReceiptMatchSuggestionFromJson(json);

@override final  String transactionId;
@override final  String occurredOn;
@override final  String? merchant;
@override@AmountConverter() final  String amount;
@override final  ReceiptMatchConfidence confidence;

/// Create a copy of ReceiptMatchSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptMatchSuggestionCopyWith<_ReceiptMatchSuggestion> get copyWith => __$ReceiptMatchSuggestionCopyWithImpl<_ReceiptMatchSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptMatchSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptMatchSuggestion&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionId,occurredOn,merchant,amount,confidence);

@override
String toString() {
  return 'ReceiptMatchSuggestion(transactionId: $transactionId, occurredOn: $occurredOn, merchant: $merchant, amount: $amount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$ReceiptMatchSuggestionCopyWith<$Res> implements $ReceiptMatchSuggestionCopyWith<$Res> {
  factory _$ReceiptMatchSuggestionCopyWith(_ReceiptMatchSuggestion value, $Res Function(_ReceiptMatchSuggestion) _then) = __$ReceiptMatchSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String transactionId, String occurredOn, String? merchant,@AmountConverter() String amount, ReceiptMatchConfidence confidence
});




}
/// @nodoc
class __$ReceiptMatchSuggestionCopyWithImpl<$Res>
    implements _$ReceiptMatchSuggestionCopyWith<$Res> {
  __$ReceiptMatchSuggestionCopyWithImpl(this._self, this._then);

  final _ReceiptMatchSuggestion _self;
  final $Res Function(_ReceiptMatchSuggestion) _then;

/// Create a copy of ReceiptMatchSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? occurredOn = null,Object? merchant = freezed,Object? amount = null,Object? confidence = null,}) {
  return _then(_ReceiptMatchSuggestion(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ReceiptMatchConfidence,
  ));
}


}

// dart format on
