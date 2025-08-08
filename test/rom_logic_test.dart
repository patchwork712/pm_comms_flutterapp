import 'package:flutter_test/flutter_test.dart';

// Standalone ROM calculation logic for unit test
// (Normally, you would refactor this into a separate file for easier testing)
double calculateRom(double hours, double rate, double riskFactor) {
  if (hours > 0 && rate > 0) {
    return hours * rate * riskFactor;
  }
  return 0;
}

void main() {
  group('ROM Calculation', () {
    test('returns correct ROM value for valid input', () {
      expect(calculateRom(10, 100, 1.2), 1200);
      expect(calculateRom(5, 200, 1.5), 1500);
    });

    test('returns 0 for zero or negative input', () {
      expect(calculateRom(0, 100, 1.2), 0);
      expect(calculateRom(10, 0, 1.2), 0);
      expect(calculateRom(-5, 100, 1.2), 0);
    });
  });
}
