enum AppointmentState {
  pending,
  confirmed,
  cancelled,
  completed
}

enum AppointmentType {
  inPerson,
  online
}

class Appointment {
  int id;
  int userId;
  int doctorId;
  DateTime appointmentDate;
  String reason;
  String? ubication;
  AppointmentType type;
  AppointmentState state;

  Appointment({required this.id, required this.userId, required this.doctorId, required this.appointmentDate, 
  required this.reason, this.ubication, required this.type, required this.state});

  /// Método para convertir el modelo a un mapa (útil para Firebase o almacenamiento local)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'reason': reason,
      'ubication': ubication,
      'type': type.name, // We cast the enum to String
      'state': state.name, // We cast the enum to String
    };
  }

  /// Método para crear un objeto `User` desde un mapa (útil para Firebase o almacenamiento local)
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      userId: map['patient'],
      doctorId: map['doctor'],
      appointmentDate: DateTime.parse(map['appointment_date']),
      reason: map['reason'],
      ubication: map['location'] ?? "",
      type: AppointmentType.values.firstWhere(
        (e) => e.name == map['type'], //we cast the Strings from the database into AppointmentType type values
        orElse: () => AppointmentType.inPerson //if no correct value is found we put the in-person type
      ),
      state: AppointmentState.values.firstWhere(
        (e) => e.name == map['state'],
        orElse: () => AppointmentState.pending
      ),
    );
  }
}