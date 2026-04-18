from django.db import models
import uuid


class Task(models.Model):
    STATUS_CHOICES = [
        ("Pending", "Pending"),
        ("In Progress", "In Progress"),
        ("Completed", "Completed"),
    ]

    # Unique reference users can track
    task_code = models.CharField(max_length=12, unique=True, editable=False)

    # Core AI outputs
    intent = models.CharField(max_length=50)
    entities = models.JSONField(default=dict)

    risk_score = models.IntegerField(default=0)

    steps = models.JSONField(default=list)

    # Multi-channel messages
    whatsapp_message = models.TextField()
    email_message = models.TextField()
    sms_message = models.TextField()

    # Assignment + status tracking
    assigned_team = models.CharField(max_length=50)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="Pending")

    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        # Auto-generate task code if missing
        if not self.task_code:
            self.task_code = str(uuid.uuid4())[:8].upper()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.task_code} - {self.intent}"
