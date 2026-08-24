// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthComponent {

 String get key; String get label;@AmountConverter() String get score;@AmountConverter() String get weight; String get explanation;
/// Create a copy of HealthComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthComponentCopyWith<HealthComponent> get copyWith => _$HealthComponentCopyWithImpl<HealthComponent>(this as HealthComponent, _$identity);

  /// Serializes this HealthComponent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthComponent&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.score, score) || other.score == score)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,score,weight,explanation);

@override
String toString() {
  return 'HealthComponent(key: $key, label: $label, score: $score, weight: $weight, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $HealthComponentCopyWith<$Res>  {
  factory $HealthComponentCopyWith(HealthComponent value, $Res Function(HealthComponent) _then) = _$HealthComponentCopyWithImpl;
@useResult
$Res call({
 String key, String label,@AmountConverter() String score,@AmountConverter() String weight, String explanation
});




}
/// @nodoc
class _$HealthComponentCopyWithImpl<$Res>
    implements $HealthComponentCopyWith<$Res> {
  _$HealthComponentCopyWithImpl(this._self, this._then);

  final HealthComponent _self;
  final $Res Function(HealthComponent) _then;

/// Create a copy of HealthComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? score = null,Object? weight = null,Object? explanation = null,}) {
  return _then(HealthComponent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthComponent].
extension HealthComponentPatterns on HealthComponent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthComponent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthComponent value)  $default,){
final _that = this;
switch (_that) {
case _HealthComponent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthComponent value)?  $default,){
final _that = this;
switch (_that) {
case _HealthComponent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label, @AmountConverter()  String score, @AmountConverter()  String weight,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthComponent() when $default != null:
return $default(_that.key,_that.label,_that.score,_that.weight,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label, @AmountConverter()  String score, @AmountConverter()  String weight,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _HealthComponent():
return $default(_that.key,_that.label,_that.score,_that.weight,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label, @AmountConverter()  String score, @AmountConverter()  String weight,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _HealthComponent() when $default != null:
return $default(_that.key,_that.label,_that.score,_that.weight,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthComponent implements HealthComponent {
  const _HealthComponent({required this.key, required this.label, @AmountConverter() required this.score, @AmountConverter() required this.weight, required this.explanation});
  factory _HealthComponent.fromJson(Map<String, dynamic> json) => _$HealthComponentFromJson(json);

@override final  String key;
@override final  String label;
@override@AmountConverter() final  String score;
@override@AmountConverter() final  String weight;
@override final  String explanation;

/// Create a copy of HealthComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthComponentCopyWith<_HealthComponent> get copyWith => __$HealthComponentCopyWithImpl<_HealthComponent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthComponentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthComponent&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.score, score) || other.score == score)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,label,score,weight,explanation);

@override
String toString() {
  return 'HealthComponent(key: $key, label: $label, score: $score, weight: $weight, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$HealthComponentCopyWith<$Res> implements $HealthComponentCopyWith<$Res> {
  factory _$HealthComponentCopyWith(_HealthComponent value, $Res Function(_HealthComponent) _then) = __$HealthComponentCopyWithImpl;
@override @useResult
$Res call({
 String key, String label,@AmountConverter() String score,@AmountConverter() String weight, String explanation
});




}
/// @nodoc
class __$HealthComponentCopyWithImpl<$Res>
    implements _$HealthComponentCopyWith<$Res> {
  __$HealthComponentCopyWithImpl(this._self, this._then);

  final _HealthComponent _self;
  final $Res Function(_HealthComponent) _then;

/// Create a copy of HealthComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? score = null,Object? weight = null,Object? explanation = null,}) {
  return _then(_HealthComponent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FinancialHealth {

@AmountConverter() String get score; List<HealthComponent> get components; List<String> get recommendations;
/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialHealthCopyWith<FinancialHealth> get copyWith => _$FinancialHealthCopyWithImpl<FinancialHealth>(this as FinancialHealth, _$identity);

  /// Serializes this FinancialHealth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialHealth&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.components, components)&&const DeepCollectionEquality().equals(other.recommendations, recommendations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,const DeepCollectionEquality().hash(components),const DeepCollectionEquality().hash(recommendations));

@override
String toString() {
  return 'FinancialHealth(score: $score, components: $components, recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class $FinancialHealthCopyWith<$Res>  {
  factory $FinancialHealthCopyWith(FinancialHealth value, $Res Function(FinancialHealth) _then) = _$FinancialHealthCopyWithImpl;
@useResult
$Res call({
@AmountConverter() String score, List<HealthComponent> components, List<String> recommendations
});




}
/// @nodoc
class _$FinancialHealthCopyWithImpl<$Res>
    implements $FinancialHealthCopyWith<$Res> {
  _$FinancialHealthCopyWithImpl(this._self, this._then);

  final FinancialHealth _self;
  final $Res Function(FinancialHealth) _then;

/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? components = null,Object? recommendations = null,}) {
  return _then(FinancialHealth(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<HealthComponent>,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialHealth].
extension FinancialHealthPatterns on FinancialHealth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialHealth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialHealth value)  $default,){
final _that = this;
switch (_that) {
case _FinancialHealth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialHealth value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@AmountConverter()  String score,  List<HealthComponent> components,  List<String> recommendations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
return $default(_that.score,_that.components,_that.recommendations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@AmountConverter()  String score,  List<HealthComponent> components,  List<String> recommendations)  $default,) {final _that = this;
switch (_that) {
case _FinancialHealth():
return $default(_that.score,_that.components,_that.recommendations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@AmountConverter()  String score,  List<HealthComponent> components,  List<String> recommendations)?  $default,) {final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
return $default(_that.score,_that.components,_that.recommendations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialHealth implements FinancialHealth {
  const _FinancialHealth({@AmountConverter() required this.score, required  List<HealthComponent> components, required  List<String> recommendations}): _components = components,_recommendations = recommendations;
  factory _FinancialHealth.fromJson(Map<String, dynamic> json) => _$FinancialHealthFromJson(json);

@override@AmountConverter() final  String score;
 final  List<HealthComponent> _components;
@override List<HealthComponent> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}

 final  List<String> _recommendations;
@override List<String> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}


/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialHealthCopyWith<_FinancialHealth> get copyWith => __$FinancialHealthCopyWithImpl<_FinancialHealth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialHealthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialHealth&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other._components, _components)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,const DeepCollectionEquality().hash(_components),const DeepCollectionEquality().hash(_recommendations));

@override
String toString() {
  return 'FinancialHealth(score: $score, components: $components, recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class _$FinancialHealthCopyWith<$Res> implements $FinancialHealthCopyWith<$Res> {
  factory _$FinancialHealthCopyWith(_FinancialHealth value, $Res Function(_FinancialHealth) _then) = __$FinancialHealthCopyWithImpl;
@override @useResult
$Res call({
@AmountConverter() String score, List<HealthComponent> components, List<String> recommendations
});




}
/// @nodoc
class __$FinancialHealthCopyWithImpl<$Res>
    implements _$FinancialHealthCopyWith<$Res> {
  __$FinancialHealthCopyWithImpl(this._self, this._then);

  final _FinancialHealth _self;
  final $Res Function(_FinancialHealth) _then;

/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? components = null,Object? recommendations = null,}) {
  return _then(_FinancialHealth(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as String,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<HealthComponent>,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
