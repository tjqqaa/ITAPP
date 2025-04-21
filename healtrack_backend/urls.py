from django.contrib import admin
from django.urls import path

from healtrack_backend.views import DoctorListCreateView, MedicationListCreateView, \
    PatientListCreateView, AppointmentListCreateView, DoctorDetailView, PatientDetailView, AppointmentDetailView, \
    MedicationDetailView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('doctors/', DoctorListCreateView.as_view()),
    path('patients/', PatientListCreateView.as_view()),
    path('appointments/', AppointmentListCreateView.as_view()),
    path('medications/', MedicationListCreateView.as_view()),
    path('doctors/<int:pk>/', DoctorDetailView.as_view()),
    path('patients/<int:pk>/', PatientDetailView.as_view()),
    path('appointments/<int:pk>/', AppointmentDetailView.as_view()),
    path('medications/<int:pk>/', MedicationDetailView.as_view()),
]
