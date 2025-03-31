import 'package:flutter/material.dart';
import 'package:project/views/home_screen.dart'; // Importar la pantalla HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealTrack',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Pantalla de inicio que ya tienes configurada
    // Puedes agregar más pantallas aquí cuando las tengas, como:
    // MedicationsScreen(),
    // AppointmentsScreen(),
    // ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          // Descomenta los siguientes elementos cuando agregues más pantallas
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.medical_services),
          //   label: 'Medicamentos',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.calendar_today),
          //   label: 'Citas',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Perfil',
          // ),
        ],
      ),
    );
  }
}
