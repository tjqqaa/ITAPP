from django.contrib import admin
from django.urls import path
from healtrack_backend.views import DoctorListView, PatientListView, MedicationListView, AppointmentListView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('doctors/', DoctorListView.as_view(), name='doctors-list'),
    path('patients/', PatientListView.as_view(), name='patients-list'),
    path('apointments/', AppointmentListView.as_view(), name='appointments-list'),
    path('medications/', MedicationListView.as_view(), name='medications-list'),
]
