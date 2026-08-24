// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Customer {

 String get id; String get name; String? get contactPerson; String? get phone; String? get email; String? get billingAddress; String? get registrationNumber; String? get tin; String? get sstNumber; int get paymentTermsDays; String? get notes; ContactStatus get status;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.tin, tin) || other.tin == tin)&&(identical(other.sstNumber, sstNumber) || other.sstNumber == sstNumber)&&(identical(other.paymentTermsDays, paymentTermsDays) || other.paymentTermsDays == paymentTermsDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactPerson,phone,email,billingAddress,registrationNumber,tin,sstNumber,paymentTermsDays,notes,status);

@override
String toString() {
  return 'Customer(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, billingAddress: $billingAddress, registrationNumber: $registrationNumber, tin: $tin, sstNumber: $sstNumber, paymentTermsDays: $paymentTermsDays, notes: $notes, status: $status)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? contactPerson, String? phone, String? email, String? billingAddress, String? registrationNumber, String? tin, String? sstNumber, int paymentTermsDays, String? notes, ContactStatus status
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? billingAddress = freezed,Object? registrationNumber = freezed,Object? tin = freezed,Object? sstNumber = freezed,Object? paymentTermsDays = null,Object? notes = freezed,Object? status = null,}) {
  return _then(Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,tin: freezed == tin ? _self.tin : tin // ignore: cast_nullable_to_non_nullable
as String?,sstNumber: freezed == sstNumber ? _self.sstNumber : sstNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContactStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? contactPerson,  String? phone,  String? email,  String? billingAddress,  String? registrationNumber,  String? tin,  String? sstNumber,  int paymentTermsDays,  String? notes,  ContactStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.billingAddress,_that.registrationNumber,_that.tin,_that.sstNumber,_that.paymentTermsDays,_that.notes,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? contactPerson,  String? phone,  String? email,  String? billingAddress,  String? registrationNumber,  String? tin,  String? sstNumber,  int paymentTermsDays,  String? notes,  ContactStatus status)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.billingAddress,_that.registrationNumber,_that.tin,_that.sstNumber,_that.paymentTermsDays,_that.notes,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? contactPerson,  String? phone,  String? email,  String? billingAddress,  String? registrationNumber,  String? tin,  String? sstNumber,  int paymentTermsDays,  String? notes,  ContactStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.billingAddress,_that.registrationNumber,_that.tin,_that.sstNumber,_that.paymentTermsDays,_that.notes,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer implements Customer {
  const _Customer({required this.id, required this.name, this.contactPerson, this.phone, this.email, this.billingAddress, this.registrationNumber, this.tin, this.sstNumber, required this.paymentTermsDays, this.notes, required this.status});
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? contactPerson;
@override final  String? phone;
@override final  String? email;
@override final  String? billingAddress;
@override final  String? registrationNumber;
@override final  String? tin;
@override final  String? sstNumber;
@override final  int paymentTermsDays;
@override final  String? notes;
@override final  ContactStatus status;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.tin, tin) || other.tin == tin)&&(identical(other.sstNumber, sstNumber) || other.sstNumber == sstNumber)&&(identical(other.paymentTermsDays, paymentTermsDays) || other.paymentTermsDays == paymentTermsDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactPerson,phone,email,billingAddress,registrationNumber,tin,sstNumber,paymentTermsDays,notes,status);

@override
String toString() {
  return 'Customer(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, billingAddress: $billingAddress, registrationNumber: $registrationNumber, tin: $tin, sstNumber: $sstNumber, paymentTermsDays: $paymentTermsDays, notes: $notes, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? contactPerson, String? phone, String? email, String? billingAddress, String? registrationNumber, String? tin, String? sstNumber, int paymentTermsDays, String? notes, ContactStatus status
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? billingAddress = freezed,Object? registrationNumber = freezed,Object? tin = freezed,Object? sstNumber = freezed,Object? paymentTermsDays = null,Object? notes = freezed,Object? status = null,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,tin: freezed == tin ? _self.tin : tin // ignore: cast_nullable_to_non_nullable
as String?,sstNumber: freezed == sstNumber ? _self.sstNumber : sstNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContactStatus,
  ));
}


}


/// @nodoc
mixin _$Supplier {

 String get id; String get name; String? get contactPerson; String? get phone; String? get email; String? get billingAddress; String? get registrationNumber; String? get tin; String? get sstNumber; int get paymentTermsDays; String? get notes; ContactStatus get status;
/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierCopyWith<Supplier> get copyWith => _$SupplierCopyWithImpl<Supplier>(this as Supplier, _$identity);

  /// Serializes this Supplier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.tin, tin) || other.tin == tin)&&(identical(other.sstNumber, sstNumber) || other.sstNumber == sstNumber)&&(identical(other.paymentTermsDays, paymentTermsDays) || other.paymentTermsDays == paymentTermsDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactPerson,phone,email,billingAddress,registrationNumber,tin,sstNumber,paymentTermsDays,notes,status);

@override
String toString() {
  return 'Supplier(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, billingAddress: $billingAddress, registrationNumber: $registrationNumber, tin: $tin, sstNumber: $sstNumber, paymentTermsDays: $paymentTermsDays, notes: $notes, status: $status)';
}


}

