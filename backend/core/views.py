import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .services import generate_messages, process_user_input
from .models import Task, StatusHistory


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
        print("AI PIPELINEBRESULT:", result)

        # 2. Normalize AI result safety
        intent = result.get("intent", "unknown")

        if intent == "unknown": 
            return JsonResponse({"error": "Could not determine intent", "raw": result}, status=400)

        # 3. Save to database
        task = Task.objects.create(
            intent=result.get("intent", "unknown"),
            entities=result.get("entities", {}),
            risk_score=result.get("risk_score", 0),
            steps=result.get("steps", []),
            whatsapp_message=result.get("messages", {}).get("whatsapp", ""),
            email_message=result.get("messages", {}).get("email", ""),
            sms_message=result.get("messages", {}).get("sms", ""),
            assigned_team=result.get("assigned_team", "unassigned"),
            status="Pending"
        )

        StatusHistory.objects.create(
            task=task,
            old_status="",
            new_status=task.status
        )

        final_messages = generate_messages(
            result.get("intent", "unknown"),
            result.get("entities", {}),
            result.get("risk_score", 0),
            task.task_code,
        )
        task.whatsapp_message = final_messages.get("whatsapp", "")
        task.email_message = final_messages.get("email", "")
        task.sms_message = final_messages.get("sms", "")
        task.save(update_fields=["whatsapp_message", "email_message", "sms_message"])
        result["messages"] = final_messages

        # 4. Return response with task code
        return JsonResponse({
            "task_code": task.task_code,
            "status": task.status,
            "data": result
        })

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

# Task dashboard API

def get_tasks(request):
    tasks = Task.objects.all().order_by("-created_at")

    data = [
        {
            "task_code": t.task_code,
            "intent": t.intent,
            "entities": t.entities,
            "risk_score": t.risk_score,
            "steps": t.steps,
            "messages": {
                "whatsapp": t.whatsapp_message,
                "email": t.email_message,
                "sms": t.sms_message,
            },
            "status": t.status,
            "assigned_team": t.assigned_team,
            "created_at": t.created_at,
            "status_history": [
                {
                    "old_status": history.old_status,
                    "new_status": history.new_status,
                    "changed_at": history.changed_at,
                }
                for history in t.status_history.all().order_by("changed_at")
            ],
        }

        for t in tasks
    ]

    return JsonResponse(data, safe=False)

# Update tast status endpoint (PUT)
# Task lifecycle state includes: Pending - In Progress - Completed

@csrf_exempt
def update_task_status(request, task_code):
    if request.method != "PUT":
        return JsonResponse({"error": "Only PUT allowed"}, status=405)
    
    try: 
        task = Task.objects.get(task_code=task_code)

        data = json.loads(request.body)
        new_status = data.get("status")

        # To validate allowed statuses 

        allowed_statuses = ["Pending", "In Progress", "Completed"]

        if new_status not in allowed_statuses:
            return JsonResponse({"error": f"Invalid status. Must be one of {allowed_statuses}"}, status=400)

        old_status = task.status
        task.status = new_status
        task.save()

        if old_status != new_status:
            StatusHistory.objects.create(
                task=task,
                old_status=old_status,
                new_status=new_status
            )

        return JsonResponse({
            "task_code": task.task_code,
            "status": task.status,
            "message": "Task updated successfully"
        })
    
    except Task.DoesNotExist:
        return JsonResponse({"error": "Task not found"}, status=404)
    
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    
    

