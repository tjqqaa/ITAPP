class User {
  String id;
  String name;
  String email;
  String? phoneNumber;
  DateTime dateOfBirth;
  List<String> medications; // Lista de medicamentos que toma el usuario
  List<String> appointments; // Lista de citas médicas
  String mood; // Estado de ánimo del usuario (Ejemplo: "Feliz", "Estresado", etc.)
  bool isEmergencyContactNotified; // Si se ha activado la alerta de emergencia
  String? emergencyContact; // Número de contacto de emergencia
  int healthPoints; // Puntos de gamificación por cumplimiento de medicación

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.dateOfBirth,
    this.medications = const [],
    this.appointments = const [],
    this.mood = "Neutral",
    this.isEmergencyContactNotified = false,
    this.emergencyContact,
    this.healthPoints = 0,
  });

  /// Método para convertir el modelo a un mapa (útil para Firebase o almacenamiento local)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'medications': medications,
      'appointments': appointments,
      'mood': mood,
      'isEmergencyContactNotified': isEmergencyContactNotified,
      'emergencyContact': emergencyContact,
      'healthPoints': healthPoints,
    };
  }

  /// Método para crear un objeto `User` desde un mapa (útil para Firebase o almacenamiento local)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
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
}
