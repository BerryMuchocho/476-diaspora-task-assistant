import json

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def process_request(request):
    if request.method != "POST":
        return JsonResponse({"error": "Only POST method allowed"}, status=405)

    try:
        data = json.loads(request.body.decode("utf-8"))
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON payload"}, status=400)

    message = data.get("message")
    if not message:
        return JsonResponse({"error": 'Field "message" is required'}, status=400)

    return JsonResponse(
        {
            "message": message,
        },
        status=200,
    )
