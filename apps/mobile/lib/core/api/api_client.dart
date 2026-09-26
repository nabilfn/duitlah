import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../config/env.dart';
import '../errors/app_exception.dart';
import '../storage/secure_cookie_storage.dart';
import '../storage/secure_storage.dart';

/// The one Dio client every repository goes through. Mirrors
/// `apps/web/src/lib/api-client.ts`'s contract exactly (same base URL
/// convention, same Bearer-header-plus-cookie auth, same 401-refresh-retry
/// dance, same `ApiError` shape) so the mobile app and the web companion
/// are indistinguishable to the backend beyond a header.
///
/// - Auth: an in-memory access token (never persisted — same reasoning as
///   `auth-store.ts`) plus a [PersistCookieJar] backed by [SecureCookieStorage]
///   so the httpOnly-equivalent refresh cookie survives app restarts
///   encrypted at rest, matching docs/security.md's mobile-auth strategy.
/// - Errors: every non-2xx response or transport failure surfaces as an
///   [AppException], never a raw [DioException] — callers shouldn't need
///   dio-specific catch clauses.
/// - Retries: only ever automatic for GET (idempotent by definition).
///   Financial writes (POST/PUT/PATCH/DELETE) are never blindly retried by
///   this client; callers that need at-most-once-effectively-exactly-once
///   semantics pass an `idempotencyKey`.
class ApiClient {
  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (_) => true, // handled uniformly below
      ),
    );

    _cookieJar = PersistCookieJar(
      storage: SecureCookieStorage(_secureStorage),
      ignoreExpires: false,
    );
    _dio.interceptors.add(CookieManager(_cookieJar));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final skipAuth = options.extra['skipAuth'] == true;
          if (!skipAuth && _accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          final idempotencyKey = options.extra['idempotencyKey'] as String?;
          if (idempotencyKey != null) {
            options.headers['Idempotency-Key'] = idempotencyKey;
          }
          handler.next(options);
        },
      ),
    );
  }

  late final Dio _dio;
  late final PersistCookieJar _cookieJar;
  final SecureStorage _secureStorage;

  String? _accessToken;

  /// Guards concurrent 401s so they share one in-flight `/auth/refresh`
  /// call instead of each racing to rotate the same cookie — same reason
  /// as the `refreshPromise` guard in `api-client.ts`.
  Future<String>? _refreshInFlight;

  /// Set by the auth layer; invoked when a refresh attempt itself fails,
  /// meaning the session is truly over (not just the access token expired).
  void Function()? onSessionExpired;

  void setAccessToken(String? token) => _accessToken = token;

  String? get accessToken => _accessToken;

  Future<void> clearSession() async {
    _accessToken = null;
    await _cookieJar.deleteAll();
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    bool skipAuth = false,
  }) => _send(
    () => _dio.get(
      path,
      queryParameters: query,
      options: Options(extra: {'skipAuth': skipAuth}),
    ),
  );

  Future<dynamic> post(
    String path, {
    dynamic data,
    bool skipAuth = false,
    String? idempotencyKey,
  }) => _send(
    () => _dio.post(
      path,
      data: data,
      options: Options(
        extra: {'skipAuth': skipAuth, 'idempotencyKey': idempotencyKey},
      ),
    ),
  );

  Future<dynamic> put(
    String path, {
    dynamic data,
    bool skipAuth = false,
    String? idempotencyKey,
  }) => _send(
    () => _dio.put(
      path,
      data: data,
      options: Options(
        extra: {'skipAuth': skipAuth, 'idempotencyKey': idempotencyKey},
      ),
    ),
  );

  Future<dynamic> patch(
    String path, {
    dynamic data,
    bool skipAuth = false,
    String? idempotencyKey,
  }) => _send(
    () => _dio.patch(
      path,
      data: data,
      options: Options(
        extra: {'skipAuth': skipAuth, 'idempotencyKey': idempotencyKey},
      ),
    ),
  );

  Future<dynamic> delete(String path, {dynamic data, bool skipAuth = false}) =>
      _send(
        () => _dio.delete(
          path,
          data: data,
          options: Options(extra: {'skipAuth': skipAuth}),
        ),
      );

  /// Multipart upload (receipt photos) — a separate path from [post]
  /// because it needs `onSendProgress` and a `FormData` body, mirroring
  /// why `receipt-scan-client.ts` is a standalone function on the web side
  /// rather than going through the shared JSON client.
  Future<dynamic> uploadFile(
    String path, {
    required String fieldName,
    required String filePath,
    required String fileName,
    void Function(int sent, int total)? onProgress,
  }) => _send(
    () => _dio.post(
      path,
      data: FormData.fromMap({
        fieldName: MultipartFile.fromFileSync(filePath, filename: fileName),
      }),
      onSendProgress: onProgress,
    ),
  );

  /// Same shape as [uploadFile] but for endpoints needing more than one file
  /// part and/or extra query parameters alongside it (AutoTrack's statement
  /// import — `accountId` — and the Receipt Vault's batch upload —
  /// `purpose`/`folder`/`tags`). Spring resolves a plain `@RequestParam` from
  /// either the query string or a multipart form field, so sending these as
  /// query parameters here is exactly as valid as a form field would be,
  /// without needing a second FormData-field code path.
  Future<dynamic> uploadFiles(
    String path, {
    required String fieldName,
    required List<String> filePaths,
    Map<String, dynamic>? query,
    void Function(int sent, int total)? onProgress,
  }) => _send(
    () => _dio.post(
      path,
      queryParameters: query,
      data: FormData.fromMap({
        fieldName: [
          for (final filePath in filePaths)
            MultipartFile.fromFileSync(
              filePath,
              filename: filePath.split('/').last,
            ),
        ],
      }),
      onSendProgress: onProgress,
    ),
  );

  /// Binary downloads (exports) — a normal [get] would try to JSON-decode a CSV/XLSX/PDF/ZIP body
  /// and fail; this forces Dio's raw-bytes response type instead.
  Future<List<int>> downloadBytes(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final data = await _send(
      () => _dio.get(
        path,
        queryParameters: query,
        options: Options(responseType: ResponseType.bytes),
      ),
    );
    return data as List<int>;
  }

  Future<dynamic> _send(Future<Response> Function() request) async {
    Response response;
    try {
      response = await request();
    } on DioException catch (e) {
      throw _mapTransportError(e);
    }

    final requestOptions = response.requestOptions;
    final wasAuthenticated =
        requestOptions.extra['skipAuth'] != true && _accessToken != null;

    if (response.statusCode == 401 && wasAuthenticated) {
      try {
        await _refreshAccessToken();
      } catch (_) {
        onSessionExpired?.call();
        throw const AppException(
          statusCode: 401,
          code: 'SESSION_EXPIRED',
          message: 'Your session has expired. Please sign in again.',
        );
      }
      try {
        response = await request();
      } on DioException catch (e) {
        throw _mapTransportError(e);
      }
    }

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data;
    }
    throw _mapErrorResponse(response);
  }

  Future<String> _refreshAccessToken() {
    return _refreshInFlight ??= () async {
      try {
        final response = await _dio.post(
          '/api/v1/auth/refresh',
          options: Options(extra: {'skipAuth': true}),
        );
        if (response.statusCode == null ||
            response.statusCode! < 200 ||
            response.statusCode! >= 300) {
          throw _mapErrorResponse(response);
        }
        final token =
            (response.data as Map<String, dynamic>)['accessToken'] as String;
        _accessToken = token;
        return token;
      } on DioException catch (e) {
        throw _mapTransportError(e);
      } finally {
        _refreshInFlight = null;
      }
    }();
  }

  AppException _mapErrorResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return AppException(
        statusCode: response.statusCode ?? 0,
        code: (data['code'] as String?) ?? 'UNKNOWN_ERROR',
        message: (data['message'] as String?) ?? 'Something went wrong.',
        details: data['details'] as Map<String, dynamic>?,
      );
    }
    return AppException(
      statusCode: response.statusCode ?? 0,
      code: 'UNKNOWN_ERROR',
      message: response.statusMessage ?? 'Something went wrong.',
    );
  }

  AppException _mapTransportError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return AppException.local(
        'TIMEOUT',
        'The request timed out. Please try again.',
      );
    }
    if (e.type == DioExceptionType.connectionError ||
        e.error is SocketException) {
      return AppException.local(
        'NO_CONNECTION',
        'Connection required. Check your internet and try again.',
      );
    }
    if (e.type == DioExceptionType.cancel) {
      return AppException.local('CANCELLED', 'Request was cancelled.');
    }
    return AppException.local('UNKNOWN_ERROR', 'Something went wrong.');
  }
}
