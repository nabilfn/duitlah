import 'package:dio/dio.dart';

import '../../../core/config/env.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/bagilah_enums.dart';
import '../domain/bill.dart';

/// Mirrors `apps/web/src/lib/guest-api-client.ts` exactly: a guest has no
/// JWT, no refresh cookie — just the opaque `guestToken` issued at join
/// time, accepted directly in the URL path by `BagilahGuestController`. No
/// refresh-and-retry dance applies (see docs/security.md's "Guest access"
/// section), so this is a separate, simpler client rather than a mode of
/// [ApiClient]. This is exactly how the mandatory "guest must never install
/// the app" requirement stays true: the whole guest flow works over plain
/// HTTP calls a `WebView`-free native screen can make directly.
class GuestBagilahRepository {
  GuestBagilahRepository() : _dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));

  final Dio _dio;

  Future<dynamic> _request(
    String method,
    String guestToken,
    String path, {
    dynamic data,
  }) async {
    late Response response;
    try {
      response = await _dio.request(
        '/api/v1/bagilah/guest/$guestToken$path',
        data: data,
        options: Options(method: method, validateStatus: (_) => true),
      );
    } on DioException {
      throw AppException.local(
        'NO_CONNECTION',
        'Connection required. Check your internet and try again.',
      );
    }
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data;
    }
    final body = response.data;
    if (body is Map<String, dynamic>) {
      throw AppException(
        statusCode: response.statusCode ?? 0,
        code: (body['code'] as String?) ?? 'UNKNOWN_ERROR',
        message: (body['message'] as String?) ?? 'Something went wrong.',
      );
    }
    throw AppException(
      statusCode: response.statusCode ?? 0,
      code: 'UNKNOWN_ERROR',
      message: 'Something went wrong.',
    );
  }

  /// Public — joining is how a guest token is obtained in the first place.
  /// The request field is `guestName`, not `displayName` — a real
  /// asymmetry with the response shape (`JoinBillResponse.displayName`),
  /// confirmed by hitting the live API directly.
  static Future<JoinBillResponse> join(
    String token, {
    String? displayName,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
    final response = await dio.post(
      '/api/v1/bagilah/join',
      data: {'token': token, if (displayName != null) 'guestName': displayName},
      options: Options(validateStatus: (_) => true),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return JoinBillResponse.fromJson(response.data as Map<String, dynamic>);
    }
    final body = response.data as Map<String, dynamic>?;
    throw AppException(
      statusCode: response.statusCode ?? 0,
      code: body?['code'] as String? ?? 'UNKNOWN_ERROR',
      message: body?['message'] as String? ?? 'Could not join this bill.',
    );
  }

  Future<Bill> getBill(String guestToken) async => Bill.fromJson(
    await _request('GET', guestToken, '') as Map<String, dynamic>,
  );

  Future<List<ReceiptItem>> getItems(String guestToken) async {
    final data = await _request('GET', guestToken, '/items') as List;
    return data
        .map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Participant>> getParticipants(String guestToken) async {
    final data = await _request('GET', guestToken, '/participants') as List;
    return data
        .map((e) => Participant.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Claim>> getClaims(String guestToken, String itemId) async {
    final data =
        await _request('GET', guestToken, '/items/$itemId/claims') as List;
    return data.map((e) => Claim.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Breakdown> getBreakdown(String guestToken) async => Breakdown.fromJson(
    await _request('GET', guestToken, '/breakdown') as Map<String, dynamic>,
  );

  Future<Claim> addClaim(
    String guestToken, {
    required String itemId,
    required String participantId,
    required ClaimType claimType,
    required String value,
  }) async {
    final data = await _request(
      'POST',
      guestToken,
      '/items/$itemId/claims',
      data: {
        'participantId': participantId,
        'claimType': claimType.name,
        'value': value,
      },
    );
    return Claim.fromJson(data as Map<String, dynamic>);
  }

  Future<void> removeClaim(String guestToken, String itemId, String claimId) =>
      _request('DELETE', guestToken, '/items/$itemId/claims/$claimId');
}