/// @nodoc
abstract mixin class $SupplierCopyWith<$Res>  {
  factory $SupplierCopyWith(Supplier value, $Res Function(Supplier) _then) = _$SupplierCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? contactPerson, String? phone, String? email, String? billingAddress, String? registrationNumber, String? tin, String? sstNumber, int paymentTermsDays, String? notes, ContactStatus status
});




}
/// @nodoc
class _$SupplierCopyWithImpl<$Res>
    implements $SupplierCopyWith<$Res> {
  _$SupplierCopyWithImpl(this._self, this._then);

  final Supplier _self;
  final $Res Function(Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? billingAddress = freezed,Object? registrationNumber = freezed,Object? tin = freezed,Object? sstNumber = freezed,Object? paymentTermsDays = null,Object? notes = freezed,Object? status = null,}) {
  return _then(Supplier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,tin: freezed == tin ? _self.tin : tin // ignore: cast_nullable_to_non_nullable
as String?,sstNumber: freezed == sstNumber ? _self.sstNumber : sstNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContactStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Supplier].
extension SupplierPatterns on Supplier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Supplier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Supplier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Supplier value)  $default,){
final _that = this;
switch (_that) {
case _Supplier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Supplier value)?  $default,){
final _that = this;
switch (_that) {
case _Supplier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? contactPerson,  String? phone,  String? email,  String? billingAddress,  String? registrationNumber,  String? tin,  String? sstNumber,  int paymentTermsDays,  String? notes,  ContactStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Supplier() when $default != null:
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.billingAddress,_that.registrationNumber,_that.tin,_that.sstNumber,_that.paymentTermsDays,_that.notes,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? contactPerson,  String? phone,  String? email,  String? billingAddress,  String? registrationNumber,  String? tin,  String? sstNumber,  int paymentTermsDays,  String? notes,  ContactStatus status)  $default,) {final _that = this;
switch (_that) {
case _Supplier():
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.billingAddress,_that.registrationNumber,_that.tin,_that.sstNumber,_that.paymentTermsDays,_that.notes,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? contactPerson,  String? phone,  String? email,  String? billingAddress,  String? registrationNumber,  String? tin,  String? sstNumber,  int paymentTermsDays,  String? notes,  ContactStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Supplier() when $default != null:
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.billingAddress,_that.registrationNumber,_that.tin,_that.sstNumber,_that.paymentTermsDays,_that.notes,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Supplier implements Supplier {
  const _Supplier({required this.id, required this.name, this.contactPerson, this.phone, this.email, this.billingAddress, this.registrationNumber, this.tin, this.sstNumber, required this.paymentTermsDays, this.notes, required this.status});
  factory _Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? contactPerson;
@override final  String? phone;
@override final  String? email;
@override final  String? billingAddress;
@override final  String? registrationNumber;
@override final  String? tin;
@override final  String? sstNumber;
@override final  int paymentTermsDays;
@override final  String? notes;
@override final  ContactStatus status;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierCopyWith<_Supplier> get copyWith => __$SupplierCopyWithImpl<_Supplier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress)&&(identical(other.registrationNumber, registrationNumber) || other.registrationNumber == registrationNumber)&&(identical(other.tin, tin) || other.tin == tin)&&(identical(other.sstNumber, sstNumber) || other.sstNumber == sstNumber)&&(identical(other.paymentTermsDays, paymentTermsDays) || other.paymentTermsDays == paymentTermsDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactPerson,phone,email,billingAddress,registrationNumber,tin,sstNumber,paymentTermsDays,notes,status);

@override
String toString() {
  return 'Supplier(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, billingAddress: $billingAddress, registrationNumber: $registrationNumber, tin: $tin, sstNumber: $sstNumber, paymentTermsDays: $paymentTermsDays, notes: $notes, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SupplierCopyWith<$Res> implements $SupplierCopyWith<$Res> {
  factory _$SupplierCopyWith(_Supplier value, $Res Function(_Supplier) _then) = __$SupplierCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? contactPerson, String? phone, String? email, String? billingAddress, String? registrationNumber, String? tin, String? sstNumber, int paymentTermsDays, String? notes, ContactStatus status
});




}
/// @nodoc
class __$SupplierCopyWithImpl<$Res>
    implements _$SupplierCopyWith<$Res> {
  __$SupplierCopyWithImpl(this._self, this._then);

  final _Supplier _self;
  final $Res Function(_Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? billingAddress = freezed,Object? registrationNumber = freezed,Object? tin = freezed,Object? sstNumber = freezed,Object? paymentTermsDays = null,Object? notes = freezed,Object? status = null,}) {
  return _then(_Supplier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as String?,registrationNumber: freezed == registrationNumber ? _self.registrationNumber : registrationNumber // ignore: cast_nullable_to_non_nullable
as String?,tin: freezed == tin ? _self.tin : tin // ignore: cast_nullable_to_non_nullable
as String?,sstNumber: freezed == sstNumber ? _self.sstNumber : sstNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentTermsDays: null == paymentTermsDays ? _self.paymentTermsDays : paymentTermsDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContactStatus,
  ));
}


}

// dart format on
