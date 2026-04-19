# Diaspora Task Assistant

AI-powered assistant for Kenyans in the diaspora to initiate and track tasks back home.

## Supported Services

- `send_money`
- `get_airport_transfer`
- `hire_service`
- `verify_document`
- `check_status`

## Tech Stack

- Backend: Django
- Frontend: HTML, CSS, Vanilla JavaScript
- Database: SQLite
- AI: Groq

## Core Flow

1. The user submits a plain-English request from the frontend.
2. `POST /api/process_request/` sends the message to the backend.
3. `views.py` calls `process_user_input()` in `services.py`.
4. `services.py` calls `extract_with_ai()` in `ai_service.py`.
5. If the AI response is unavailable or returns `unknown`, the backend falls back to rule-based extraction.
6. The system calculates a risk score, generates fulfilment steps, creates channel-specific messages, assigns a team, and saves the task.
7. A unique `task_code` is generated and included in the final saved messages.
8. Tasks are shown in the dashboard and status updates are persisted with history.

## API Endpoints

- `POST /api/process_request/`
- `GET /api/tasks/`
- `PUT /api/task/<task_code>/update/`

## Stored Task Data

Each task stores:

- unique task code
- intent
- extracted entities
- risk score
- fulfilment steps
- WhatsApp message
- email message
- SMS message
- assigned team
- current status
- created timestamp

Status changes are also stored in `StatusHistory`.

## Risk Scoring Logic

The scoring is intentionally simple and grounded in likely diaspora operations risk:

- `send_money`
  - large amounts increase risk
  - urgent requests increase risk
  - missing recipient increases risk
- `verify_document`
  - land title verification is treated as higher risk than simpler document checks
- `hire_service`
  - has a small base risk
  - urgency increases risk
  - missing location increases risk
- `get_airport_transfer`
  - has a base logistics risk
  - urgency increases risk
  - missing pickup or dropoff details increases risk

## Employee Assignment

- `send_money` -> Finance
- `get_airport_transfer` -> Operations
- `hire_service` -> Operations
- `verify_document` -> Legal
- `check_status` -> Support

## Dashboard

The dashboard shows:

- task code
- intent
- entities
- risk score
- fulfilment steps
- WhatsApp, email, and SMS messages
- assigned team
- current status
- creation time
- status history

## Setup

From the project root:

```powershell
.venv\Scripts\Activate.ps1
cd backend
python manage.py migrate
python manage.py runserver
```

Then open the frontend separately and make sure `frontend/app.js` points to:

```text
http://127.0.0.1:8000/api
```

## Submission Artifacts

- SQLite database: [backend/db.sqlite3](backend/db.sqlite3)
- SQL dump: [submission/diaspora_task_assistant_dump.sql](submission/diaspora_task_assistant_dump.sql)

The database includes sample tasks covering:

- send money
- airport transfer
- hire service
- verify document
- check status

## Decisions I made and why

### AI tool used (Groq)
I used Groq as the LLM provider because it offers fast inference and reliable responses for real-time intent and entity extraction. Since the system depends on immediate processing of user requests, latency and consistency were important factors in the choice.

Groq was used for:
- Extracting intent from user messages
- Identifying structured entities such as amounts, locations, recipients, and document types
- Returning machine-readable JSON for backend processing

---

### System prompt design decisions
The system prompt was carefully constrained to ensure structured and predictable outputs. The goal was to make the model behave like a deterministic parser rather than a conversational assistant.

Key design choices:
- Restricted output to predefined intents only
- Enforced strict JSON formatting for parsing reliability
- Prioritised structured entity extraction over explanations
- Removed conversational or narrative responses

Elements intentionally excluded:
- Chain-of-thought reasoning
- Free-form text responses
- Extended explanations or justifications

This approach was chosen to improve consistency and ensure downstream services could reliably process AI output without manual correction.

---

### Fallback logic and AI override
In cases where the AI response is incomplete, malformed, or returns an `unknown` intent, I implemented a rule-based fallback system.

The fallback is triggered when:
- JSON parsing fails
- Required fields are missing
- Intent cannot be confidently determined

In such cases, the system:
- Uses keyword-based extraction rules
- Ensures a valid intent is still assigned
- Prevents task creation failure

This decision ensures system reliability even when the AI model is inconsistent or unavailable.

---

### Handling unexpected AI behaviour
The initial assumption was that the AI would consistently return clean structured JSON. However, real-world usage showed:
- Inconsistent formatting
- Missing or partial fields
- Occasional incorrect intent classification

To address this:
- The system prompt was refined for stricter output control
- Backend validation was added for all AI responses
- A deterministic fallback extractor was implemented
- Intent normalization was enforced before saving to the database

These changes improved stability and reduced failed task creation.

---

### Architectural decisions
The backend was intentionally structured into separate layers:

- `views.py` → handles HTTP requests only
- `services.py` → contains business logic and orchestration
- `ai_service.py` → manages all AI interactions

This separation was chosen to:
- Allow easy replacement of the AI provider in future
- Improve maintainability and debugging
- Isolate AI-specific logic from core business logic
- Make the system easier to test and extend
