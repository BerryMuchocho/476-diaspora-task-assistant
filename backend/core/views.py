import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .services import process_user_input
from .models import Task


@csrf_exempt
def process_request(request):
    if request.method != "POST":
        return JsonResponse({"error": "Only POST allowed"}, status=405)

    try:
        data = json.loads(request.body)
        message = data.get("message", "")

        if not message:
            return JsonResponse({"error": "Message is required"}, status=400)

        # 1. Process AI-like logic
        result = process_user_input(message)

        # 2. Handle failed intent
        if result.get("status") == "failed":
            return JsonResponse(result, status=400)

        # 3. Save to database
        task = Task.objects.create(
            intent=result["intent"],
            entities=result["entities"],
            risk_score=result["risk_score"],
            steps=result["steps"],
            whatsapp_message=result["messages"]["whatsapp"],
            email_message=result["messages"]["email"],
            sms_message=result["messages"]["sms"],
            assigned_team=result["assigned_team"],
            status="Pending"
        )

        # 4. Return response with task code
        return JsonResponse({
            "task_code": task.task_code,
            "status": task.status,
            "data": result
        })

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
