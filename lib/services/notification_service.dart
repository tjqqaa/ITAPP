import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class NotificationService {
  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'medication_channel',
    'Medication Reminders',
    description: 'Canal para recordatorios de medicación',
    importance: Importance.max,
    playSound: true,
    enableLights: true,
    enableVibration: true,
  );

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          debugPrint('Notificación presionada: ${response.payload}');
        }
      },
    );

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  // Notificación simple con un pequeño delay
  static Future<void> showMedicationReminder({
    required int id,
    required String title,
    required String body,
    Duration delay = const Duration(seconds: 0),
  }) async {
    if (delay.inSeconds > 0) {
      await Future.delayed(delay);
    }

    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_channel',
        'Medication Reminders',
        channelDescription: 'Canal para recordatorios de medicación',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: 'Medicamento ID: $id',
    );
  }
}
