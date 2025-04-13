import 'user.dart';

class Patient extends User {
  final List<String> medications;
  final List<String> appointments;
  final String mood;
  final bool isEmergencyContactNotified;
  final String? emergencyContact;
  final int healthPoints;

  /*raul: ¿Aquí habría que meter una referencia al doctor no?*/

  Patient({
    required String id,
    required String name,
    required String surname,
    required String email,
    String? phoneNumber,
    required DateTime dateOfBirth,
    this.medications = const [],
    this.appointments = const [],
    this.mood = "Neutral",
    this.isEmergencyContactNotified = false,
    this.emergencyContact,
    this.healthPoints = 0,
  }) : super(
    id: id,
    name: name,
    surname: surname,
    email: email,
    phoneNumber: phoneNumber,
    dateOfBirth: dateOfBirth,
  );

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      medications: List<String>.from(map['medications'] ?? []),
      appointments: List<String>.from(map['appointments'] ?? []),
      mood: map['mood'] ?? "Neutral",
      isEmergencyContactNotified: map['isEmergencyContactNotified'] ?? false,
      emergencyContact: map['emergencyContact'],
      healthPoints: map['healthPoints'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'medications': medications,
      'appointments': appointments,
      'mood': mood,
      'isEmergencyContactNotified': isEmergencyContactNotified,
      'emergencyContact': emergencyContact,
      'healthPoints': healthPoints,
    });
    return map;
  }
}
