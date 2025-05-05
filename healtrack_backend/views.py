from django.contrib.auth import authenticate
from django.db import IntegrityError
from drf_spectacular.utils import OpenApiResponse, extend_schema
from rest_framework.exceptions import ValidationError
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, generics
from healtrack_backend.models import Doctor, Patient, Appointment, Medication
from healtrack_backend.serializers import DoctorSerializer, PatientRegisterSerializer, AppointmentSerializer, \
    MedicationSerializer, PatientSerializer, DoctorRegisterSerializer, UserSerializer
from rest_framework.generics import ListAPIView


def test_error(request):
    raise Exception("Testowy wyjątek 500")


@extend_schema(
    responses={
201: OpenApiResponse(response=PatientRegisterSerializer, description="Patient registered successfully."),
        400: OpenApiResponse(description="Username already exists")
    }
)
class PatientRegisterView(APIView):
    serializer_class = PatientRegisterSerializer
    def post(self, request):
        serializer = PatientRegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            serializer.save()
        except IntegrityError:
            raise ValidationError({
                "error": "Username already exists",
                "code": "USERNAME_EXISTS"
            })
        return Response({"message": "Patient registered successfully"}, status=status.HTTP_201_CREATED)


@extend_schema(
    responses={
        201: OpenApiResponse(response=DoctorRegisterSerializer, description="Doctor registered successfully."),
        400: OpenApiResponse(description="Username already exists")
    }
)
class DoctorRegisterView(APIView):
    serializer_class = DoctorRegisterSerializer
    def post(self, request):
        serializer = DoctorRegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            serializer.save()
        except IntegrityError:
            raise ValidationError({
                "error": "Username already exists",
                "code": "USERNAME_EXISTS"
            })
        return Response({"message": "Doctor registered successfully"}, status=status.HTTP_201_CREATED)


class SimpleLoginView(APIView):
    serializer_class = UserSerializer
    def post(self, request):
        username = request.data.get("username")
        password = request.data.get("password")

        user = authenticate(username=username, password=password)

        if user is not None:
            return Response({"message": "Logged in successfully"}, status=status.HTTP_200_OK)
        return Response({"error": "Incorrect username or password"}, status=status.HTTP_401_UNAUTHORIZED)


class DoctorListCreateView(APIView):
    serializer_class = DoctorSerializer

    def get(self, request):
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = DoctorSerializer(data=request.data)
        if serializer.is_valid():
            doctor = serializer.save()
            return Response(DoctorSerializer(doctor).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PatientListCreateView(APIView):
    serializer_class = PatientSerializer

    def get(self, request):
        patients = Patient.objects.all()
        serializer = PatientSerializer(patients, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = PatientSerializer(data=request.data)
        if serializer.is_valid():
            patient = serializer.save()
            return Response(PatientSerializer(patient).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AppointmentListCreateView(APIView):
    serializer_class = AppointmentSerializer

    def get(self, request):
        appointments = Appointment.objects.all()
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = AppointmentSerializer(data=request.data)
        if serializer.is_valid():
            appointment = serializer.save()
            return Response(AppointmentSerializer(appointment).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MedicationListCreateView(APIView):
    serializer_class = MedicationSerializer

    def get(self, request):
        medications = Medication.objects.all()
        serializer = MedicationSerializer(medications, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = MedicationSerializer(data=request.data)
        if serializer.is_valid():
            medication = serializer.save()
            return Response(MedicationSerializer(medication).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DoctorDetailView(APIView):
    serializer_class = DoctorSerializer

    def get(self, request, pk):
        doctor = Doctor.objects.get(pk=pk)
        serializer = DoctorSerializer(doctor)
        return Response(serializer.data)

    def put(self, request, pk):
        doctor = Doctor.objects.get(pk=pk)
        serializer = DoctorSerializer(doctor, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        doctor = Doctor.objects.get(pk=pk)
        doctor.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class PatientDetailView(APIView):
    serializer_class = PatientSerializer

    def get(self, request, pk):
        patient = Patient.objects.get(pk=pk)
        serializer = PatientSerializer(patient)
        return Response(serializer.data)

    def put(self, request, pk):
        patient = Patient.objects.get(pk=pk)
        serializer = PatientSerializer(patient, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        patient = Patient.objects.get(pk=pk)
        patient.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class MedicationDetailView(APIView):
    serializer_class = MedicationSerializer

    def get(self, request, pk):
        medication = Medication.objects.get(pk=pk)
        serializer = MedicationSerializer(medication)
        return Response(serializer.data)

    def put(self, request, pk):
        medication = Medication.objects.get(pk=pk)
        serializer = MedicationSerializer(medication, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        medication = Medication.objects.get(pk=pk)
        medication.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class AppointmentDetailView(APIView):
    serializer_class = AppointmentSerializer

    def get(self, request, pk):
        appointment = Appointment.objects.get(pk=pk)
        serializer = AppointmentSerializer(appointment)
        return Response(serializer.data)

    def put(self, request, pk):
        appointment = Appointment.objects.get(pk=pk)
        serializer = AppointmentSerializer(appointment, data=request.data)
        if serializer.is_valid():
            appointment.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        appointment = Appointment.objects.get(pk=pk)
        appointment.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class AppointmentsById(APIView):
    serializer_class = AppointmentSerializer
    def get(self, request, pk):
        appointments = Appointment.objects.filter(doctor=pk)
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)


class PatientsById(APIView):
    serializer_class = PatientSerializer
    def get(self, request, pk):
        patients = Patient.objects.filter(doctor=pk)
        serializer = PatientSerializer(patients, many=True)
        return Response(serializer.data)



