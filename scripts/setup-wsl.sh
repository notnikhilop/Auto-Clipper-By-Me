#!/usr/bin/env bash
set -Eeuo pipefail

APP_DIR="$HOME/AI-Short-Studio"
REPO_URL="https://github.com/notnikhilop/Auto-Clipper-By-Me.git"
LOG_DIR="$HOME/.ai-short-studio/logs"

echo
echo "=============================================="
echo "       AI SHORT STUDIO - UBUNTU SETUP"
echo "=============================================="
echo
echo "Windows Smart App Control stays enabled."
echo "The app is being prepared inside Ubuntu's Linux filesystem."
echo

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This setup expects Ubuntu in WSL2."
  exit 1
fi

echo "[1/6] Installing Linux prerequisites..."
sudo apt-get update
sudo apt-get install -y git curl ca-certificates python3 python3-venv python3-pip build-essential

echo "[2/6] Checking Node.js..."
NODE_MAJOR=0
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR="$(node -p 'Number(process.versions.node.split(".")[0])')"
fi
if [ "$NODE_MAJOR" -lt 20 ]; then
  echo "Installing Node.js 22 LTS..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

echo "[3/6] Downloading the public project into Ubuntu..."
if [ -d "$APP_DIR/.git" ]; then
  git -C "$APP_DIR" pull --ff-only
elif [ -e "$APP_DIR" ]; then
  mv "$APP_DIR" "${APP_DIR}.backup.$(date +%Y%m%d%H%M%S)"
  git clone "$REPO_URL" "$APP_DIR"
else
  git clone "$REPO_URL" "$APP_DIR"
fi

cd "$APP_DIR"
mkdir -p "$LOG_DIR" backend/uploads backend/data

echo "[4/6] Preparing Python packages..."
if [ ! -x backend/.venv/bin/python ]; then
  python3 -m venv backend/.venv
fi
backend/.venv/bin/python -m pip install --upgrade pip
backend/.venv/bin/python -m pip install -r backend/requirements.txt

echo "[5/6] Preparing website packages..."
cd frontend
npm install
cd "$APP_DIR"

echo "[6/6] Starting local services..."
pkill -f '[u]vicorn app.main:app' 2>/dev/null || true
pkill -f '[v]ite --host' 2>/dev/null || true
nohup backend/.venv/bin/python -m uvicorn app.main:app --app-dir backend --host 0.0.0.0 --port 8000 > "$LOG_DIR/backend.log" 2>&1 &
BACKEND_PID=$!
nohup npm --prefix frontend run dev -- --host 0.0.0.0 --port 5173 --strictPort > "$LOG_DIR/frontend.log" 2>&1 &
FRONTEND_PID=$!

sleep 4
if ! curl -fsS http://127.0.0.1:8000/api/health >/dev/null; then
  echo "Backend did not become ready. Recent backend log:"
  tail -n 50 "$LOG_DIR/backend.log" || true
  exit 1
fi
if ! curl -fsS http://127.0.0.1:5173/ >/dev/null; then
  echo "Website did not become ready. Recent frontend log:"
  tail -n 50 "$LOG_DIR/frontend.log" || true
  exit 1
fi

echo
echo "SUCCESS: AI Short Studio is running."
echo "Website: http://localhost:5173"
echo "Backend health: http://localhost:8000/api/health"
echo "Logs: $LOG_DIR"
echo "To stop the app, double-click STOP_AI_SHORT_STUDIO.bat in Windows."
echo
