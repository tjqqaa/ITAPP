import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';  // Add this import

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFFF0F0F5), // Fondo más claro, típico en iOS
    primaryColor: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.black
      ), // Títulos grandes con fuente de iOS
      displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: Colors.black
      ), // Títulos más pequeños
      bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.normal
      ), // Texto normal
      bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black54
      ), // Texto más pequeño
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30) // Bordes muy redondeados
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 10, // Sombra ligera para el botón
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Bordes suaves
        borderSide: BorderSide(color: Colors.blue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2), // Borde al enfocar el campo
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black), // Íconos en negro
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ), // Título de la app con estilo iOS
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.black54,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.blue,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Colors.blue,
      barBackgroundColor: Colors.white,
      scaffoldBackgroundColor: Color(0xFFF0F0F5), // Fondo similar al de iOS
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF121212), // Fondo oscuro como en iOS dark mode
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.white
      ),
      displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: Colors.white
      ),
      bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70
      ),
      bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white54
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 10,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.blue,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Colors.blue,
      barBackgroundColor: Colors.black,
      scaffoldBackgroundColor: Color(0xFF121212),
    ),
  );
}
