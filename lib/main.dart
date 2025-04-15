import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:project/views/authenthication/login_screen.dart';

// 🔔 Global instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // 🕐 Required for scheduling notifications
  tz.initializeTimeZones();

  // 🔧 Android initialization settings
  const AndroidInitializationSettings androidInitSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // 💡 Combine platform settings
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  // 🚀 Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Optional: Handle what happens when tapping the notification
      debugPrint("Notification tapped: ${response.payload}");
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications(); // 🚀 Initialize notifications
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
      home: LoginScreen(), // 🔹 Initial screen
    );
  }
}
