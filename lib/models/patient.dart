import 'user.dart';

class Patient extends User {
  final List<String> medications;
  final String mood;
  final bool isEmergencyContactNotified;
  final String? emergencyContact;
  final int healthPoints;
  final String? doctorId; // Reference to the assigned doctor

  Patient({
    required String id,
    required String name,
    required String surname,
    required String email,
    String? phoneNumber,
    required DateTime dateOfBirth,
    List<String> appointments = const [],
    this.medications = const [],
    this.mood = "Neutral",
    this.isEmergencyContactNotified = false,
    this.emergencyContact,
    this.healthPoints = 0,
    this.doctorId,
  }) : super(
    id: id,
    name: name,
    surname: surname,
    email: email,
    phoneNumber: phoneNumber,
    dateOfBirth: dateOfBirth,
    appointments: appointments,
  );

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      appointments: List<String>.from(map['appointments'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      mood: map['mood'] ?? "Neutral",
      isEmergencyContactNotified: map['isEmergencyContactNotified'] ?? false,
      emergencyContact: map['emergencyContact'],
      healthPoints: map['healthPoints'] ?? 0,
      doctorId: map['doctorId'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'medications': medications,
      'mood': mood,
      'isEmergencyContactNotified': isEmergencyContactNotified,
      'emergencyContact': emergencyContact,
      'healthPoints': healthPoints,
      'doctorId': doctorId,
    });
    return map;
  }
}
