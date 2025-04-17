import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class NotificationService {
  // Definir el canal de notificación
  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'medication_channel', // ID del canal
    'Medication Reminders', // Título del canal
    description: 'Canal para recordatorios de medicación',
    importance: Importance.max, // Notificaciones de alta prioridad
    playSound: true, // Reproducir sonido cuando llegue la notificación
    enableLights: true, // Activar luces al recibir notificación
    enableVibration: true, // Habilitar vibración
  );

  // Inicializar el servicio de notificaciones
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // Configuración de la notificación en Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Ícono de la app

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          print('Notificación presionada: ${response.payload}');
        }
      },
    );

    // Registrar el canal de notificación (solo la primera vez que se ejecuta la app)
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  // Programar el recordatorio de medicación
  static Future<void> scheduleMedicationReminder({
    required int id,
    required String title,
    required String body,
    Duration delay = const Duration(seconds: 10),
  }) async {
    var scheduledNotificationDateTime = DateTime.now().add(delay);

    // Asegúrate de que la notificación se programe en la zona horaria local
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local), // Programar en zona horaria local
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel', // ID del canal
          'Medication Reminders', // Nombre del canal
          channelDescription: 'Canal para recordatorios de medicación', // Descripción
          importance: Importance.max, // Alta prioridad
          priority: Priority.high, // Alta prioridad
          playSound: true, // Reproducir sonido
          enableVibration: true, // Habilitar vibración
          enableLights: true, // Activar luces
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact, // Programar la notificación de forma exacta
      payload: 'Medicamento ID: $id', // Puedes incluir un payload para identificar la notificación
    );
  }
}
