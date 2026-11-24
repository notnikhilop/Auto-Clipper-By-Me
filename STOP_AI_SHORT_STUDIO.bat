@echo off
title Stop AI Short Studio
echo Stopping AI Short Studio inside the default WSL distribution...
wsl.exe --exec bash -lc "pkill -f '[u]vicorn app.main:app' 2>/dev/null || true; pkill -f '[v]ite --host' 2>/dev/null || true"
echo Stop command sent.
pause
