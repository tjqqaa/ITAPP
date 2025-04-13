import 'package:flutter/material.dart';
import 'package:project/views/authenthication/login_screen.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/doctors/doctor_home_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _selectedRole;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_selectedRole == null || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (_selectedRole == 'Paciente') {
      final patient = Patient(
        id: '1',
        name: 'NombrePaciente',
        surname: 'ApellidoPaciente',
        email: email,
        dateOfBirth: DateTime(1995, 1, 1),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientHomeScreen(patient: patient)),
      );
    } else if (_selectedRole == 'Doctor') {
      final doctor = Doctor(
        id: '2',
        name: 'NombreDoctor',
        surname: 'ApellidoDoctor',
        email: email,
        dateOfBirth: DateTime(1980, 1, 1),
        specialization: 'Medicina General',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorHomeScreen(doctor: doctor)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: const Text("Selecciona tu rol"),
              items: const [
                DropdownMenuItem(value: 'Paciente', child: Text('Paciente')),
                DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
