from django.urls import path

from .views import process_request

urlpatterns = [
    path("process-request/", process_request, name="process_request"),
]
