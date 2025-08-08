/// Pure function for ROM calculation logic, extracted for testing and reuse.
/// Throws [ArgumentError] if denominator is zero.
double calculateROM(double hours, double rate, {double riskFactor = 1.2}) {
  if (rate == 0) throw ArgumentError('Rate cannot be zero');
  return hours * rate * riskFactor;
}
