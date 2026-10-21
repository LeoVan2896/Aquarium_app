import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

typedef PlannedReminder = ({int id, DateTime at, String title, String body});

abstract interface class ReminderNotifier {
  Future<bool> requestPermission();
  Future<void> replaceAll(List<PlannedReminder> reminders);
  Future<void> sendTest(String tankName);
}

const _testReminderId = 999999;

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    'test_reminders',
    'Test reminders',
    channelDescription: 'Reminders to test your tank water',
  ),
);

class LocalReminderNotifier implements ReminderNotifier {
  LocalReminderNotifier._(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static Future<LocalReminderNotifier> create() async {
    tzdata.initializeTimeZones();
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    return LocalReminderNotifier._(plugin);
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<bool> requestPermission() async {
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return await _android?.requestNotificationsPermission() ?? false;
  }

  // The device's IANA zone name isn't available without another package, so each local
  // wall-clock time is converted to its UTC instant and scheduled one-shot.
  @override
  Future<void> replaceAll(List<PlannedReminder> reminders) async {
    await _plugin.cancelAllPendingNotifications();
    for (final r in reminders) {
      await _plugin.zonedSchedule(
        id: r.id,
        scheduledDate: tz.TZDateTime.from(r.at, tz.UTC),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: r.title,
        body: r.body,
      );
    }
  }

  @override
  Future<void> sendTest(String tankName) => _plugin.zonedSchedule(
    id: _testReminderId,
    scheduledDate: tz.TZDateTime.now(tz.UTC).add(const Duration(seconds: 5)),
    notificationDetails: _details,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: 'Time to test $tankName',
    body: 'This is a test reminder. Real ones arrive on your schedule.',
  );
}
