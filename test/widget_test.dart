import 'package:flutter/material.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/patients/appointments_screen_patient.dart';
import 'package:project/views/profile_screen.dart';
import 'package:project/models/patient.dart';

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

  // A sample patient object for test/demo purposes
  final Patient patient = Patient(
    id: '1',
    name: 'Juan',
    surname: 'Pérez',
    email: 'juan.perez@example.com',
    dateOfBirth: DateTime(1990, 1, 1),
    phoneNumber: '1234567890',
    medications: [],
    mood: 'Good',
    emergencyContact: 'Jane Pérez',
    healthPoints: 100,
  );

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      PatientHomeScreen(patient: patient),
      AppointmentsScreenPatient(patient: patient),
      // You can add MedicationScreen here later if implemented
      ProfileScreen(user: patient),
    ];
  }

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
