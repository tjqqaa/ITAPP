import 'package:flutter/material.dart';
import 'package:project/views/patients/patient_home_screen.dart'; // Paciente
import 'package:project/views/doctors/doctor_home_screen.dart';   // Doctor
import 'package:project/views/authenthication/signup_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart'; // Importar modelo de Doctor

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == "doctor@email.com" && password == "123456") {
      // Crear un doctor de prueba
      final doctor = Doctor(
        id: 1,
        name: "Dr. Juan",
        surname: "Gómez",
        email: "doctor@email.com",
        specialization: "Cardiologist", // Usar 'specialization' en lugar de 'specialty'
        dateOfBirth: DateTime(1980, 5, 15), // Añadir la fecha de nacimiento
        username: "juand",
        password: "123456"
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorHomeScreen(doctor: doctor)), // Pasamos el doctor aquí
      );
    } else if (email == "paciente@email.com" && password == "123456") {
      // Crear un paciente de prueba
      final patient = Patient(
        id: 1,
        name: "Juan",
        surname: "Pérez",
        email: "paciente@email.com",
        dateOfBirth: DateTime(1990, 1, 1), // Añadir la fecha de nacimiento
        username: "juan1",
        password: "123456"
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientHomeScreen(patient: patient), // Pasamos el paciente aquí
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido a HealTrack",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Iniciar sesión"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _navigateToSignUp,
                child: const Text("¿No tienes cuenta? Regístrate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
