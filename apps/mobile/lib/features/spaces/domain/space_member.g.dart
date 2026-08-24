// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpaceMember _$SpaceMemberFromJson(Map<String, dynamic> json) => _SpaceMember(
  id: json['id'] as String,
  userId: json['userId'] as String,
  displayName: json['displayName'] as String?,
  email: json['email'] as String?,
  role: $enumDecode(_$SpaceRoleEnumMap, json['role']),
  status: $enumDecode(_$MemberStatusEnumMap, json['status']),
);

Map<String, dynamic> _$SpaceMemberToJson(_SpaceMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'role': _$SpaceRoleEnumMap[instance.role]!,
      'status': _$MemberStatusEnumMap[instance.status]!,
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

const _$MemberStatusEnumMap = {
  MemberStatus.ACTIVE: 'ACTIVE',
  MemberStatus.REMOVED: 'REMOVED',
};
