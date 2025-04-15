from django.db import models
from django.contrib.postgres.fields import ArrayField

class User(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    surname = models.CharField(max_length=100)
    email = models.EmailField()
    phoneNumber = models.IntegerField()
    dateOfBirth = models.DateField()

class Doctor(User):
    specialization = models.CharField(max_length=100)
    patients = ArrayField(models.ForeignKey('Patient', on_delete=models.CASCADE))


class Patient(User):
    medications = ArrayField(models.IntegerField(), blank=True, default=list)
    mood = models.CharField(max_length=100)
    emergencyContact = models.IntegerField()
    healthPoints = models.IntegerField()
    doctor_id = models.ForeignKey(Doctor, on_delete=models.CASCADE)

