import 'package:aquarium_app/domain/reminder_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const nine = (hour: 9, minute: 0);

  test('parses and formats HH:mm', () {
    expect(parseTimeOfDay('09:05'), (hour: 9, minute: 5));
    expect(parseTimeOfDay('24:00'), isNull);
    expect(parseTimeOfDay('9am'), isNull);
    expect(formatTimeOfDay((hour: 7, minute: 30)), '07:30');
  });

  test('with no test yet, starts at the next 9:00', () {
    final times = upcomingReminders(
      everyNDays: 2,
      time: nine,
      now: DateTime.utc(2026, 10, 21, 10),
      count: 3,
    );
    expect(times, [
      DateTime.utc(2026, 10, 22, 9),
      DateTime.utc(2026, 10, 24, 9),
      DateTime.utc(2026, 10, 26, 9),
    ]);
  });

  test('counts N days from the last test', () {
    final times = upcomingReminders(
      everyNDays: 2,
      time: nine,
      now: DateTime.utc(2026, 10, 21, 10),
      lastTestAt: DateTime.utc(2026, 10, 20, 18),
      count: 2,
    );
    expect(times, [
      DateTime.utc(2026, 10, 22, 9),
      DateTime.utc(2026, 10, 24, 9),
    ]);
  });

  test('when overdue, reminds at the next 9:00', () {
    final morning = upcomingReminders(
      everyNDays: 2,
      time: nine,
      now: DateTime.utc(2026, 10, 21, 8),
      lastTestAt: DateTime.utc(2026, 10, 10),
      count: 1,
    );
    final afternoon = upcomingReminders(
      everyNDays: 2,
      time: nine,
      now: DateTime.utc(2026, 10, 21, 14),
      lastTestAt: DateTime.utc(2026, 10, 10),
      count: 1,
    );
    expect(morning.single, DateTime.utc(2026, 10, 21, 9));
    expect(afternoon.single, DateTime.utc(2026, 10, 22, 9));
  });

  test('keeps the wall-clock time across a DST change', () {
    final times = upcomingReminders(
      everyNDays: 1,
      time: nine,
      now: DateTime(2026, 10, 31, 10),
      count: 2,
    );
    expect(times, [DateTime(2026, 11, 1, 9), DateTime(2026, 11, 2, 9)]);
  });
}
