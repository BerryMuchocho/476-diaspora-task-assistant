# Diaspora Task Assistant (Ref: 476)

## Overview
AI-powered assistant for Kenyans in the diaspora to:
- Send money
- Hire services
- Verify documents

## Tech Stack
- Backend: Django (Python)
- Frontend: HTML, CSS, Vanilla JS
- Database: SQLite (initially)
- AI: (To be decided - OpenAI / Gemini / Groq)

## Project Structure
/backend - Django backend
/frontend - UI (HTML, CSS, JS)

## Plan (Day 1–4)
Day 1:
- Setup project structure
- Initialize backend & frontend

Day 2:
- AI intent extraction + API integration

Day 3:
- Risk scoring + task creation + DB

Day 4:
- Dashboard + message generation + polish

## Notes
Repository initialized early to demonstrate development progress as required.

## MVP Features

This version of the backend can:

- Accept POST requests to `/api/process_request/`
- Parse JSON input safely
- Extract structured data from user messages (basic rule-based logic)
- Return consistent response format including:
  - intent
  - entities
  - risk_score
  - status
- Separate business logic into a service layer (`services.py`)
