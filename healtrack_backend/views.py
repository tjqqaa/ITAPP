from healtrack_backend.models import Doctor, Patient, Appointment, Medication
from healtrack_backend.serializers import DoctorSerializer, PatientSerializer, AppointmentSerializer, \
    MedicationSerializer
from rest_framework.generics import ListAPIView

class DoctorListView(ListAPIView):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer

class PatientListView(ListAPIView):
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer

class AppointmentListView(ListAPIView):
    queryset = Appointment.objects.all()
    serializer_class = AppointmentSerializer

class MedicationListView(ListAPIView):
    queryset = Medication.objects.all()
    serializer_class = MedicationSerializer
