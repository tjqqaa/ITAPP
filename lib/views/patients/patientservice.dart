import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientService {
  static const String baseUrl = 'https://healtrack-app-backend.azurewebsites.net';

  /// Updates the patient data using the full data map (including healthPoints)
  /// [patientId] is the ID of the patient
  /// [patientData] is the Map<String, dynamic> from toApiMapMood()
  /// Returns true if the update was successful.
  static Future<bool> updatePatientData(int patientId, Map<String, dynamic> patientData) async {
    final url = Uri.parse('$baseUrl/patients/$patientId/');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(patientData),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to update patient data.');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Request body sent: ${json.encode(patientData)}');
        return false;
      }
    } catch (e) {
      print('Exception during update: $e');
      return false;
    }
  }

}
