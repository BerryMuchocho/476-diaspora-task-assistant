from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .services import process_user_input




@csrf_exempt

def process_request(request):
    if request.method == "POST":
        try: 
            data = json.loads(request.body)
            message = data.get("message", "")

            if not message:
                return JsonResponse({"error": "message is required"}, status=400)
            
            result = process_user_input(message)

            return JsonResponse(result)
        
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)
        
    return JsonResponse({"error": "Only POST method allowed"}, status=405)


