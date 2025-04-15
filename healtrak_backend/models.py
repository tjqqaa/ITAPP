from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)
    surname = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    phoneNumber = models.CharField(max_length=15)
    dateOfBirth = models.DateField()

class Doctor(User):
    specialization = models.CharField(max_length=100)

class Patient(User):
    mood = models.CharField(max_length=100)
    emergencyContact = models.CharField(max_length=15)
    healthPoints = models.IntegerField()
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='patients')

class Medication(models.Model):
    name = models.CharField(max_length=100)
    dosage = models.CharField(max_length=100)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='medications')
