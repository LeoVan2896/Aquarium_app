const ppmPerDegree = 17.86;

double degreesToPpm(double degrees) => degrees * ppmPerDegree;

double toPpm(double value, String unit) => switch (unit) {
  'dGH' || 'dKH' => degreesToPpm(value),
  _ => value,
};

String formatNumber(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toString();

// Calendar days, not 24 h blocks, so dates stay put across DST changes.
DateTime addDays(DateTime t, int days) => t.isUtc
    ? DateTime.utc(t.year, t.month, t.day + days, t.hour, t.minute, t.second)
    : DateTime(t.year, t.month, t.day + days, t.hour, t.minute, t.second);
