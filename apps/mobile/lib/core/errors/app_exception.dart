/// Mirrors the backend's `ApiError` shape (`GlobalExceptionHandler`, see
/// docs/api.md): `{ code, message, details? }`. Every screen should catch
/// this rather than a raw `DioException` so error handling stays uniform
/// across features.
class AppException implements Exception {
  const AppException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  /// Not from the API body — a local condition (no connection, timeout,
  /// cancellation, an unparseable response) the Dio interceptor mapped
  /// itself, since the backend never produced an `ApiError` for it.
  factory AppException.local(String code, String message) =>
      AppException(statusCode: 0, code: code, message: message);

  final int statusCode;
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbiddenOrNotFound => statusCode == 403 || statusCode == 404;
  bool get isNetworkError => statusCode == 0;

  @override
  String toString() => 'AppException($statusCode, $code, $message)';
}
