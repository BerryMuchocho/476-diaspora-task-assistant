from django.urls import path
from .views import process_request
from . import views

urlpatterns = [
    path('process_request/', process_request),
    path("tasks/", views.get_tasks),
    path("task/<str:task_code>/update/", views.update_task_status),
]
