import re

def extract_amount(text):
    match = re.search(r"\d+", text)
    return int(match.group()) if match else None

def process_user_input(message):
    amount = extract_amount(message)


    return {
    "intent": "send money",
    "entities": {
        "amount": amount, 
        "recipient": "mother",
        "location": "Kisumu"
    },

    "risk_score": 7,
    "status": "Pending"
    }
