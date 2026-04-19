import os
import json
from dotenv import load_dotenv
from groq import Groq

load_dotenv()

client = Groq(api_key=os.getenv("GROQ_API_KEY"))


ALLOWED_INTENTS = [
    "send_money",
    "get_airport_transfer",
    "hire_service",
    "verify_document",
    "check_status"
]


def extract_with_ai(message):
    prompt = f"""
You are a strict JSON generator.

Return ONLY valid JSON.
No markdown.
No explanation.
No text before or after.

Schema:
{{
  "intent": "send_money | get_airport_transfer | hire_service | verify_document | check_status | unknown",
  "entities": {{
    "amount": number or null,
    "location": string or null,
    "recipient": string or null,
    "service_type": string or null,
    "document_type": string or null,
    "pickup_location": string or null,
    "dropoff_location": string or null,
    "urgency": "high" or "low" or null
  }}
}}

Message:
{message}
"""

    try:
        response = client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=[
                {"role": "system", "content": "You return only valid JSON. No extra text."},
                {"role": "user", "content": prompt}
            ],
            temperature=0
        )

        # STEP 1: get raw output
        content = response.choices[0].message.content.strip()

        print("RAW GROQ RESPONSE:")
        print(content)

        # STEP 2: remove markdown if model adds it
        if "```" in content:
            parts = content.split("```")
            content = parts[1] if len(parts) > 1 else content
            content = content.replace("json", "").strip()

        # STEP 3: parse JSON safely
        try:
            data = json.loads(content)
        except json.JSONDecodeError as e:
            print("JSON PARSE FAILED:", content)
            return {
                "intent": "unknown",
                "entities": {},
                "error": "invalid_json",
                "raw": content
            }

        return data

    except Exception as e:
        print("AI SERVICE ERROR:", str(e))

        return {
            "intent": "unknown",
            "entities": {},
            "error": str(e)
        }
