import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> scheduleMedicationReminder({
    required int id,
    required String title,
    required String body,
    Duration delay = const Duration(seconds: 5),
    bool repeatDaily = false,
  }) async {
    final scheduledDateTime = tz.TZDateTime.now(tz.local).add(delay);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDateTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Medication Reminders',
          channelDescription: 'Channel for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
    );
  }
}
