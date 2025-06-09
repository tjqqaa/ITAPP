import 'package:flutter/material.dart';
import 'package:project/models/doctor.dart';
import 'package:project/views/doctors/doctor_appointments_home_screen.dart';
import 'package:project/views/doctors/doctor_patients_screen.dart';
import 'package:project/views/doctors/doctor_preinscriptions_screen.dart';
import 'package:project/views/doctors/doctor_doses.dart';
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

  final List<_HomeFeature> _features = [];

  @override
  void initState() {
    super.initState();

    _features.addAll([
      _HomeFeature(
        icon: Icons.person_search,
        label: 'My Patients',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorPatientsScreen(doctor: widget.doctor)),
          );
        },
      ),
      _HomeFeature(
        icon: Icons.calendar_today,
        label: 'Appointments',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorAppointmentsHomeScreen(doctor: widget.doctor)),
          );
        },
      ),
      _HomeFeature(
        icon: Icons.description,
        label: 'Prescriptions',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorPreinscriptionsScreen(doctor: widget.doctor)),
          );
        },
      ),
      _HomeFeature(
        icon: Icons.medication, // better icon for doses
        label: 'Doses',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorDosesScreen(doctor: widget.doctor)),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GridView.builder(
            itemCount: _features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final feature = _features[index];
              return GestureDetector(
                onTap: feature.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.85), primaryColor.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(feature.icon, size: 48, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        feature.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeFeature {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _HomeFeature({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
