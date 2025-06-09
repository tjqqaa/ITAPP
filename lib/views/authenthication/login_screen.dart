import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project/views/patients/patient_home_screen.dart';
import 'package:project/views/doctors/doctor_home_screen.dart';
import 'package:project/views/authenthication/signup_screen.dart';
import 'package:project/models/patient.dart';
import 'package:project/models/doctor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://healtrack-app-backend.azurewebsites.net/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      final role = data['role'];
      final id = data['id'];

      if (role != null && id != null) {
        if (role == 'doctor') {
          final doctorResponse = await http.get(
            Uri.parse('https://healtrack-app-backend.azurewebsites.net/doctors/$id'),
          );

          if (doctorResponse.statusCode == 200) {
            final doctor = Doctor.fromJson(jsonDecode(doctorResponse.body));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DoctorHomeScreen(doctor: doctor)),
            );
          } else {
            _showError('Error al obtener datos del doctor');
          }
        } else if (role == 'patient') {
          final patientResponse = await http.get(
            Uri.parse('https://healtrack-app-backend.azurewebsites.net/patients/$id'),
          );

          if (patientResponse.statusCode == 200) {
            final patient = Patient.fromJson(jsonDecode(patientResponse.body));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PatientHomeScreen(patient: patient)),
            );
          } else {
            _showError('Error al obtener datos del paciente');
          }
        } else {
          _showError('Rol de usuario no reconocido');
        }
      } else {
        _showError('Credenciales incorrectas');
      }
    } catch (_) {
      _showError('Error de conexión con el servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.medical_services, size: 64, color: theme.primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome to HealTrack",
                    style: textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text("Log in"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _navigateToSignUp,
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
