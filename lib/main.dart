import 'package:flutter/material.dart';
import 'package:project/views/authenthication/login_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// 🔔 Instancia global del plugin de notificaciones
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Inicialización para Android
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inicializa el plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Zona horaria necesaria para notificaciones programadas
  tz.initializeTimeZones();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔐 Necesario antes de async en main
  await initNotifications(); // 🚀 Inicializa notificaciones
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
      home: LoginScreen(), // 🔹 Pantalla inicial
    );
  }
}
