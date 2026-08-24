import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/errors/app_exception.dart';

void main() {
  group('AppException', () {
    test('local() marks a client-side condition with statusCode 0', () {
      final e = AppException.local('NO_CONNECTION', 'Connection required.');
      expect(e.statusCode, 0);
      expect(e.isNetworkError, isTrue);
      expect(e.isUnauthorized, isFalse);
    });

    test('isUnauthorized / isForbiddenOrNotFound reflect the backend status code', () {
      const unauthorized = AppException(statusCode: 401, code: 'SESSION_EXPIRED', message: 'x');
      const notFound = AppException(statusCode: 404, code: 'NOT_FOUND', message: 'x');
      const forbidden = AppException(statusCode: 403, code: 'FORBIDDEN', message: 'x');
      const ok = AppException(statusCode: 200, code: 'OK', message: 'x');

      expect(unauthorized.isUnauthorized, isTrue);
      expect(notFound.isForbiddenOrNotFound, isTrue);
      expect(forbidden.isForbiddenOrNotFound, isTrue);
      expect(ok.isUnauthorized, isFalse);
      expect(ok.isForbiddenOrNotFound, isFalse);
    });
  });
}
