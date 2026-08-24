import '../../../core/api/api_client.dart';
import '../domain/financial_space.dart';
import '../domain/space_member.dart';

class SpacesRepository {
  SpacesRepository(this._client);

  final ApiClient _client;

  Future<List<FinancialSpace>> listMySpaces() async {
    final data = await _client.get('/api/v1/spaces') as List;
    return data.map((e) => FinancialSpace.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<FinancialSpace> createBusinessSpace({
    required String name,
    required String legalName,
    String? registrationNumber,
    String? tin,
    String? businessType,
    String? industry,
  }) async {
    final data = await _client.post('/api/v1/spaces/business', data: {
      'name': name,
      'legalName': legalName,
      if (registrationNumber != null) 'registrationNumber': registrationNumber,
      if (tin != null) 'tin': tin,
      if (businessType != null) 'businessType': businessType,
      if (industry != null) 'industry': industry,
    });
    return FinancialSpace.fromJson(data as Map<String, dynamic>);
  }

  Future<BusinessProfile> getBusinessProfile(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/business-profile');
    return BusinessProfile.fromJson(data as Map<String, dynamic>);
  }

  /// Phase 10 — the first-ever update path for this resource. Requires the
  /// server-enforced `MANAGE_BOOKS` permission (a real 403
  /// `INSUFFICIENT_PERMISSION` on a non-owner/admin/finance member — never
  /// guessed client-side, so the edit action itself is never hidden based on
  /// role). [legalName] is the only field the server still requires;
  /// everything else may be cleared by sending `null`.
  Future<BusinessProfile> updateBusinessProfile(
    String spaceId, {
    required String legalName,
    String? tradeName,
    String? registrationNumber,
    String? tin,
    String? businessType,
    String? industry,
    String? sstNumber,
    String? financialYearStart,
    String? financialYearEnd,
    String? address,
    String? phone,
    String? email,
    String? currency,
    String? annualRevenue,
  }) async {
    final data = await _client.put('/api/v1/spaces/$spaceId/business-profile', data: {
      'legalName': legalName,
      'tradeName': tradeName,
      'registrationNumber': registrationNumber,
      'tin': tin,
      'businessType': businessType,
      'industry': industry,
      'sstNumber': sstNumber,
      'financialYearStart': financialYearStart,
      'financialYearEnd': financialYearEnd,
      'address': address,
      'phone': phone,
      'email': email,
      'currency': currency,
      'annualRevenue': annualRevenue,
    });
    return BusinessProfile.fromJson(data as Map<String, dynamic>);
  }

  Future<List<SpaceMember>> listMembers(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/members') as List;
    return data.map((e) => SpaceMember.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SpaceMember> addMember(String spaceId, {required String email, required SpaceRole role}) async {
    final data = await _client.post('/api/v1/spaces/$spaceId/members', data: {
      'email': email,
      'role': role.name,
    });
    return SpaceMember.fromJson(data as Map<String, dynamic>);
  }

  Future<SpaceMember> changeMemberRole(String spaceId, String memberId, {required SpaceRole role}) async {
    final data = await _client.patch('/api/v1/spaces/$spaceId/members/$memberId', data: {'role': role.name});
    return SpaceMember.fromJson(data as Map<String, dynamic>);
  }

  Future<void> removeMember(String spaceId, String memberId) =>
      _client.delete('/api/v1/spaces/$spaceId/members/$memberId');
}
