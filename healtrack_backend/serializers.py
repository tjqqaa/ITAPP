from rest_framework import serializers
from healtrack_backend.models import User,Doctor,Patient,Appointment,Medication

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class DoctorSerializer(serializers.ModelSerializer):
    user=UserSerializer()

    class Meta:
        model = Doctor
        fields = '__all__'

class PatientSerializer(serializers.ModelSerializer):
    user=UserSerializer()
    doctor=DoctorSerializer()
    class Meta:
        model = Patient
        fields = '__all__'

class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = '__all__'

class MedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = '__all__'