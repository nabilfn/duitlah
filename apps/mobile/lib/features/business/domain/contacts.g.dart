// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: json['id'] as String,
  name: json['name'] as String,
  contactPerson: json['contactPerson'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  billingAddress: json['billingAddress'] as String?,
  registrationNumber: json['registrationNumber'] as String?,
  tin: json['tin'] as String?,
  sstNumber: json['sstNumber'] as String?,
  paymentTermsDays: (json['paymentTermsDays'] as num).toInt(),
  notes: json['notes'] as String?,
  status: $enumDecode(_$ContactStatusEnumMap, json['status']),
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contactPerson': instance.contactPerson,
  'phone': instance.phone,
  'email': instance.email,
  'billingAddress': instance.billingAddress,
  'registrationNumber': instance.registrationNumber,
  'tin': instance.tin,
  'sstNumber': instance.sstNumber,
  'paymentTermsDays': instance.paymentTermsDays,
  'notes': instance.notes,
  'status': _$ContactStatusEnumMap[instance.status]!,
};

const _$ContactStatusEnumMap = {
  ContactStatus.ACTIVE: 'ACTIVE',
  ContactStatus.ARCHIVED: 'ARCHIVED',
};

_Supplier _$SupplierFromJson(Map<String, dynamic> json) => _Supplier(
  id: json['id'] as String,
  name: json['name'] as String,
  contactPerson: json['contactPerson'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  billingAddress: json['billingAddress'] as String?,
  registrationNumber: json['registrationNumber'] as String?,
  tin: json['tin'] as String?,
  sstNumber: json['sstNumber'] as String?,
  paymentTermsDays: (json['paymentTermsDays'] as num).toInt(),
  notes: json['notes'] as String?,
  status: $enumDecode(_$ContactStatusEnumMap, json['status']),
);

Map<String, dynamic> _$SupplierToJson(_Supplier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contactPerson': instance.contactPerson,
  'phone': instance.phone,
  'email': instance.email,
  'billingAddress': instance.billingAddress,
  'registrationNumber': instance.registrationNumber,
  'tin': instance.tin,
  'sstNumber': instance.sstNumber,
  'paymentTermsDays': instance.paymentTermsDays,
  'notes': instance.notes,
  'status': _$ContactStatusEnumMap[instance.status]!,
};
