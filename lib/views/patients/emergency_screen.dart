import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  // Función para hacer la llamada de emergencia
  _callEmergency() async {
    const emergencyNumber = '911';  // Número de emergencia (ajustar según el país)
    final url = 'tel:$emergencyNumber';

    if (await canLaunch(url)) {
      await launch(url);  // Lanza la aplicación de teléfono y hace la llamada
    } else {
      throw 'No se pudo realizar la llamada de emergencia';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajustes de Emergencia')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'In case of emergency, press the botton to call emergencies.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _callEmergency,  // Llama a la función para hacer la llamada
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Call Emergencies', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
