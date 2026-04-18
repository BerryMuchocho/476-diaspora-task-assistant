from django.db import models
import uuid

class Task(models.Model):
    TASK_STATUS = [
        ('Pending', 'Pending'),
        ('In Progress', 'In Progress'),
        ('Completed', 'Completed'),
    ]

    task_code = models.CharField(max_length=20, unique=True, editable=False)
    intent = models.CharField(max_length=50)
    entities = models.JSONField()
    risk_score = models.FloatField()
    status = models.CharField(max_length=20, choices=TASK_STATUS, default='Pending')

    steps = models.JSONField()
    whatsapp_message = models.TextField()
    email_message = models.TextField()
    sms_message = models.TextField()

    assigned_team = models.CharField(max_length=50)

    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if not self.task_code:
            self.task_code = str(uuid.uuid4())[:8].upper()
        super().save(*args, **kwargs)
