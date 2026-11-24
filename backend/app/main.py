from __future__ import annotations

import sqlite3
import uuid
from datetime import datetime, timezone
from pathlib import Path

from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware

BASE_DIR = Path(__file__).resolve().parents[1]
UPLOAD_DIR = BASE_DIR / 'uploads'
DATA_DIR = BASE_DIR / 'data'
DB_PATH = DATA_DIR / 'projects.db'
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
DATA_DIR.mkdir(parents=True, exist_ok=True)
ALLOWED_EXTENSIONS = {'.mp4', '.mov', '.mkv', '.webm', '.avi'}
MAX_UPLOAD_BYTES = 2 * 1024 * 1024 * 1024


def connection():
    db = sqlite3.connect(DB_PATH)
    db.row_factory = sqlite3.Row
    return db


with connection() as db:
    db.execute('''CREATE TABLE IF NOT EXISTS projects (
        id TEXT PRIMARY KEY, filename TEXT NOT NULL, stored_path TEXT NOT NULL,
        size_bytes INTEGER NOT NULL, status TEXT NOT NULL, created_at TEXT NOT NULL
    )''')

app = FastAPI(title='Auto-Clipper-By-Me API', version='0.1.0')
app.add_middleware(
    CORSMiddleware,
    allow_origins=['http://localhost:5173', 'http://127.0.0.1:5173'],
    allow_credentials=True, allow_methods=['*'], allow_headers=['*']
)


@app.get('/api/health')
def health():
    return {'status': 'ok', 'service': 'auto-clipper-api', 'version': '0.1.0'}


@app.get('/api/projects')
def list_projects():
    with connection() as db:
        rows = db.execute(
            'SELECT id, filename, size_bytes, status, created_at FROM projects ORDER BY created_at DESC'
        ).fetchall()
    return {'projects': [dict(row) for row in rows]}


@app.post('/api/upload')
async def upload_video(file: UploadFile = File(...)):
    filename = Path(file.filename or 'video').name
    extension = Path(filename).suffix.lower()
    if extension not in ALLOWED_EXTENSIONS:
        raise HTTPException(400, 'Unsupported format. Use MP4, MOV, MKV, WEBM, or AVI.')

    project_id = uuid.uuid4().hex
    destination = UPLOAD_DIR / f'{project_id}{extension}'
    total = 0
    try:
        with destination.open('wb') as output:
            while chunk := await file.read(1024 * 1024):
                total += len(chunk)
                if total > MAX_UPLOAD_BYTES:
                    raise HTTPException(413, 'Video exceeds the 2 GB upload limit.')
                output.write(chunk)
        if total == 0:
            raise HTTPException(400, 'Uploaded file is empty.')
        created_at = datetime.now(timezone.utc).isoformat()
        with connection() as db:
            db.execute(
                'INSERT INTO projects VALUES (?, ?, ?, ?, ?, ?)',
                (project_id, filename, str(destination), total, 'uploaded', created_at)
            )
        return {
            'id': project_id, 'filename': filename, 'size_bytes': total,
            'status': 'uploaded',
            'message': 'Upload complete. AI processing will be added in the next milestone.'
        }
    except HTTPException:
        destination.unlink(missing_ok=True)
        raise
    except OSError as exc:
        destination.unlink(missing_ok=True)
        raise HTTPException(500, 'Could not save uploaded video.') from exc
    finally:
        await file.close()
