import 'user.dart';

class Patient extends User {
  final List<String> medications;
  final String mood;
  final bool isEmergencyContactNotified;
  final String? emergencyContact;
  final int healthPoints;
  final int? doctorId; // Reference to the assigned doctor

  Patient({
    required super.id,
    required super.name,
    required super.surname,
    required super.email,
    super.phoneNumber,
    required super.dateOfBirth,
    super.appointments,
    this.medications = const [],
    this.mood = "Neutral",
    this.isEmergencyContactNotified = false,
    this.emergencyContact,
    this.healthPoints = 0,
    this.doctorId,
    required super.username,
    required super.password
  });
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? 0,
      name: map['first_name'] ?? '',
      surname: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dateOfBirth: DateTime.tryParse(map['birth_date'] ?? '') ?? DateTime(2000),
      appointments: map['appointments'] != null
          ? List<String>.from(map['appointments'])
          : [],
      medications: map['medications'] != null
          ? List<String>.from(map['medications'])
          : [],
      mood: map['mood'] ?? 'Neutral',
      isEmergencyContactNotified: map['isEmergencyContactNotified'] ?? false,
      emergencyContact: map['emergency_contact'],
      healthPoints: map['health_points'] ?? 0,
      doctorId: map['doctor'],
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }
  factory Patient.fromJson(Map<String, dynamic> json) => Patient.fromMap(json);


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



  Map<String, dynamic> toApiMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'birth_date': dateOfBirth.toIso8601String(),
      'phone_number': phoneNumber,
      'first_name': name,
      'last_name': surname,
      'mood': mood,
      'emergency_contact': emergencyContact,
      'health_points': healthPoints,
      'doctor': doctorId,
    };
  }




}
