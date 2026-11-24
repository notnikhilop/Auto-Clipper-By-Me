# Auto-Clipper-By-Me

**AI Short Studio** — a local-first AI video clipping workspace.

## Start here (Windows)

You do not need to type commands.

1. Open the green **Code** button on this GitHub repository.
2. Choose **Download ZIP** and extract the ZIP file.
3. Open the extracted folder.
4. Double-click **START_HERE.bat**.
5. On the first run, the launcher prepares the app, installs its project dependencies, starts the backend and frontend, and opens the dashboard.

You need Python 3.11+ and Node.js LTS installed. If either is missing, the launcher will show the official download page. During Python installation, enable **Add Python to PATH**.

Keep the two terminal windows open while using the app. Close them to stop the local app.

## Current milestone

### Milestone 1 — Foundation
- React + Vite dashboard
- FastAPI backend
- Local video upload endpoint
- SQLite project metadata
- Windows one-click setup launcher

### Planned next
- AI transcription and highlight detection
- Clip scoring and automatic clip generation
- 9:16 vertical reframing and face tracking
- Animated captions and editor
- MP4 export

## Developer setup (optional)

### Backend
```bash
cd backend
python -m venv .venv
.venv\\Scripts\\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

### Frontend
```bash
cd frontend
npm install
npm run dev
```

Open http://localhost:5173.

## Privacy and costs

Uploaded videos are stored on the computer running the backend. This is a local development app; do not expose its server to the public internet. Optional cloud AI services, hosting, and storage may have separate costs. API secrets must stay on the backend, never in frontend code.

No license has been selected yet.
