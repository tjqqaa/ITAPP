from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)
    surname = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    phoneNumber = models.CharField(max_length=15)
    dateOfBirth = models.DateField()

    def __str__(self):
        return f"{self.name} {self.surname}"

class Doctor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='doctor_profile')
    specialization = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.user.name} {self.user.surname} ({self.specialization})"

class Patient(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='patient_profile')
    mood = models.CharField(max_length=100)
    emergencyContact = models.CharField(max_length=15)
    healthPoints = models.IntegerField()
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='patients')

    def __str__(self):
        return f"{self.user.name} {self.user.surname} (Patient of {self.doctor.user.name})"


class Medication(models.Model):
    name = models.CharField(max_length=100)
    dosage = models.CharField(max_length=100)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='medications')

    def __str__(self):
        return f"{self.name} ({self.dosage}) for {self.patient.name}"

class Appointment(models.Model):
    STATE_CHOICES = [
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('cancelled', 'Cancelled'),
        ('completed', 'Completed'),
    ]

    TYPE_CHOICES = [
        ('inPerson', 'In Person'),
        ('online', 'Online'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_appointments')
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='doctor_appointments')
    appointment_date = models.DateTimeField()
    reason = models.TextField()
    ubication = models.CharField(max_length=255, null=True, blank=True)
    type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    state = models.CharField(max_length=10, choices=STATE_CHOICES, default='pending')

    def __str__(self):
        return f"{self.appointment_date} - {self.user.name} with Dr. {self.doctor.name}"
