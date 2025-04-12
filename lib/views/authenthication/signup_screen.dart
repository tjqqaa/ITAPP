import 'package:flutter/material.dart';
import 'package:project/main.dart';
import 'package:project/views/authenthication/login_screen.dart';
import 'package:project/views/patients/patient_home_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulamos que el registro fue exitoso
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Registrarse'),
            ),
            TextButton(
              onPressed: () {
                // Si ya tiene cuenta, lo enviamos al Login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
