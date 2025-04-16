import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io'; // Para Platform.isAndroid
import 'package:project/views/authenthication/login_screen.dart';
import 'package:project/services/notification_service.dart';

// Global instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Initialize time zones for scheduling
  tz.initializeTimeZones();

  // Android initialization settings
  const AndroidInitializationSettings androidInitSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Combine platform settings
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
      debugPrint("Notification tapped: ${response.payload}");
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await initNotifications();

  // Initialize notification service (creates channel and requests permissions)
  await NotificationService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealTrack',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: LoginScreen(), // Initial screen
    );
  }
}