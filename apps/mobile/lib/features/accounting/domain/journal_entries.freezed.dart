// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entries.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntryLine {

 String get id; String get accountId; String get accountCode; String get accountName; LedgerDirection get direction;@AmountConverter() String get amount; String? get description;
/// Create a copy of JournalEntryLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryLineCopyWith<JournalEntryLine> get copyWith => _$JournalEntryLineCopyWithImpl<JournalEntryLine>(this as JournalEntryLine, _$identity);

  /// Serializes this JournalEntryLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryLine&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountCode,accountName,direction,amount,description);

@override
String toString() {
  return 'JournalEntryLine(id: $id, accountId: $accountId, accountCode: $accountCode, accountName: $accountName, direction: $direction, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class $JournalEntryLineCopyWith<$Res>  {
  factory $JournalEntryLineCopyWith(JournalEntryLine value, $Res Function(JournalEntryLine) _then) = _$JournalEntryLineCopyWithImpl;
@useResult
$Res call({
 String id, String accountId, String accountCode, String accountName, LedgerDirection direction,@AmountConverter() String amount, String? description
});




}
/// @nodoc
class _$JournalEntryLineCopyWithImpl<$Res>
    implements $JournalEntryLineCopyWith<$Res> {
  _$JournalEntryLineCopyWithImpl(this._self, this._then);

  final JournalEntryLine _self;
  final $Res Function(JournalEntryLine) _then;

/// Create a copy of JournalEntryLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? direction = null,Object? amount = null,Object? description = freezed,}) {
  return _then(JournalEntryLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as LedgerDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryLine].
extension JournalEntryLinePatterns on JournalEntryLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryLine value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryLine value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String accountId,  String accountCode,  String accountName,  LedgerDirection direction, @AmountConverter()  String amount,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryLine() when $default != null:
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.direction,_that.amount,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String accountId,  String accountCode,  String accountName,  LedgerDirection direction, @AmountConverter()  String amount,  String? description)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryLine():
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.direction,_that.amount,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String accountId,  String accountCode,  String accountName,  LedgerDirection direction, @AmountConverter()  String amount,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryLine() when $default != null:
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.direction,_that.amount,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntryLine implements JournalEntryLine {
  const _JournalEntryLine({required this.id, required this.accountId, required this.accountCode, required this.accountName, required this.direction, @AmountConverter() required this.amount, this.description});
  factory _JournalEntryLine.fromJson(Map<String, dynamic> json) => _$JournalEntryLineFromJson(json);

@override final  String id;
@override final  String accountId;
@override final  String accountCode;
@override final  String accountName;
@override final  LedgerDirection direction;
@override@AmountConverter() final  String amount;
@override final  String? description;

/// Create a copy of JournalEntryLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryLineCopyWith<_JournalEntryLine> get copyWith => __$JournalEntryLineCopyWithImpl<_JournalEntryLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryLine&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,accountCode,accountName,direction,amount,description);

@override
String toString() {
  return 'JournalEntryLine(id: $id, accountId: $accountId, accountCode: $accountCode, accountName: $accountName, direction: $direction, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryLineCopyWith<$Res> implements $JournalEntryLineCopyWith<$Res> {
  factory _$JournalEntryLineCopyWith(_JournalEntryLine value, $Res Function(_JournalEntryLine) _then) = __$JournalEntryLineCopyWithImpl;
@override @useResult
$Res call({
 String id, String accountId, String accountCode, String accountName, LedgerDirection direction,@AmountConverter() String amount, String? description
});




}
/// @nodoc
class __$JournalEntryLineCopyWithImpl<$Res>
    implements _$JournalEntryLineCopyWith<$Res> {
  __$JournalEntryLineCopyWithImpl(this._self, this._then);

  final _JournalEntryLine _self;
  final $Res Function(_JournalEntryLine) _then;

/// Create a copy of JournalEntryLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? direction = null,Object? amount = null,Object? description = freezed,}) {
  return _then(_JournalEntryLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as LedgerDirection,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JournalEntry {

 String get id; String get entryDate; String get description; JournalSourceType get sourceType; String? get sourceId; List<JournalEntryLine> get lines;
/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<JournalEntry> get copyWith => _$JournalEntryCopyWithImpl<JournalEntry>(this as JournalEntry, _$identity);

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entryDate,description,sourceType,sourceId,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'JournalEntry(id: $id, entryDate: $entryDate, description: $description, sourceType: $sourceType, sourceId: $sourceId, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $JournalEntryCopyWith<$Res>  {
  factory $JournalEntryCopyWith(JournalEntry value, $Res Function(JournalEntry) _then) = _$JournalEntryCopyWithImpl;
@useResult
$Res call({
 String id, String entryDate, String description, JournalSourceType sourceType, String? sourceId, List<JournalEntryLine> lines
});




}
/// @nodoc
class _$JournalEntryCopyWithImpl<$Res>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._self, this._then);

  final JournalEntry _self;
  final $Res Function(JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entryDate = null,Object? description = null,Object? sourceType = null,Object? sourceId = freezed,Object? lines = null,}) {
  return _then(JournalEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as JournalSourceType,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalEntryLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntry].
extension JournalEntryPatterns on JournalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntry value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String entryDate,  String description,  JournalSourceType sourceType,  String? sourceId,  List<JournalEntryLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.entryDate,_that.description,_that.sourceType,_that.sourceId,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String entryDate,  String description,  JournalSourceType sourceType,  String? sourceId,  List<JournalEntryLine> lines)  $default,) {final _that = this;
switch (_that) {
case _JournalEntry():
return $default(_that.id,_that.entryDate,_that.description,_that.sourceType,_that.sourceId,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String entryDate,  String description,  JournalSourceType sourceType,  String? sourceId,  List<JournalEntryLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.entryDate,_that.description,_that.sourceType,_that.sourceId,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntry implements JournalEntry {
  const _JournalEntry({required this.id, required this.entryDate, required this.description, required this.sourceType, this.sourceId, required  List<JournalEntryLine> lines}): _lines = lines;
  factory _JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);

@override final  String id;
@override final  String entryDate;
@override final  String description;
@override final  JournalSourceType sourceType;
@override final  String? sourceId;
 final  List<JournalEntryLine> _lines;
@override List<JournalEntryLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryCopyWith<_JournalEntry> get copyWith => __$JournalEntryCopyWithImpl<_JournalEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entryDate,description,sourceType,sourceId,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'JournalEntry(id: $id, entryDate: $entryDate, description: $description, sourceType: $sourceType, sourceId: $sourceId, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryCopyWith<$Res> implements $JournalEntryCopyWith<$Res> {
  factory _$JournalEntryCopyWith(_JournalEntry value, $Res Function(_JournalEntry) _then) = __$JournalEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String entryDate, String description, JournalSourceType sourceType, String? sourceId, List<JournalEntryLine> lines
});




}
/// @nodoc
class __$JournalEntryCopyWithImpl<$Res>
    implements _$JournalEntryCopyWith<$Res> {
  __$JournalEntryCopyWithImpl(this._self, this._then);

  final _JournalEntry _self;
  final $Res Function(_JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entryDate = null,Object? description = null,Object? sourceType = null,Object? sourceId = freezed,Object? lines = null,}) {
  return _then(_JournalEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as JournalSourceType,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalEntryLine>,
  ));
}


}

// dart format on
