@echo off
title AI Short Studio - Setup
setlocal
cd /d "%~dp0"

echo.
echo ==============================================
echo          AI SHORT STUDIO - FIRST RUN
echo ==============================================
echo.
where py >nul 2>nul
if errorlevel 1 (
  echo Python was not found on this computer.
  echo Install Python 3.11 or newer from:
  echo https://www.python.org/downloads/windows/
  echo IMPORTANT: tick "Add Python to PATH" during installation.
  echo Then double-click START_HERE.bat again.
  pause
  exit /b 1
)
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js was not found on this computer.
  echo Install the LTS version from:
  echo https://nodejs.org/
  echo Then restart this window and double-click START_HERE.bat again.
  pause
  exit /b 1
)
where npm >nul 2>nul
if errorlevel 1 (
  echo npm was not found. Reinstall Node.js LTS from https://nodejs.org/
  pause
  exit /b 1
)

echo [1/4] Preparing Python environment...
if not exist "backend\.venv\Scripts\python.exe" py -3 -m venv "backend\.venv"
if errorlevel 1 goto failed

echo [2/4] Installing backend requirements...
"backend\.venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 goto failed
"backend\.venv\Scripts\python.exe" -m pip install -r "backend\requirements.txt"
if errorlevel 1 goto failed

echo [3/4] Installing frontend packages...
cd /d "%~dp0frontend"
call npm install
if errorlevel 1 goto failed

echo [4/4] Starting AI Short Studio...
start "AI Short Studio Backend" cmd /k "cd /d ""%~dp0backend"" && ""%~dp0backend\.venv\Scripts\python.exe"" -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000"
timeout /t 3 /nobreak >nul
start "AI Short Studio Frontend" cmd /k "cd /d ""%~dp0frontend"" && npm run dev"
timeout /t 5 /nobreak >nul
start "" "http://localhost:5173"
echo.
echo AI Short Studio is starting in your browser.
echo Keep both terminal windows open while using the app.
echo To stop the app, close those two terminal windows.
pause
exit /b 0

:failed
echo.
echo Setup could not finish. Take a screenshot of this window and send it in ChatGPT.
pause
exit /b 1
