import 'user.dart';

class Doctor extends User {
  final String specialization;
  final List<String> patients;

  Doctor({
    required String id,
    required String name,
    required String surname,
    required String email,
    String? phoneNumber,
    required DateTime dateOfBirth,
    List<String> appointments = const [],
    this.patients = const [],
    required this.specialization,
  }) : super(
    id: id,
    name: name,
    surname: surname,
    email: email,
    phoneNumber: phoneNumber,
    dateOfBirth: dateOfBirth,
    appointments: appointments, // ya está en User
  );

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      appointments: List<String>.from(map['appointments'] ?? []),
      patients: List<String>.from(map['patients'] ?? []),
      specialization: map['specialization'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'specialization': specialization,
      'patients': patients,
    });
    return map;
  }
}
