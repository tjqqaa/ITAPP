import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/others/custom_button.dart';
import 'package:project/views/doctors/doctor_appointments_home_screen.dart';
import 'package:project/views/doctors/doctor_patients_screen.dart';
import 'package:project/views/doctors/doctor_preinscriptions_screen.dart';
import 'package:project/views/profile_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorHomeScreen({super.key, required this.doctor});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: widget.doctor),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildCustomButton(
                context: context,
                icon: Icons.person_search,
                label: 'My Patients',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorPatientsScreen(doctor: widget.doctor)),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.calendar_today,
                label: 'Appointments',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorAppointmentsHomeScreen(doctor: widget.doctor)),
                  );
                },
              ),
              buildCustomButton(
                context: context,
                icon: Icons.description,
                label: 'Prescriptions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorPreinscriptionsScreen(doctor: widget.doctor)),
                  );
                },
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
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
