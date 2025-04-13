import 'package:flutter/material.dart';
import 'package:project/views/patients/patient_home_screen.dart'; // Importar la pantalla PatientHomeScreen
import 'package:project/views/patients/medication_screen.dart'; // Importar pantalla de Medicamentos
import 'package:project/views/patients/appointments_screen_patient.dart'; // Importar pantalla de Citas
import 'package:project/views/profile_screen.dart'; // Importar pantalla de Perfil
import 'package:project/models/patient.dart'; // Importar el modelo de Patient

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

  // Creating a sample Patient object for testing purposes
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

  final List<Widget> _screens = [
    PatientHomeScreen(patient: Patient( // Pass the actual Patient object here
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
    )),
    AppointmentsScreenPatient(patient: widget.patient), // Asegúrate de que esta pantalla esté implementada
    ProfileScreen(user: Patient( // Pass the actual Patient object here
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
    )),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Medicamentos',
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
