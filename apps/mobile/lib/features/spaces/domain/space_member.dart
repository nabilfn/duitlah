// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

import 'financial_space.dart';

part 'space_member.freezed.dart';
part 'space_member.g.dart';

enum MemberStatus { ACTIVE, REMOVED }

@freezed
abstract class SpaceMember with _$SpaceMember {
  const factory SpaceMember({
    required String id,
    required String userId,
    String? displayName,
    String? email,
    required SpaceRole role,
    required MemberStatus status,
  }) = _SpaceMember;

  factory SpaceMember.fromJson(Map<String, dynamic> json) => _$SpaceMemberFromJson(json);
}
