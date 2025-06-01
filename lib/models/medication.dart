class Medication {
  final int id;
  final String name;
  final String dosage;
  final int patient; // this is just the patient ID

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.patient,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      patient: json['patient'],
    );
  }
}
