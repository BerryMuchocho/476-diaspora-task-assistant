import re


# ---------------------------
# HELPERS
# ---------------------------
def normalize_text(text):
    return text.lower().strip()


def extract_amount(text):
    match = re.search(r"\d+(?:,\d{3})*", text)
    if match:
        return int(match.group().replace(",", ""))
    return None


# ---------------------------
# 1. INTENT DETECTION
# ---------------------------
def detect_intent(message, entities):
    msg = message

    if "send" in msg and (entities.get("amount") or "money" in msg or "kes" in msg):
        return "send_money"

    if any(word in msg for word in ["clean", "hire", "someone", "help"]):
        return "hire_service"

    if any(word in msg for word in ["verify", "document", "title", "id", "certificate"]):
        return "verify_document"

    if any(word in msg for word in ["status", "track", "update"]):
        return "check_status"

    return "unknown"


# ---------------------------
# 2. ENTITY EXTRACTION (GLOBAL)
# ---------------------------
def extract_common_entities(message):
    entities = {}

    amount = extract_amount(message)
    if amount:
        entities["amount"] = amount

    if any(word in message for word in ["urgent", "asap", "now"]):
        entities["urgency"] = "high"

    if any(word in message for word in ["mother", "mum", "mom"]):
        entities["recipient"] = "mother"

    # locations (expandable later)
    locations = ["kisumu", "nairobi", "westlands", "karen"]
    for loc in locations:
        if loc in message:
            entities["location"] = loc.title()

    return entities


# ---------------------------
# 3. ENTITY EXTRACTION (INTENT-SPECIFIC)
# ---------------------------
def enrich_entities(intent, message, entities):
    # IMPORTANT: only add fields relevant to intent

    if intent == "verify_document":
        if any(word in message for word in ["land", "title"]):
            entities["document_type"] = "land_title"
        elif "id" in message:
            entities["document_type"] = "id"
        elif "certificate" in message:
            entities["document_type"] = "certificate"

    if intent == "hire_service":
        if "clean" in message:
            entities["service_type"] = "cleaning"

    return entities


# ---------------------------
# 4. RISK SCORING (IMPROVED)
# ---------------------------
def calculate_risk(intent, entities):
    score = 0

    if intent == "send_money":
        amount = entities.get("amount", 0)

        if amount > 10000:
            score += 30
        elif amount > 5000:
            score += 15

        if entities.get("urgency") == "high":
            score += 20

        if not entities.get("recipient"):
            score += 10

    elif intent == "verify_document":
        if entities.get("document_type") == "land_title":
            score += 40
        else:
            score += 20

    elif intent == "hire_service":
        score += 5  # baseline risk

        if entities.get("urgency") == "high":
            score += 10

        if not entities.get("location"):
            score += 5

    return min(score, 100)


# ---------------------------
# 5. STEP GENERATION
# ---------------------------
def generate_steps(intent):
    steps_map = {
        "send_money": [
            "Verify sender identity",
            "Confirm recipient details",
            "Process transfer",
            "Send confirmation"
        ],
        "hire_service": [
            "Match service provider",
            "Confirm availability",
            "Schedule service",
            "Confirm completion"
        ],
        "verify_document": [
            "Receive document",
            "Assign legal officer",
            "Verify authenticity",
            "Send report"
        ],
        "check_status": [
            "Retrieve task",
            "Check current status",
            "Return update"
        ]
    }

    return steps_map.get(intent, [])


# ---------------------------
# 6. MESSAGE GENERATION
# ---------------------------
def generate_messages(intent, entities, risk_score):
    summary = intent.replace("_", " ").title()

    whatsapp = (
        f"Hi 👋\n"
        f"{summary} received.\n"
        f"Risk Score: {risk_score}\n"
        f"We’ll update you shortly."
    )

    email = (
        "Subject: Task Confirmation\n\n"
        "Your request has been successfully logged.\n\n"
        f"Intent: {intent}\n"
        f"Entities: {entities}\n"
        f"Risk Score: {risk_score}\n\n"
        "Our team is processing your request.\n"
        "Thank you."
    )

    sms = f"{summary} received. Risk:{risk_score}. Ref coming."

    return {
        "whatsapp": whatsapp,
        "email": email,
        "sms": sms
    }


# ---------------------------
# 7. EMPLOYEE ASSIGNMENT
# ---------------------------
def assign_team(intent):
    mapping = {
        "send_money": "Finance",
        "hire_service": "Operations",
        "verify_document": "Legal",
        "check_status": "Support"
    }
    return mapping.get(intent, "General")


# ---------------------------
# 8. MAIN ORCHESTRATOR
# ---------------------------
def process_user_input(message):
    message = normalize_text(message)

    entities = extract_common_entities(message)
    intent = detect_intent(message, entities)
    entities = enrich_entities(intent, message, entities)

    if intent == "unknown":
        return {
            "error": "Could not determine intent",
            "status": "failed"
        }

    risk_score = calculate_risk(intent, entities)
    steps = generate_steps(intent)
    messages = generate_messages(intent, entities, risk_score)
    assigned_team = assign_team(intent)

    return {
        "intent": intent,
        "entities": entities,
        "risk_score": risk_score,
        "steps": steps,
        "messages": messages,
        "assigned_team": assigned_team,
        "status": "success"
    }
