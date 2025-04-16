import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class NotificationService {
  // Cambiamos de const a final para el canal de notificación
  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'medication_channel', // id
    'Medication Reminders', // title
    description: 'Channel for medication reminders',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> initialize() async {
    // Inicializar timezone
    tz.initializeTimeZones();

    // Configuración inicial para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración de inicialización
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inicializar el plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          debugPrint('Notification tapped: ${response.payload}');
        }
      },
    );

    // Crear canal de notificación (Android)
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);

    if (kDebugMode) {
      debugPrint('Notification channel created');
    }
  }

  static Future<void> scheduleMedicationReminder({
    required int id,
    required String title,
    required String body,
    Duration delay = const Duration(seconds: 10),
    bool repeatDaily = false,
    String? payload,
  }) async {
    final scheduledDateTime = tz.TZDateTime.now(tz.local).add(delay);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDateTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // Eliminamos uiLocalNotificationDateInterpretation que ya no es necesario
        matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
        payload: payload,
      );

      if (kDebugMode) {
        debugPrint('Notification scheduled successfully for $scheduledDateTime');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error scheduling notification: $e');
      }
      rethrow;
    }
  }

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        ),
      ),
      payload: payload,
    );
  }
}