// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialSpace _$FinancialSpaceFromJson(Map<String, dynamic> json) =>
    _FinancialSpace(
      id: json['id'] as String,
      type: $enumDecode(_$SpaceTypeEnumMap, json['type']),
      name: json['name'] as String,
      yourRole: $enumDecode(_$SpaceRoleEnumMap, json['yourRole']),
      status: $enumDecode(_$SpaceStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$FinancialSpaceToJson(_FinancialSpace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SpaceTypeEnumMap[instance.type]!,
      'name': instance.name,
      'yourRole': _$SpaceRoleEnumMap[instance.yourRole]!,
      'status': _$SpaceStatusEnumMap[instance.status]!,
    };

const _$SpaceTypeEnumMap = {
  SpaceType.PERSONAL: 'PERSONAL',
  SpaceType.BUSINESS: 'BUSINESS',
};

const _$SpaceRoleEnumMap = {
  SpaceRole.OWNER: 'OWNER',
  SpaceRole.ADMIN: 'ADMIN',
  SpaceRole.FINANCE: 'FINANCE',
  SpaceRole.ACCOUNTANT: 'ACCOUNTANT',
  SpaceRole.SALES: 'SALES',
  SpaceRole.STAFF: 'STAFF',
  SpaceRole.VIEWER: 'VIEWER',
};

const _$SpaceStatusEnumMap = {
  SpaceStatus.ACTIVE: 'ACTIVE',
  SpaceStatus.ARCHIVED: 'ARCHIVED',
};

_BusinessProfile _$BusinessProfileFromJson(Map<String, dynamic> json) =>
    _BusinessProfile(
      spaceId: json['spaceId'] as String,
      legalName: json['legalName'] as String,
      tradeName: json['tradeName'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      tin: json['tin'] as String?,
      businessType: json['businessType'] as String?,
      industry: json['industry'] as String?,
      sstNumber: json['sstNumber'] as String?,
      financialYearStart: json['financialYearStart'] as String?,
      financialYearEnd: json['financialYearEnd'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      currency: json['currency'] as String,
      annualRevenue: const NullableAmountConverter().fromJson(
        json['annualRevenue'],
      ),
    );

Map<String, dynamic> _$BusinessProfileToJson(_BusinessProfile instance) =>
    <String, dynamic>{
      'spaceId': instance.spaceId,
      'legalName': instance.legalName,
      'tradeName': instance.tradeName,
      'registrationNumber': instance.registrationNumber,
      'tin': instance.tin,
      'businessType': instance.businessType,
      'industry': instance.industry,
      'sstNumber': instance.sstNumber,
      'financialYearStart': instance.financialYearStart,
      'financialYearEnd': instance.financialYearEnd,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'currency': instance.currency,
      'annualRevenue': const NullableAmountConverter().toJson(
        instance.annualRevenue,
      ),
    };
