// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneralLedgerLine {

 String get entryDate; String get journalEntryId; String? get description; LedgerDirection get direction;@AmountConverter() String get amount;@AmountConverter() String get runningBalance;
/// Create a copy of GeneralLedgerLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralLedgerLineCopyWith<GeneralLedgerLine> get copyWith => _$GeneralLedgerLineCopyWithImpl<GeneralLedgerLine>(this as GeneralLedgerLine, _$identity);

  /// Serializes this GeneralLedgerLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneralLedgerLine&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.journalEntryId, journalEntryId) || other.journalEntryId == journalEntryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryDate,journalEntryId,description,direction,amount,runningBalance);

@override
String toString() {
  return 'GeneralLedgerLine(entryDate: $entryDate, journalEntryId: $journalEntryId, description: $description, direction: $direction, amount: $amount, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class $GeneralLedgerLineCopyWith<$Res>  {
  factory $GeneralLedgerLineCopyWith(GeneralLedgerLine value, $Res Function(GeneralLedgerLine) _then) = _$GeneralLedgerLineCopyWithImpl;
@useResult
$Res call({
 String entryDate, String journalEntryId, String? description, LedgerDirection direction,@AmountConverter() String amount,@AmountConverter() String runningBalance
});




}
/// @nodoc
class _$GeneralLedgerLineCopyWithImpl<$Res>
    implements $GeneralLedgerLineCopyWith<$Res> {
  _$GeneralLedgerLineCopyWithImpl(this._self, this._then);

  final GeneralLedgerLine _self;
  final $Res Function(GeneralLedgerLine) _then;

/// Create a copy of GeneralLedgerLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryDate = null,Object? journalEntryId = null,Object? description = freezed,Object? direction = null,Object? amount = null,Object? runningBalance = null,}) {
  return _then(GeneralLedgerLine(
entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,journalEntryId: null == journalEntryId ? _self.journalEntryId : journalEntryId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as LedgerDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneralLedgerLine].
extension GeneralLedgerLinePatterns on GeneralLedgerLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneralLedgerLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneralLedgerLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneralLedgerLine value)  $default,){
final _that = this;
switch (_that) {
case _GeneralLedgerLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneralLedgerLine value)?  $default,){
final _that = this;
switch (_that) {
case _GeneralLedgerLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entryDate,  String journalEntryId,  String? description,  LedgerDirection direction, @AmountConverter()  String amount, @AmountConverter()  String runningBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneralLedgerLine() when $default != null:
return $default(_that.entryDate,_that.journalEntryId,_that.description,_that.direction,_that.amount,_that.runningBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entryDate,  String journalEntryId,  String? description,  LedgerDirection direction, @AmountConverter()  String amount, @AmountConverter()  String runningBalance)  $default,) {final _that = this;
switch (_that) {
case _GeneralLedgerLine():
return $default(_that.entryDate,_that.journalEntryId,_that.description,_that.direction,_that.amount,_that.runningBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entryDate,  String journalEntryId,  String? description,  LedgerDirection direction, @AmountConverter()  String amount, @AmountConverter()  String runningBalance)?  $default,) {final _that = this;
switch (_that) {
case _GeneralLedgerLine() when $default != null:
return $default(_that.entryDate,_that.journalEntryId,_that.description,_that.direction,_that.amount,_that.runningBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneralLedgerLine implements GeneralLedgerLine {
  const _GeneralLedgerLine({required this.entryDate, required this.journalEntryId, this.description, required this.direction, @AmountConverter() required this.amount, @AmountConverter() required this.runningBalance});
  factory _GeneralLedgerLine.fromJson(Map<String, dynamic> json) => _$GeneralLedgerLineFromJson(json);

@override final  String entryDate;
@override final  String journalEntryId;
@override final  String? description;
@override final  LedgerDirection direction;
@override@AmountConverter() final  String amount;
@override@AmountConverter() final  String runningBalance;

/// Create a copy of GeneralLedgerLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneralLedgerLineCopyWith<_GeneralLedgerLine> get copyWith => __$GeneralLedgerLineCopyWithImpl<_GeneralLedgerLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneralLedgerLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneralLedgerLine&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.journalEntryId, journalEntryId) || other.journalEntryId == journalEntryId)&&(identical(other.description, description) || other.description == description)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryDate,journalEntryId,description,direction,amount,runningBalance);

@override
String toString() {
  return 'GeneralLedgerLine(entryDate: $entryDate, journalEntryId: $journalEntryId, description: $description, direction: $direction, amount: $amount, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class _$GeneralLedgerLineCopyWith<$Res> implements $GeneralLedgerLineCopyWith<$Res> {
  factory _$GeneralLedgerLineCopyWith(_GeneralLedgerLine value, $Res Function(_GeneralLedgerLine) _then) = __$GeneralLedgerLineCopyWithImpl;
@override @useResult
$Res call({
 String entryDate, String journalEntryId, String? description, LedgerDirection direction,@AmountConverter() String amount,@AmountConverter() String runningBalance
});




}
/// @nodoc
class __$GeneralLedgerLineCopyWithImpl<$Res>
    implements _$GeneralLedgerLineCopyWith<$Res> {
  __$GeneralLedgerLineCopyWithImpl(this._self, this._then);

  final _GeneralLedgerLine _self;
  final $Res Function(_GeneralLedgerLine) _then;

/// Create a copy of GeneralLedgerLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryDate = null,Object? journalEntryId = null,Object? description = freezed,Object? direction = null,Object? amount = null,Object? runningBalance = null,}) {
  return _then(_GeneralLedgerLine(
entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,journalEntryId: null == journalEntryId ? _self.journalEntryId : journalEntryId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as LedgerDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GeneralLedgerReport {

 String get accountId; String get accountCode; String get accountName;@AmountConverter() String get openingBalance; List<GeneralLedgerLine> get lines;@AmountConverter() String get closingBalance;
/// Create a copy of GeneralLedgerReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralLedgerReportCopyWith<GeneralLedgerReport> get copyWith => _$GeneralLedgerReportCopyWithImpl<GeneralLedgerReport>(this as GeneralLedgerReport, _$identity);

  /// Serializes this GeneralLedgerReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneralLedgerReport&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.closingBalance, closingBalance) || other.closingBalance == closingBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountCode,accountName,openingBalance,const DeepCollectionEquality().hash(lines),closingBalance);

@override
String toString() {
  return 'GeneralLedgerReport(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, openingBalance: $openingBalance, lines: $lines, closingBalance: $closingBalance)';
}


}

/// @nodoc
abstract mixin class $GeneralLedgerReportCopyWith<$Res>  {
  factory $GeneralLedgerReportCopyWith(GeneralLedgerReport value, $Res Function(GeneralLedgerReport) _then) = _$GeneralLedgerReportCopyWithImpl;
@useResult
$Res call({
 String accountId, String accountCode, String accountName,@AmountConverter() String openingBalance, List<GeneralLedgerLine> lines,@AmountConverter() String closingBalance
});




}
/// @nodoc
class _$GeneralLedgerReportCopyWithImpl<$Res>
    implements $GeneralLedgerReportCopyWith<$Res> {
  _$GeneralLedgerReportCopyWithImpl(this._self, this._then);

  final GeneralLedgerReport _self;
  final $Res Function(GeneralLedgerReport) _then;

/// Create a copy of GeneralLedgerReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? openingBalance = null,Object? lines = null,Object? closingBalance = null,}) {
  return _then(GeneralLedgerReport(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<GeneralLedgerLine>,closingBalance: null == closingBalance ? _self.closingBalance : closingBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneralLedgerReport].
extension GeneralLedgerReportPatterns on GeneralLedgerReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneralLedgerReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneralLedgerReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneralLedgerReport value)  $default,){
final _that = this;
switch (_that) {
case _GeneralLedgerReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneralLedgerReport value)?  $default,){
final _that = this;
switch (_that) {
case _GeneralLedgerReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  String accountCode,  String accountName, @AmountConverter()  String openingBalance,  List<GeneralLedgerLine> lines, @AmountConverter()  String closingBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneralLedgerReport() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.openingBalance,_that.lines,_that.closingBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  String accountCode,  String accountName, @AmountConverter()  String openingBalance,  List<GeneralLedgerLine> lines, @AmountConverter()  String closingBalance)  $default,) {final _that = this;
switch (_that) {
case _GeneralLedgerReport():
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.openingBalance,_that.lines,_that.closingBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  String accountCode,  String accountName, @AmountConverter()  String openingBalance,  List<GeneralLedgerLine> lines, @AmountConverter()  String closingBalance)?  $default,) {final _that = this;
switch (_that) {
case _GeneralLedgerReport() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.openingBalance,_that.lines,_that.closingBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneralLedgerReport implements GeneralLedgerReport {
  const _GeneralLedgerReport({required this.accountId, required this.accountCode, required this.accountName, @AmountConverter() required this.openingBalance, required  List<GeneralLedgerLine> lines, @AmountConverter() required this.closingBalance}): _lines = lines;
  factory _GeneralLedgerReport.fromJson(Map<String, dynamic> json) => _$GeneralLedgerReportFromJson(json);

@override final  String accountId;
@override final  String accountCode;
@override final  String accountName;
@override@AmountConverter() final  String openingBalance;
 final  List<GeneralLedgerLine> _lines;
@override List<GeneralLedgerLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@AmountConverter() final  String closingBalance;

/// Create a copy of GeneralLedgerReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneralLedgerReportCopyWith<_GeneralLedgerReport> get copyWith => __$GeneralLedgerReportCopyWithImpl<_GeneralLedgerReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneralLedgerReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneralLedgerReport&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.closingBalance, closingBalance) || other.closingBalance == closingBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountCode,accountName,openingBalance,const DeepCollectionEquality().hash(_lines),closingBalance);

@override
String toString() {
  return 'GeneralLedgerReport(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, openingBalance: $openingBalance, lines: $lines, closingBalance: $closingBalance)';
}


}

/// @nodoc
abstract mixin class _$GeneralLedgerReportCopyWith<$Res> implements $GeneralLedgerReportCopyWith<$Res> {
  factory _$GeneralLedgerReportCopyWith(_GeneralLedgerReport value, $Res Function(_GeneralLedgerReport) _then) = __$GeneralLedgerReportCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String accountCode, String accountName,@AmountConverter() String openingBalance, List<GeneralLedgerLine> lines,@AmountConverter() String closingBalance
});




}
/// @nodoc
class __$GeneralLedgerReportCopyWithImpl<$Res>
    implements _$GeneralLedgerReportCopyWith<$Res> {
  __$GeneralLedgerReportCopyWithImpl(this._self, this._then);

  final _GeneralLedgerReport _self;
  final $Res Function(_GeneralLedgerReport) _then;

/// Create a copy of GeneralLedgerReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? openingBalance = null,Object? lines = null,Object? closingBalance = null,}) {
  return _then(_GeneralLedgerReport(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<GeneralLedgerLine>,closingBalance: null == closingBalance ? _self.closingBalance : closingBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TrialBalanceLine {

 String get accountId; String get accountCode; String get accountName; LedgerAccountType get type;@AmountConverter() String get debit;@AmountConverter() String get credit;
/// Create a copy of TrialBalanceLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrialBalanceLineCopyWith<TrialBalanceLine> get copyWith => _$TrialBalanceLineCopyWithImpl<TrialBalanceLine>(this as TrialBalanceLine, _$identity);

  /// Serializes this TrialBalanceLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrialBalanceLine&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.type, type) || other.type == type)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountCode,accountName,type,debit,credit);

@override
String toString() {
  return 'TrialBalanceLine(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, type: $type, debit: $debit, credit: $credit)';
}


}

/// @nodoc
abstract mixin class $TrialBalanceLineCopyWith<$Res>  {
  factory $TrialBalanceLineCopyWith(TrialBalanceLine value, $Res Function(TrialBalanceLine) _then) = _$TrialBalanceLineCopyWithImpl;
@useResult
$Res call({
 String accountId, String accountCode, String accountName, LedgerAccountType type,@AmountConverter() String debit,@AmountConverter() String credit
});




}
/// @nodoc
class _$TrialBalanceLineCopyWithImpl<$Res>
    implements $TrialBalanceLineCopyWith<$Res> {
  _$TrialBalanceLineCopyWithImpl(this._self, this._then);

  final TrialBalanceLine _self;
  final $Res Function(TrialBalanceLine) _then;

/// Create a copy of TrialBalanceLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? type = null,Object? debit = null,Object? credit = null,}) {
  return _then(TrialBalanceLine(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LedgerAccountType,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as String,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrialBalanceLine].
extension TrialBalanceLinePatterns on TrialBalanceLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrialBalanceLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrialBalanceLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrialBalanceLine value)  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrialBalanceLine value)?  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  String accountCode,  String accountName,  LedgerAccountType type, @AmountConverter()  String debit, @AmountConverter()  String credit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrialBalanceLine() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.type,_that.debit,_that.credit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  String accountCode,  String accountName,  LedgerAccountType type, @AmountConverter()  String debit, @AmountConverter()  String credit)  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceLine():
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.type,_that.debit,_that.credit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  String accountCode,  String accountName,  LedgerAccountType type, @AmountConverter()  String debit, @AmountConverter()  String credit)?  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceLine() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.type,_that.debit,_that.credit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrialBalanceLine implements TrialBalanceLine {
  const _TrialBalanceLine({required this.accountId, required this.accountCode, required this.accountName, required this.type, @AmountConverter() required this.debit, @AmountConverter() required this.credit});
  factory _TrialBalanceLine.fromJson(Map<String, dynamic> json) => _$TrialBalanceLineFromJson(json);

@override final  String accountId;
@override final  String accountCode;
@override final  String accountName;
@override final  LedgerAccountType type;
@override@AmountConverter() final  String debit;
@override@AmountConverter() final  String credit;

/// Create a copy of TrialBalanceLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrialBalanceLineCopyWith<_TrialBalanceLine> get copyWith => __$TrialBalanceLineCopyWithImpl<_TrialBalanceLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrialBalanceLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrialBalanceLine&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.type, type) || other.type == type)&&(identical(other.debit, debit) || other.debit == debit)&&(identical(other.credit, credit) || other.credit == credit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountCode,accountName,type,debit,credit);

@override
String toString() {
  return 'TrialBalanceLine(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, type: $type, debit: $debit, credit: $credit)';
}


}

/// @nodoc
abstract mixin class _$TrialBalanceLineCopyWith<$Res> implements $TrialBalanceLineCopyWith<$Res> {
  factory _$TrialBalanceLineCopyWith(_TrialBalanceLine value, $Res Function(_TrialBalanceLine) _then) = __$TrialBalanceLineCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String accountCode, String accountName, LedgerAccountType type,@AmountConverter() String debit,@AmountConverter() String credit
});




}
/// @nodoc
class __$TrialBalanceLineCopyWithImpl<$Res>
    implements _$TrialBalanceLineCopyWith<$Res> {
  __$TrialBalanceLineCopyWithImpl(this._self, this._then);

  final _TrialBalanceLine _self;
  final $Res Function(_TrialBalanceLine) _then;

/// Create a copy of TrialBalanceLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? type = null,Object? debit = null,Object? credit = null,}) {
  return _then(_TrialBalanceLine(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LedgerAccountType,debit: null == debit ? _self.debit : debit // ignore: cast_nullable_to_non_nullable
as String,credit: null == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TrialBalanceReport {

 String get asOf; List<TrialBalanceLine> get lines;@AmountConverter() String get totalDebit;@AmountConverter() String get totalCredit;
/// Create a copy of TrialBalanceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrialBalanceReportCopyWith<TrialBalanceReport> get copyWith => _$TrialBalanceReportCopyWithImpl<TrialBalanceReport>(this as TrialBalanceReport, _$identity);

  /// Serializes this TrialBalanceReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrialBalanceReport&&(identical(other.asOf, asOf) || other.asOf == asOf)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asOf,const DeepCollectionEquality().hash(lines),totalDebit,totalCredit);

@override
String toString() {
  return 'TrialBalanceReport(asOf: $asOf, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit)';
}


}

/// @nodoc
abstract mixin class $TrialBalanceReportCopyWith<$Res>  {
  factory $TrialBalanceReportCopyWith(TrialBalanceReport value, $Res Function(TrialBalanceReport) _then) = _$TrialBalanceReportCopyWithImpl;
@useResult
$Res call({
 String asOf, List<TrialBalanceLine> lines,@AmountConverter() String totalDebit,@AmountConverter() String totalCredit
});




}
/// @nodoc
class _$TrialBalanceReportCopyWithImpl<$Res>
    implements $TrialBalanceReportCopyWith<$Res> {
  _$TrialBalanceReportCopyWithImpl(this._self, this._then);

  final TrialBalanceReport _self;
  final $Res Function(TrialBalanceReport) _then;

/// Create a copy of TrialBalanceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asOf = null,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,}) {
  return _then(TrialBalanceReport(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<TrialBalanceLine>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as String,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrialBalanceReport].
extension TrialBalanceReportPatterns on TrialBalanceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrialBalanceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrialBalanceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrialBalanceReport value)  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrialBalanceReport value)?  $default,){
final _that = this;
switch (_that) {
case _TrialBalanceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String asOf,  List<TrialBalanceLine> lines, @AmountConverter()  String totalDebit, @AmountConverter()  String totalCredit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrialBalanceReport() when $default != null:
return $default(_that.asOf,_that.lines,_that.totalDebit,_that.totalCredit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String asOf,  List<TrialBalanceLine> lines, @AmountConverter()  String totalDebit, @AmountConverter()  String totalCredit)  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceReport():
return $default(_that.asOf,_that.lines,_that.totalDebit,_that.totalCredit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String asOf,  List<TrialBalanceLine> lines, @AmountConverter()  String totalDebit, @AmountConverter()  String totalCredit)?  $default,) {final _that = this;
switch (_that) {
case _TrialBalanceReport() when $default != null:
return $default(_that.asOf,_that.lines,_that.totalDebit,_that.totalCredit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrialBalanceReport implements TrialBalanceReport {
  const _TrialBalanceReport({required this.asOf, required  List<TrialBalanceLine> lines, @AmountConverter() required this.totalDebit, @AmountConverter() required this.totalCredit}): _lines = lines;
  factory _TrialBalanceReport.fromJson(Map<String, dynamic> json) => _$TrialBalanceReportFromJson(json);

@override final  String asOf;
 final  List<TrialBalanceLine> _lines;
@override List<TrialBalanceLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@AmountConverter() final  String totalDebit;
@override@AmountConverter() final  String totalCredit;

/// Create a copy of TrialBalanceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrialBalanceReportCopyWith<_TrialBalanceReport> get copyWith => __$TrialBalanceReportCopyWithImpl<_TrialBalanceReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrialBalanceReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrialBalanceReport&&(identical(other.asOf, asOf) || other.asOf == asOf)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asOf,const DeepCollectionEquality().hash(_lines),totalDebit,totalCredit);

@override
String toString() {
  return 'TrialBalanceReport(asOf: $asOf, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit)';
}


}

/// @nodoc
abstract mixin class _$TrialBalanceReportCopyWith<$Res> implements $TrialBalanceReportCopyWith<$Res> {
  factory _$TrialBalanceReportCopyWith(_TrialBalanceReport value, $Res Function(_TrialBalanceReport) _then) = __$TrialBalanceReportCopyWithImpl;
@override @useResult
$Res call({
 String asOf, List<TrialBalanceLine> lines,@AmountConverter() String totalDebit,@AmountConverter() String totalCredit
});




}
/// @nodoc
class __$TrialBalanceReportCopyWithImpl<$Res>
    implements _$TrialBalanceReportCopyWith<$Res> {
  __$TrialBalanceReportCopyWithImpl(this._self, this._then);

  final _TrialBalanceReport _self;
  final $Res Function(_TrialBalanceReport) _then;

/// Create a copy of TrialBalanceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asOf = null,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,}) {
  return _then(_TrialBalanceReport(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<TrialBalanceLine>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as String,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AccountAmountLine {

 String get accountId; String get accountCode; String get accountName;@AmountConverter() String get amount;
/// Create a copy of AccountAmountLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountAmountLineCopyWith<AccountAmountLine> get copyWith => _$AccountAmountLineCopyWithImpl<AccountAmountLine>(this as AccountAmountLine, _$identity);

  /// Serializes this AccountAmountLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountAmountLine&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountCode,accountName,amount);

@override
String toString() {
  return 'AccountAmountLine(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $AccountAmountLineCopyWith<$Res>  {
  factory $AccountAmountLineCopyWith(AccountAmountLine value, $Res Function(AccountAmountLine) _then) = _$AccountAmountLineCopyWithImpl;
@useResult
$Res call({
 String accountId, String accountCode, String accountName,@AmountConverter() String amount
});




}
/// @nodoc
class _$AccountAmountLineCopyWithImpl<$Res>
    implements $AccountAmountLineCopyWith<$Res> {
  _$AccountAmountLineCopyWithImpl(this._self, this._then);

  final AccountAmountLine _self;
  final $Res Function(AccountAmountLine) _then;

/// Create a copy of AccountAmountLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? amount = null,}) {
  return _then(AccountAmountLine(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountAmountLine].
extension AccountAmountLinePatterns on AccountAmountLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountAmountLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountAmountLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountAmountLine value)  $default,){
final _that = this;
switch (_that) {
case _AccountAmountLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountAmountLine value)?  $default,){
final _that = this;
switch (_that) {
case _AccountAmountLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  String accountCode,  String accountName, @AmountConverter()  String amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountAmountLine() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  String accountCode,  String accountName, @AmountConverter()  String amount)  $default,) {final _that = this;
switch (_that) {
case _AccountAmountLine():
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  String accountCode,  String accountName, @AmountConverter()  String amount)?  $default,) {final _that = this;
switch (_that) {
case _AccountAmountLine() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountAmountLine implements AccountAmountLine {
  const _AccountAmountLine({required this.accountId, required this.accountCode, required this.accountName, @AmountConverter() required this.amount});
  factory _AccountAmountLine.fromJson(Map<String, dynamic> json) => _$AccountAmountLineFromJson(json);

@override final  String accountId;
@override final  String accountCode;
@override final  String accountName;
@override@AmountConverter() final  String amount;

/// Create a copy of AccountAmountLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountAmountLineCopyWith<_AccountAmountLine> get copyWith => __$AccountAmountLineCopyWithImpl<_AccountAmountLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountAmountLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountAmountLine&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,accountCode,accountName,amount);

@override
String toString() {
  return 'AccountAmountLine(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$AccountAmountLineCopyWith<$Res> implements $AccountAmountLineCopyWith<$Res> {
  factory _$AccountAmountLineCopyWith(_AccountAmountLine value, $Res Function(_AccountAmountLine) _then) = __$AccountAmountLineCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String accountCode, String accountName,@AmountConverter() String amount
});




}
/// @nodoc
class __$AccountAmountLineCopyWithImpl<$Res>
    implements _$AccountAmountLineCopyWith<$Res> {
  __$AccountAmountLineCopyWithImpl(this._self, this._then);

  final _AccountAmountLine _self;
  final $Res Function(_AccountAmountLine) _then;

/// Create a copy of AccountAmountLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? amount = null,}) {
  return _then(_AccountAmountLine(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$IncomeStatementReport {

 String get from; String get to; List<AccountAmountLine> get revenueLines;@AmountConverter() String get totalRevenue; List<AccountAmountLine> get expenseLines;@AmountConverter() String get totalExpenses;@AmountConverter() String get netIncome;
/// Create a copy of IncomeStatementReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeStatementReportCopyWith<IncomeStatementReport> get copyWith => _$IncomeStatementReportCopyWithImpl<IncomeStatementReport>(this as IncomeStatementReport, _$identity);

  /// Serializes this IncomeStatementReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeStatementReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other.revenueLines, revenueLines)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&const DeepCollectionEquality().equals(other.expenseLines, expenseLines)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.netIncome, netIncome) || other.netIncome == netIncome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,const DeepCollectionEquality().hash(revenueLines),totalRevenue,const DeepCollectionEquality().hash(expenseLines),totalExpenses,netIncome);

@override
String toString() {
  return 'IncomeStatementReport(from: $from, to: $to, revenueLines: $revenueLines, totalRevenue: $totalRevenue, expenseLines: $expenseLines, totalExpenses: $totalExpenses, netIncome: $netIncome)';
}


}

/// @nodoc
abstract mixin class $IncomeStatementReportCopyWith<$Res>  {
  factory $IncomeStatementReportCopyWith(IncomeStatementReport value, $Res Function(IncomeStatementReport) _then) = _$IncomeStatementReportCopyWithImpl;
@useResult
$Res call({
 String from, String to, List<AccountAmountLine> revenueLines,@AmountConverter() String totalRevenue, List<AccountAmountLine> expenseLines,@AmountConverter() String totalExpenses,@AmountConverter() String netIncome
});




}
/// @nodoc
class _$IncomeStatementReportCopyWithImpl<$Res>
    implements $IncomeStatementReportCopyWith<$Res> {
  _$IncomeStatementReportCopyWithImpl(this._self, this._then);

  final IncomeStatementReport _self;
  final $Res Function(IncomeStatementReport) _then;

/// Create a copy of IncomeStatementReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? revenueLines = null,Object? totalRevenue = null,Object? expenseLines = null,Object? totalExpenses = null,Object? netIncome = null,}) {
  return _then(IncomeStatementReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,revenueLines: null == revenueLines ? _self.revenueLines : revenueLines // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as String,expenseLines: null == expenseLines ? _self.expenseLines : expenseLines // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as String,netIncome: null == netIncome ? _self.netIncome : netIncome // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomeStatementReport].
extension IncomeStatementReportPatterns on IncomeStatementReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomeStatementReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomeStatementReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomeStatementReport value)  $default,){
final _that = this;
switch (_that) {
case _IncomeStatementReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomeStatementReport value)?  $default,){
final _that = this;
switch (_that) {
case _IncomeStatementReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to,  List<AccountAmountLine> revenueLines, @AmountConverter()  String totalRevenue,  List<AccountAmountLine> expenseLines, @AmountConverter()  String totalExpenses, @AmountConverter()  String netIncome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomeStatementReport() when $default != null:
return $default(_that.from,_that.to,_that.revenueLines,_that.totalRevenue,_that.expenseLines,_that.totalExpenses,_that.netIncome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to,  List<AccountAmountLine> revenueLines, @AmountConverter()  String totalRevenue,  List<AccountAmountLine> expenseLines, @AmountConverter()  String totalExpenses, @AmountConverter()  String netIncome)  $default,) {final _that = this;
switch (_that) {
case _IncomeStatementReport():
return $default(_that.from,_that.to,_that.revenueLines,_that.totalRevenue,_that.expenseLines,_that.totalExpenses,_that.netIncome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to,  List<AccountAmountLine> revenueLines, @AmountConverter()  String totalRevenue,  List<AccountAmountLine> expenseLines, @AmountConverter()  String totalExpenses, @AmountConverter()  String netIncome)?  $default,) {final _that = this;
switch (_that) {
case _IncomeStatementReport() when $default != null:
return $default(_that.from,_that.to,_that.revenueLines,_that.totalRevenue,_that.expenseLines,_that.totalExpenses,_that.netIncome);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IncomeStatementReport implements IncomeStatementReport {
  const _IncomeStatementReport({required this.from, required this.to, required  List<AccountAmountLine> revenueLines, @AmountConverter() required this.totalRevenue, required  List<AccountAmountLine> expenseLines, @AmountConverter() required this.totalExpenses, @AmountConverter() required this.netIncome}): _revenueLines = revenueLines,_expenseLines = expenseLines;
  factory _IncomeStatementReport.fromJson(Map<String, dynamic> json) => _$IncomeStatementReportFromJson(json);

@override final  String from;
@override final  String to;
 final  List<AccountAmountLine> _revenueLines;
@override List<AccountAmountLine> get revenueLines {
  if (_revenueLines is EqualUnmodifiableListView) return _revenueLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_revenueLines);
}

@override@AmountConverter() final  String totalRevenue;
 final  List<AccountAmountLine> _expenseLines;
@override List<AccountAmountLine> get expenseLines {
  if (_expenseLines is EqualUnmodifiableListView) return _expenseLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseLines);
}

@override@AmountConverter() final  String totalExpenses;
@override@AmountConverter() final  String netIncome;

/// Create a copy of IncomeStatementReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeStatementReportCopyWith<_IncomeStatementReport> get copyWith => __$IncomeStatementReportCopyWithImpl<_IncomeStatementReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeStatementReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomeStatementReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other._revenueLines, _revenueLines)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&const DeepCollectionEquality().equals(other._expenseLines, _expenseLines)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.netIncome, netIncome) || other.netIncome == netIncome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,const DeepCollectionEquality().hash(_revenueLines),totalRevenue,const DeepCollectionEquality().hash(_expenseLines),totalExpenses,netIncome);

@override
String toString() {
  return 'IncomeStatementReport(from: $from, to: $to, revenueLines: $revenueLines, totalRevenue: $totalRevenue, expenseLines: $expenseLines, totalExpenses: $totalExpenses, netIncome: $netIncome)';
}


}

/// @nodoc
abstract mixin class _$IncomeStatementReportCopyWith<$Res> implements $IncomeStatementReportCopyWith<$Res> {
  factory _$IncomeStatementReportCopyWith(_IncomeStatementReport value, $Res Function(_IncomeStatementReport) _then) = __$IncomeStatementReportCopyWithImpl;
@override @useResult
$Res call({
 String from, String to, List<AccountAmountLine> revenueLines,@AmountConverter() String totalRevenue, List<AccountAmountLine> expenseLines,@AmountConverter() String totalExpenses,@AmountConverter() String netIncome
});




}
/// @nodoc
class __$IncomeStatementReportCopyWithImpl<$Res>
    implements _$IncomeStatementReportCopyWith<$Res> {
  __$IncomeStatementReportCopyWithImpl(this._self, this._then);

  final _IncomeStatementReport _self;
  final $Res Function(_IncomeStatementReport) _then;

/// Create a copy of IncomeStatementReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? revenueLines = null,Object? totalRevenue = null,Object? expenseLines = null,Object? totalExpenses = null,Object? netIncome = null,}) {
  return _then(_IncomeStatementReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,revenueLines: null == revenueLines ? _self._revenueLines : revenueLines // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as String,expenseLines: null == expenseLines ? _self._expenseLines : expenseLines // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as String,netIncome: null == netIncome ? _self.netIncome : netIncome // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BalanceSheetReport {

 String get asOf; List<AccountAmountLine> get assets;@AmountConverter() String get totalAssets; List<AccountAmountLine> get liabilities;@AmountConverter() String get totalLiabilities; List<AccountAmountLine> get equity;@AmountConverter() String get totalEquity;@AmountConverter() String get currentEarnings;@AmountConverter() String get totalLiabilitiesAndEquity;
/// Create a copy of BalanceSheetReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalanceSheetReportCopyWith<BalanceSheetReport> get copyWith => _$BalanceSheetReportCopyWithImpl<BalanceSheetReport>(this as BalanceSheetReport, _$identity);

  /// Serializes this BalanceSheetReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalanceSheetReport&&(identical(other.asOf, asOf) || other.asOf == asOf)&&const DeepCollectionEquality().equals(other.assets, assets)&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&const DeepCollectionEquality().equals(other.liabilities, liabilities)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&const DeepCollectionEquality().equals(other.equity, equity)&&(identical(other.totalEquity, totalEquity) || other.totalEquity == totalEquity)&&(identical(other.currentEarnings, currentEarnings) || other.currentEarnings == currentEarnings)&&(identical(other.totalLiabilitiesAndEquity, totalLiabilitiesAndEquity) || other.totalLiabilitiesAndEquity == totalLiabilitiesAndEquity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asOf,const DeepCollectionEquality().hash(assets),totalAssets,const DeepCollectionEquality().hash(liabilities),totalLiabilities,const DeepCollectionEquality().hash(equity),totalEquity,currentEarnings,totalLiabilitiesAndEquity);

@override
String toString() {
  return 'BalanceSheetReport(asOf: $asOf, assets: $assets, totalAssets: $totalAssets, liabilities: $liabilities, totalLiabilities: $totalLiabilities, equity: $equity, totalEquity: $totalEquity, currentEarnings: $currentEarnings, totalLiabilitiesAndEquity: $totalLiabilitiesAndEquity)';
}


}

/// @nodoc
abstract mixin class $BalanceSheetReportCopyWith<$Res>  {
  factory $BalanceSheetReportCopyWith(BalanceSheetReport value, $Res Function(BalanceSheetReport) _then) = _$BalanceSheetReportCopyWithImpl;
@useResult
$Res call({
 String asOf, List<AccountAmountLine> assets,@AmountConverter() String totalAssets, List<AccountAmountLine> liabilities,@AmountConverter() String totalLiabilities, List<AccountAmountLine> equity,@AmountConverter() String totalEquity,@AmountConverter() String currentEarnings,@AmountConverter() String totalLiabilitiesAndEquity
});




}
/// @nodoc
class _$BalanceSheetReportCopyWithImpl<$Res>
    implements $BalanceSheetReportCopyWith<$Res> {
  _$BalanceSheetReportCopyWithImpl(this._self, this._then);

  final BalanceSheetReport _self;
  final $Res Function(BalanceSheetReport) _then;

/// Create a copy of BalanceSheetReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asOf = null,Object? assets = null,Object? totalAssets = null,Object? liabilities = null,Object? totalLiabilities = null,Object? equity = null,Object? totalEquity = null,Object? currentEarnings = null,Object? totalLiabilitiesAndEquity = null,}) {
  return _then(BalanceSheetReport(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as String,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as String,liabilities: null == liabilities ? _self.liabilities : liabilities // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as String,equity: null == equity ? _self.equity : equity // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalEquity: null == totalEquity ? _self.totalEquity : totalEquity // ignore: cast_nullable_to_non_nullable
as String,currentEarnings: null == currentEarnings ? _self.currentEarnings : currentEarnings // ignore: cast_nullable_to_non_nullable
as String,totalLiabilitiesAndEquity: null == totalLiabilitiesAndEquity ? _self.totalLiabilitiesAndEquity : totalLiabilitiesAndEquity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BalanceSheetReport].
extension BalanceSheetReportPatterns on BalanceSheetReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalanceSheetReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalanceSheetReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalanceSheetReport value)  $default,){
final _that = this;
switch (_that) {
case _BalanceSheetReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalanceSheetReport value)?  $default,){
final _that = this;
switch (_that) {
case _BalanceSheetReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String asOf,  List<AccountAmountLine> assets, @AmountConverter()  String totalAssets,  List<AccountAmountLine> liabilities, @AmountConverter()  String totalLiabilities,  List<AccountAmountLine> equity, @AmountConverter()  String totalEquity, @AmountConverter()  String currentEarnings, @AmountConverter()  String totalLiabilitiesAndEquity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalanceSheetReport() when $default != null:
return $default(_that.asOf,_that.assets,_that.totalAssets,_that.liabilities,_that.totalLiabilities,_that.equity,_that.totalEquity,_that.currentEarnings,_that.totalLiabilitiesAndEquity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String asOf,  List<AccountAmountLine> assets, @AmountConverter()  String totalAssets,  List<AccountAmountLine> liabilities, @AmountConverter()  String totalLiabilities,  List<AccountAmountLine> equity, @AmountConverter()  String totalEquity, @AmountConverter()  String currentEarnings, @AmountConverter()  String totalLiabilitiesAndEquity)  $default,) {final _that = this;
switch (_that) {
case _BalanceSheetReport():
return $default(_that.asOf,_that.assets,_that.totalAssets,_that.liabilities,_that.totalLiabilities,_that.equity,_that.totalEquity,_that.currentEarnings,_that.totalLiabilitiesAndEquity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String asOf,  List<AccountAmountLine> assets, @AmountConverter()  String totalAssets,  List<AccountAmountLine> liabilities, @AmountConverter()  String totalLiabilities,  List<AccountAmountLine> equity, @AmountConverter()  String totalEquity, @AmountConverter()  String currentEarnings, @AmountConverter()  String totalLiabilitiesAndEquity)?  $default,) {final _that = this;
switch (_that) {
case _BalanceSheetReport() when $default != null:
return $default(_that.asOf,_that.assets,_that.totalAssets,_that.liabilities,_that.totalLiabilities,_that.equity,_that.totalEquity,_that.currentEarnings,_that.totalLiabilitiesAndEquity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BalanceSheetReport implements BalanceSheetReport {
  const _BalanceSheetReport({required this.asOf, required  List<AccountAmountLine> assets, @AmountConverter() required this.totalAssets, required  List<AccountAmountLine> liabilities, @AmountConverter() required this.totalLiabilities, required  List<AccountAmountLine> equity, @AmountConverter() required this.totalEquity, @AmountConverter() required this.currentEarnings, @AmountConverter() required this.totalLiabilitiesAndEquity}): _assets = assets,_liabilities = liabilities,_equity = equity;
  factory _BalanceSheetReport.fromJson(Map<String, dynamic> json) => _$BalanceSheetReportFromJson(json);

@override final  String asOf;
 final  List<AccountAmountLine> _assets;
@override List<AccountAmountLine> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

@override@AmountConverter() final  String totalAssets;
 final  List<AccountAmountLine> _liabilities;
@override List<AccountAmountLine> get liabilities {
  if (_liabilities is EqualUnmodifiableListView) return _liabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_liabilities);
}

@override@AmountConverter() final  String totalLiabilities;
 final  List<AccountAmountLine> _equity;
@override List<AccountAmountLine> get equity {
  if (_equity is EqualUnmodifiableListView) return _equity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equity);
}

@override@AmountConverter() final  String totalEquity;
@override@AmountConverter() final  String currentEarnings;
@override@AmountConverter() final  String totalLiabilitiesAndEquity;

/// Create a copy of BalanceSheetReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceSheetReportCopyWith<_BalanceSheetReport> get copyWith => __$BalanceSheetReportCopyWithImpl<_BalanceSheetReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalanceSheetReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceSheetReport&&(identical(other.asOf, asOf) || other.asOf == asOf)&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.totalAssets, totalAssets) || other.totalAssets == totalAssets)&&const DeepCollectionEquality().equals(other._liabilities, _liabilities)&&(identical(other.totalLiabilities, totalLiabilities) || other.totalLiabilities == totalLiabilities)&&const DeepCollectionEquality().equals(other._equity, _equity)&&(identical(other.totalEquity, totalEquity) || other.totalEquity == totalEquity)&&(identical(other.currentEarnings, currentEarnings) || other.currentEarnings == currentEarnings)&&(identical(other.totalLiabilitiesAndEquity, totalLiabilitiesAndEquity) || other.totalLiabilitiesAndEquity == totalLiabilitiesAndEquity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,asOf,const DeepCollectionEquality().hash(_assets),totalAssets,const DeepCollectionEquality().hash(_liabilities),totalLiabilities,const DeepCollectionEquality().hash(_equity),totalEquity,currentEarnings,totalLiabilitiesAndEquity);

@override
String toString() {
  return 'BalanceSheetReport(asOf: $asOf, assets: $assets, totalAssets: $totalAssets, liabilities: $liabilities, totalLiabilities: $totalLiabilities, equity: $equity, totalEquity: $totalEquity, currentEarnings: $currentEarnings, totalLiabilitiesAndEquity: $totalLiabilitiesAndEquity)';
}


}

/// @nodoc
abstract mixin class _$BalanceSheetReportCopyWith<$Res> implements $BalanceSheetReportCopyWith<$Res> {
  factory _$BalanceSheetReportCopyWith(_BalanceSheetReport value, $Res Function(_BalanceSheetReport) _then) = __$BalanceSheetReportCopyWithImpl;
@override @useResult
$Res call({
 String asOf, List<AccountAmountLine> assets,@AmountConverter() String totalAssets, List<AccountAmountLine> liabilities,@AmountConverter() String totalLiabilities, List<AccountAmountLine> equity,@AmountConverter() String totalEquity,@AmountConverter() String currentEarnings,@AmountConverter() String totalLiabilitiesAndEquity
});




}
/// @nodoc
class __$BalanceSheetReportCopyWithImpl<$Res>
    implements _$BalanceSheetReportCopyWith<$Res> {
  __$BalanceSheetReportCopyWithImpl(this._self, this._then);

  final _BalanceSheetReport _self;
  final $Res Function(_BalanceSheetReport) _then;

/// Create a copy of BalanceSheetReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asOf = null,Object? assets = null,Object? totalAssets = null,Object? liabilities = null,Object? totalLiabilities = null,Object? equity = null,Object? totalEquity = null,Object? currentEarnings = null,Object? totalLiabilitiesAndEquity = null,}) {
  return _then(_BalanceSheetReport(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as String,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalAssets: null == totalAssets ? _self.totalAssets : totalAssets // ignore: cast_nullable_to_non_nullable
as String,liabilities: null == liabilities ? _self._liabilities : liabilities // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalLiabilities: null == totalLiabilities ? _self.totalLiabilities : totalLiabilities // ignore: cast_nullable_to_non_nullable
as String,equity: null == equity ? _self._equity : equity // ignore: cast_nullable_to_non_nullable
as List<AccountAmountLine>,totalEquity: null == totalEquity ? _self.totalEquity : totalEquity // ignore: cast_nullable_to_non_nullable
as String,currentEarnings: null == currentEarnings ? _self.currentEarnings : currentEarnings // ignore: cast_nullable_to_non_nullable
as String,totalLiabilitiesAndEquity: null == totalLiabilitiesAndEquity ? _self.totalLiabilitiesAndEquity : totalLiabilitiesAndEquity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CashFlowReport {

 String get from; String get to;@AmountConverter() String get openingCash;@AmountConverter() String get totalCashIn;@AmountConverter() String get totalCashOut;@AmountConverter() String get netChange;@AmountConverter() String get closingCash;
/// Create a copy of CashFlowReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashFlowReportCopyWith<CashFlowReport> get copyWith => _$CashFlowReportCopyWithImpl<CashFlowReport>(this as CashFlowReport, _$identity);

  /// Serializes this CashFlowReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashFlowReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.openingCash, openingCash) || other.openingCash == openingCash)&&(identical(other.totalCashIn, totalCashIn) || other.totalCashIn == totalCashIn)&&(identical(other.totalCashOut, totalCashOut) || other.totalCashOut == totalCashOut)&&(identical(other.netChange, netChange) || other.netChange == netChange)&&(identical(other.closingCash, closingCash) || other.closingCash == closingCash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,openingCash,totalCashIn,totalCashOut,netChange,closingCash);

@override
String toString() {
  return 'CashFlowReport(from: $from, to: $to, openingCash: $openingCash, totalCashIn: $totalCashIn, totalCashOut: $totalCashOut, netChange: $netChange, closingCash: $closingCash)';
}


}

/// @nodoc
abstract mixin class $CashFlowReportCopyWith<$Res>  {
  factory $CashFlowReportCopyWith(CashFlowReport value, $Res Function(CashFlowReport) _then) = _$CashFlowReportCopyWithImpl;
@useResult
$Res call({
 String from, String to,@AmountConverter() String openingCash,@AmountConverter() String totalCashIn,@AmountConverter() String totalCashOut,@AmountConverter() String netChange,@AmountConverter() String closingCash
});




}
/// @nodoc
class _$CashFlowReportCopyWithImpl<$Res>
    implements $CashFlowReportCopyWith<$Res> {
  _$CashFlowReportCopyWithImpl(this._self, this._then);

  final CashFlowReport _self;
  final $Res Function(CashFlowReport) _then;

/// Create a copy of CashFlowReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? openingCash = null,Object? totalCashIn = null,Object? totalCashOut = null,Object? netChange = null,Object? closingCash = null,}) {
  return _then(CashFlowReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,openingCash: null == openingCash ? _self.openingCash : openingCash // ignore: cast_nullable_to_non_nullable
as String,totalCashIn: null == totalCashIn ? _self.totalCashIn : totalCashIn // ignore: cast_nullable_to_non_nullable
as String,totalCashOut: null == totalCashOut ? _self.totalCashOut : totalCashOut // ignore: cast_nullable_to_non_nullable
as String,netChange: null == netChange ? _self.netChange : netChange // ignore: cast_nullable_to_non_nullable
as String,closingCash: null == closingCash ? _self.closingCash : closingCash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CashFlowReport].
extension CashFlowReportPatterns on CashFlowReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashFlowReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashFlowReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashFlowReport value)  $default,){
final _that = this;
switch (_that) {
case _CashFlowReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashFlowReport value)?  $default,){
final _that = this;
switch (_that) {
case _CashFlowReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to, @AmountConverter()  String openingCash, @AmountConverter()  String totalCashIn, @AmountConverter()  String totalCashOut, @AmountConverter()  String netChange, @AmountConverter()  String closingCash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashFlowReport() when $default != null:
return $default(_that.from,_that.to,_that.openingCash,_that.totalCashIn,_that.totalCashOut,_that.netChange,_that.closingCash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to, @AmountConverter()  String openingCash, @AmountConverter()  String totalCashIn, @AmountConverter()  String totalCashOut, @AmountConverter()  String netChange, @AmountConverter()  String closingCash)  $default,) {final _that = this;
switch (_that) {
case _CashFlowReport():
return $default(_that.from,_that.to,_that.openingCash,_that.totalCashIn,_that.totalCashOut,_that.netChange,_that.closingCash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to, @AmountConverter()  String openingCash, @AmountConverter()  String totalCashIn, @AmountConverter()  String totalCashOut, @AmountConverter()  String netChange, @AmountConverter()  String closingCash)?  $default,) {final _that = this;
switch (_that) {
case _CashFlowReport() when $default != null:
return $default(_that.from,_that.to,_that.openingCash,_that.totalCashIn,_that.totalCashOut,_that.netChange,_that.closingCash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashFlowReport implements CashFlowReport {
  const _CashFlowReport({required this.from, required this.to, @AmountConverter() required this.openingCash, @AmountConverter() required this.totalCashIn, @AmountConverter() required this.totalCashOut, @AmountConverter() required this.netChange, @AmountConverter() required this.closingCash});
  factory _CashFlowReport.fromJson(Map<String, dynamic> json) => _$CashFlowReportFromJson(json);

@override final  String from;
@override final  String to;
@override@AmountConverter() final  String openingCash;
@override@AmountConverter() final  String totalCashIn;
@override@AmountConverter() final  String totalCashOut;
@override@AmountConverter() final  String netChange;
@override@AmountConverter() final  String closingCash;

/// Create a copy of CashFlowReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashFlowReportCopyWith<_CashFlowReport> get copyWith => __$CashFlowReportCopyWithImpl<_CashFlowReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashFlowReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashFlowReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.openingCash, openingCash) || other.openingCash == openingCash)&&(identical(other.totalCashIn, totalCashIn) || other.totalCashIn == totalCashIn)&&(identical(other.totalCashOut, totalCashOut) || other.totalCashOut == totalCashOut)&&(identical(other.netChange, netChange) || other.netChange == netChange)&&(identical(other.closingCash, closingCash) || other.closingCash == closingCash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,openingCash,totalCashIn,totalCashOut,netChange,closingCash);

@override
String toString() {
  return 'CashFlowReport(from: $from, to: $to, openingCash: $openingCash, totalCashIn: $totalCashIn, totalCashOut: $totalCashOut, netChange: $netChange, closingCash: $closingCash)';
}


}

/// @nodoc
abstract mixin class _$CashFlowReportCopyWith<$Res> implements $CashFlowReportCopyWith<$Res> {
  factory _$CashFlowReportCopyWith(_CashFlowReport value, $Res Function(_CashFlowReport) _then) = __$CashFlowReportCopyWithImpl;
@override @useResult
$Res call({
 String from, String to,@AmountConverter() String openingCash,@AmountConverter() String totalCashIn,@AmountConverter() String totalCashOut,@AmountConverter() String netChange,@AmountConverter() String closingCash
});




}
/// @nodoc
class __$CashFlowReportCopyWithImpl<$Res>
    implements _$CashFlowReportCopyWith<$Res> {
  __$CashFlowReportCopyWithImpl(this._self, this._then);

  final _CashFlowReport _self;
  final $Res Function(_CashFlowReport) _then;

/// Create a copy of CashFlowReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? openingCash = null,Object? totalCashIn = null,Object? totalCashOut = null,Object? netChange = null,Object? closingCash = null,}) {
  return _then(_CashFlowReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,openingCash: null == openingCash ? _self.openingCash : openingCash // ignore: cast_nullable_to_non_nullable
as String,totalCashIn: null == totalCashIn ? _self.totalCashIn : totalCashIn // ignore: cast_nullable_to_non_nullable
as String,totalCashOut: null == totalCashOut ? _self.totalCashOut : totalCashOut // ignore: cast_nullable_to_non_nullable
as String,netChange: null == netChange ? _self.netChange : netChange // ignore: cast_nullable_to_non_nullable
as String,closingCash: null == closingCash ? _self.closingCash : closingCash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
