@echo off
title Stop AI Short Studio
echo Stopping AI Short Studio inside Ubuntu...
wsl.exe -d Ubuntu -- bash -lc "pkill -f '[u]vicorn app.main:app' 2>/dev/null || true; pkill -f '[v]ite --host' 2>/dev/null || true"
echo AI Short Studio stop command sent.
pause
