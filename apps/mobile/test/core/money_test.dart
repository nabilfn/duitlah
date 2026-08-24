import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/utils/money.dart';

void main() {
  group('Money', () {
    test('format renders a two-decimal amount with currency prefix', () {
      expect(Money.format('12.5'), 'RM 12.50');
      expect(Money.format('0'), 'RM 0.00');
      expect(Money.format('1234.999'), 'RM 1235.00');
    });

    test('format never fabricates a value for unparseable input', () {
      expect(Money.format('not-a-number'), 'RM 0.00');
    });

    test('plain omits the currency prefix', () {
      expect(Money.plain('7'), '7.00');
    });

    test('isPositive/isNegative read sign without performing arithmetic', () {
      expect(Money.isPositive('10.00'), isTrue);
      expect(Money.isPositive('-10.00'), isFalse);
      expect(Money.isNegative('-0.01'), isTrue);
      expect(Money.isNegative('0'), isFalse);
    });
  });
}
