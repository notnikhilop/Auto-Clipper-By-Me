@echo off
title Stop AI Short Studio
setlocal
set "WSL_DISTRO="
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$d = wsl.exe --list --quiet 2>$null; $d = $d -replace [char]0,''; $d | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^Ubuntu' } | Select-Object -First 1"`) do set "WSL_DISTRO=%%I"
if not defined WSL_DISTRO (
  echo No Ubuntu distribution was found.
  pause
  exit /b 1
)
echo Stopping AI Short Studio inside %WSL_DISTRO%...
wsl.exe -d "%WSL_DISTRO%" -- bash -lc "pkill -f '[u]vicorn app.main:app' 2>/dev/null || true; pkill -f '[v]ite --host' 2>/dev/null || true"
echo Stop command sent.
pause
