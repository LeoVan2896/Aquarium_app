import 'units.dart';

typedef TimeOfDayHm = ({int hour, int minute});

TimeOfDayHm? parseTimeOfDay(String text) {
  final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(text.trim());
  if (match == null) return null;
  final hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  if (hour > 23 || minute > 59) return null;
  return (hour: hour, minute: minute);
}

String formatTimeOfDay(TimeOfDayHm t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

// Anchored on the last test so "every N days" means N days after you actually tested.
List<DateTime> upcomingReminders({
  required int everyNDays,
  required TimeOfDayHm time,
  required DateTime now,
  DateTime? lastTestAt,
  int count = 6,
}) {
  DateTime atTime(DateTime day) => day.isUtc
      ? DateTime.utc(day.year, day.month, day.day, time.hour, time.minute)
      : DateTime(day.year, day.month, day.day, time.hour, time.minute);

  var next = lastTestAt == null
      ? atTime(now)
      : addDays(atTime(lastTestAt), everyNDays);
  if (!next.isAfter(now)) {
    next = atTime(now);
    if (!next.isAfter(now)) next = addDays(next, 1);
  }
  return [for (var i = 0; i < count; i++) addDays(next, i * everyNDays)];
}
