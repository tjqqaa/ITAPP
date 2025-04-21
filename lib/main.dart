import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io'; // For Platform.isAndroid
import 'package:project/views/authenthication/login_screen.dart';
import 'package:project/services/notification_service.dart';
import 'package:project/others/theme.dart';

// Global instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Initialize notifications
Future<void> initNotifications() async {
  // Initialize time zones for scheduling notifications
  tz.initializeTimeZones();

  // Android initialization settings for notifications
  const AndroidInitializationSettings androidInitSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

  // Combine platform-specific initialization settings
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  // Initialize the notification plugin
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap (you can perform actions here)
      debugPrint("Notification tapped: ${response.payload}");
    },
  );
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications and custom notification service
  await initNotifications(); // Initialize notification settings
  await NotificationService.initialize(); // Initialize custom notification service

  // Run the app
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
      home: LoginScreen(), // Initial screen (login screen)
    );
  }
}


