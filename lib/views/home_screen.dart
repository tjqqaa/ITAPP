import 'package:flutter/material.dart';
import 'package:project/models/user.dart';

class HomeScreen extends StatelessWidget {
  final User user = User(
    id: "12345",
    name: "Juan Pérez",
    email: "juan.perez@example.com",
    dateOfBirth: DateTime(1990, 5, 15),
    medications: ["Paracetamol", "Insulina"],
    appointments: ["Cita con cardiólogo", "Control de diabetes"],
    mood: "Feliz",
    healthPoints: 120,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HealTrack"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications page (to be implemented)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hola, ${user.name} 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Estado de ánimo: ${user.mood}",
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),

            // Medication Section
            Text(
              "📌 Medicamentos Pendientes:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...user.medications.map((med) => ListTile(
              leading: Icon(Icons.medication, color: Colors.redAccent),
              title: Text(med),
            )),
            SizedBox(height: 20),

            // Appointments Section
            Text(
              "📅 Próximas Citas Médicas:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...user.appointments.map((appt) => ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.green),
              title: Text(appt),
            )),
            SizedBox(height: 20),

            // Health Points
            Center(
              child: Column(
                children: [
                  Text("🎯 Puntos de Salud: ${user.healthPoints}",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to health tracking page (to be implemented)
                    },
                    child: Text("Ver Más"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
