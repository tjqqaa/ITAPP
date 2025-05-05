from rest_framework import serializers
from healtrack_backend.models import CustomUser,Doctor,Patient,Appointment,Medication


class PatientRegisterSerializer(serializers.ModelSerializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField()
    birth_date = serializers.DateField()
    phone_number = serializers.CharField(max_length=15)
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    mood = serializers.CharField(max_length=100)
    emergency_contact = serializers.CharField(max_length=15)
    health_points = serializers.IntegerField()

    doctor = serializers.PrimaryKeyRelatedField(
        queryset=Doctor.objects.all(),
        required=False,
        allow_null=True
    )

    class Meta:
        model = Patient
        fields = ['username',
                  'password',
                  'email',
                  'birth_date',
                  'phone_number',
                  'first_name',
                  'last_name',
                  'mood',
                  'emergency_contact',
                  'health_points',
                  'doctor']

    def create(self, validated_data):
        user_data = {
            'username': validated_data.pop('username'),
            'email': validated_data.pop('email'),
            'first_name': validated_data.pop('first_name'),
            'last_name': validated_data.pop('last_name'),
            'birth_date': validated_data.pop('birth_date'),
            'phone_number': validated_data.pop('phone_number')
        }
        password = validated_data.pop('password')

        user = CustomUser.objects.create_user(**user_data)
        user.set_password(password)
        user.save()

        doctor = validated_data.get('doctor', None)
        validated_data.pop('doctor')
        patient = Patient.objects.create(user=user, doctor=doctor, **validated_data)
        return patient


class DoctorRegisterSerializer(serializers.ModelSerializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField()
    birth_date = serializers.DateField()
    phone_number = serializers.CharField(max_length=15)
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    specialization = serializers.CharField(max_length=100)

    class Meta:
        model = Doctor
        fields = ['username',
                  'password',
                  'email',
                  'birth_date',
                  'phone_number',
                  'first_name',
                  'last_name',
                  'specialization']

    def create(self, validated_data):
        user_data = {
            'username': validated_data.pop('username'),
            'email': validated_data.pop('email'),
            'first_name': validated_data.pop('first_name'),
            'last_name': validated_data.pop('last_name'),
            'birth_date': validated_data.pop('birth_date'),
            'phone_number': validated_data.pop('phone_number')
        }
        password = validated_data.pop('password')

        user = CustomUser.objects.create_user(**user_data)
        user.set_password(password)
        user.save()

        doctor = Doctor.objects.create(user=user, **validated_data)
        return doctor


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['username','password']



class PatientSerializer(serializers.ModelSerializer):
    # user = UserSerializer(read_only=True)
    username = serializers.CharField(source='user.username')
    email = serializers.EmailField(source='user.email')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    birth_date = serializers.DateField(source='user.birth_date')
    phone_number = serializers.CharField(source='user.phone_number')

    class Meta:
        model = Patient
        exclude = ['user']


class DoctorSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username')
    email = serializers.EmailField(source='user.email')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    birth_date = serializers.DateField(source='user.birth_date')
    phone_number = serializers.CharField(source='user.phone_number')

    class Meta:
        model = Doctor
        exclude = ['user']

class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = '__all__'

class MedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = '__all__'