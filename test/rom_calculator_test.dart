import 'package:flutter_test/flutter_test.dart';
import 'package:pm_comms_flutterapp/rom_calculator.dart';

void main() {
  group('calculateROM', () {
    test('calculates ROM correctly for valid input', () {
      final result = calculateROM(10, 2);
      expect(result, 24); // 10 * 2 * 1.2
    });

    test('throws ArgumentError when dividing by zero rate', () {
      expect(() => calculateROM(10, 0), throwsArgumentError);
    });

    test('returns negative result for negative hours', () {
      final result = calculateROM(-10, 2);
      expect(result, -24);
    });

    test('returns zero when hours is zero', () {
      final result = calculateROM(0, 5);
      expect(result, 0);
    });

    test('can use a custom risk factor', () {
      final result = calculateROM(10, 2, riskFactor: 1.5);
      expect(result, 30); // 10 * 2 * 1.5
    });
  });
}