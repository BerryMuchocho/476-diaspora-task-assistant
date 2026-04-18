from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import os

print("🔥 VIEW FILE:", __file__)


# Endpoint logic.

@csrf_exempt
def process_request(request):
    if request.method == "POST":
        try: 
            data = json.loads(request.body)
            user_input = data.get("message", "")

            # Mock response
            response_data = {
                "debug_marker": "VERSION_1_REAL_VIEW",
                "intent": "send_money",
                "entities": {
                    "amount": 15000,
                    "recipient": "mother",
                    "location": "Kisumu"
                },
                "risk_score": 7,
                "status": "Pending"
            }

            return JsonResponse(response_data)
        
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)
        
    return JsonResponse({"error": "Only POST method allowed"}, status=405)


