import 'package:flutter/material.dart';
import 'package:project/views/authenthication/login_screen.dart';
import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/doctors/doctor_home_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _selectedRole;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _specializationController = TextEditingController(); // only for doctor
  final _emergencyContactController = TextEditingController(); // only for patient

  final String baseUrl = "https://healtrack-app-backend.azurewebsites.net/";

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();

    if (_selectedRole == null ||
        email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        surname.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty ||
        (_selectedRole == 'Doctor' && _specializationController.text.trim().isEmpty) ||
        (_selectedRole == 'Paciente' && _emergencyContactController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    try {
      if (_selectedRole == 'Paciente') {
        final response = await http.post(
          Uri.parse("${baseUrl}patients/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": name,
            "surname": surname,
            "email": email,
            "phoneNumber": phone,
            "dateOfBirth": dob,
            "mood": "Neutral",
            "emergencyContact": _emergencyContactController.text.trim(),
            "healthPoints": 0,
            "doctor": 0,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final patient = Patient.fromMap(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PatientHomeScreen(patient: patient)),
          );
        } else {
          throw Exception('Error al registrar paciente. Código: ${response.statusCode}');
        }
      } else if (_selectedRole == 'Doctor') {
        final response = await http.post(
          Uri.parse("${baseUrl}doctors/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": name,
            "surname": surname,
            "email": email,
            "phoneNumber": phone,
            "dateOfBirth": dob,
            "specialization": _specializationController.text.trim(),
            "doctor": 0,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final doctor = Doctor.fromMap(data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DoctorHomeScreen(doctor: doctor)),
          );
        } else {
          // Imprimir el cuerpo de la respuesta para saber más sobre el error
          print("Error al registrar doctor. Código: ${response.statusCode}");
          print("Respuesta del servidor: ${response.body}");
          throw Exception('Error al registrar doctor. Código: ${response.statusCode}');
        }

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro fallido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: _surnameController, decoration: const InputDecoration(labelText: 'Apellido')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo electrónico')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
            TextField(controller: _dobController, decoration: const InputDecoration(labelText: 'Fecha de nacimiento (YYYY-MM-DD)')),
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
            const SizedBox(height: 10),
            if (_selectedRole == 'Paciente')
              TextField(
                controller: _emergencyContactController,
                decoration: const InputDecoration(labelText: 'Contacto de emergencia'),
              ),
            if (_selectedRole == 'Doctor')
              TextField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Especialización'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
