# Auto-Clipper-By-Me

**AI Short Studio** — a local-first AI video clipping workspace.

## Start here (Windows 11)

The recommended setup runs the Python backend inside **Ubuntu on WSL2**. This avoids the Windows Code Integrity signing restriction that blocked the local Python extension on some PCs. **Do not disable Smart App Control or Windows security features.**

1. Open the green **Code** button on this public GitHub repository.
2. Choose **Download ZIP** and extract the ZIP.
3. Open the extracted folder.
4. Double-click **START_HERE.bat**.
5. If WSL2/Ubuntu is missing, Windows will install Ubuntu. Restart if Windows asks.
6. Open Ubuntu once from the Windows Start menu. Create a Linux username and password. Password characters do not appear while typing; this is normal.
7. Double-click **START_HERE.bat** again. The launcher automatically detects the installed Ubuntu distribution name (including versioned names), installs Linux dependencies, downloads the latest public project into Ubuntu, and starts the app.
8. The dashboard opens at http://localhost:5173.

The first setup needs an internet connection and may take several minutes. Ubuntu may ask for your Linux password when installing system packages; this is normal. The password is not displayed as you type.

### Daily use

- Double-click **START_HERE.bat** to update and start the app.
- Double-click **STOP_AI_SHORT_STUDIO.bat** to stop its backend and frontend.
- Uploaded videos and the SQLite project database are stored inside Ubuntu at `~/AI-Short-Studio/backend/`.
- Keep Smart App Control enabled. This setup does not change Windows security settings.

### Troubleshooting

- If Windows asks for a restart during WSL installation, restart, open Ubuntu once, finish its first-time username/password setup, then run `START_HERE.bat` again.
- If setup fails, take a screenshot of the Ubuntu/terminal window and share it.
- Logs are stored in `~/.ai-short-studio/logs/` inside Ubuntu.

## Current milestone

### Milestone 1 — Foundation
- React + Vite dashboard
- FastAPI backend
- Local video upload endpoint
- SQLite project metadata
- Windows WSL2 one-click starter

### Planned next
- AI transcription and highlight detection
- Clip scoring and automatic clip generation
- 9:16 vertical reframing and face tracking
- Animated captions and editor
- MP4 export

## Privacy and costs

Uploaded videos are stored locally inside the Ubuntu environment on this computer. This is a local development app; do not expose its server to the public internet. Optional cloud AI services, hosting, and storage may have separate costs. API secrets must stay on the backend, never in frontend code.

No license has been selected yet.
