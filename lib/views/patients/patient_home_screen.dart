import 'package:flutter/material.dart';
import 'package:project/models/patient.dart';
import 'package:project/views/profile_screen.dart';  // Import the ProfileScreen

class PatientHomeScreen extends StatefulWidget {
  final Patient patient;  // Ensure this is a Patient

  const PatientHomeScreen({Key? key, required this.patient}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PatientHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // Pass the patient object to ProfileScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: widget.patient),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your existing widgets here
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
