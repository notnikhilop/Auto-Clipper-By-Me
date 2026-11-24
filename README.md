# Auto-Clipper-By-Me

**AI Short Studio** — a local-first AI video clipping workspace.

## Milestone 1 — Foundation
- React + Vite dashboard
- FastAPI backend
- Local video upload API
- SQLite project metadata

## Planned features
- AI transcription and highlight detection
- Clip scoring and generation
- 9:16 reframing and face tracking
- Animated captions and editing
- MP4 export

## Run locally

### Backend
```bash
cd backend
python -m venv .venv
.venv\\Scripts\\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

### Frontend
```bash
cd frontend
npm install
npm run dev
```

Open the Vite URL (normally http://localhost:5173).

Uploads are stored locally on the computer running the backend. Do not expose the development server publicly. Optional cloud services may have separate costs. API secrets must remain on the backend.

No license has been selected yet.
