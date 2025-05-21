import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createAppointment({
  required DateTime appointmentDate,
  required String reason,
  required String location,
  required String type,
  required String state,
  required int patientId,
  required int? doctorId,
}) async {
  final url = Uri.parse('https://healtrack-app-backend.azurewebsites.net/appointments/');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'appointment_date': appointmentDate.toIso8601String(),
      'reason': reason,
      'location': location,
      'type': type,
      'state': state,
      'patient': patientId,
      'doctor': doctorId,
    }),
  );

  if (response.statusCode == 201) {
    print('Cita creada correctamente');
  } else {
    print('Error al crear la cita: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');
    throw Exception('No se pudo crear la cita');
  }
}