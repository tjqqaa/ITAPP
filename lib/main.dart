import 'package:flutter/material.dart';
import 'package:project/views/authenthication/login_screen.dart';

void main() {
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
      home: LoginScreen(), // 🔹 Inicia con la pantalla de Login
    );
  }
}
