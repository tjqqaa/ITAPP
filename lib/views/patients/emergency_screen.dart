import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  // Función para realizar la llamada de emergencia
  void _callEmergency() async {
    const emergencyNumber = '911'; // Puedes cambiarlo por otro número
    final Uri url = Uri.parse('tel:$emergencyNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'No se pudo realizar la llamada de emergencia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color redAccent = Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: redAccent,
        title: const Text(
          'Emergency Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, size: 100, color: redAccent),
            const SizedBox(height: 20),
            const Text(
              'Emergency Alert',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you are in a critical situation, press the button below to immediately contact emergency services.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _callEmergency,
              icon: const Icon(Icons.phone_in_talk),
              label: const Text('Call Emergency'),
              style: ElevatedButton.styleFrom(
                backgroundColor: redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
