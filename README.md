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

## Notes

- The backend prefers AI extraction first and falls back to deterministic extraction if the AI call fails.
- This makes the system resilient during API/network issues while keeping structured responses consistent.
