@echo off
title AI Short Studio - WSL2 Setup
setlocal
cd /d "%~dp0"

echo.
echo ==============================================
echo       AI SHORT STUDIO - WSL2 STARTER
echo ==============================================
echo.
echo This setup keeps Windows Smart App Control enabled.
echo The Python backend will run inside Ubuntu on WSL2.
echo.

where wsl.exe >nul 2>nul
if errorlevel 1 goto install_wsl

set "WSL_DISTRO="
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$d = wsl.exe --list --quiet 2>$null; $d = $d -replace [char]0,''; $d | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^Ubuntu' } | Select-Object -First 1"`) do set "WSL_DISTRO=%%I"

if not defined WSL_DISTRO goto install_ubuntu

echo Detected Ubuntu distribution: %WSL_DISTRO%
echo [1/2] Finding the setup script...
set "WSL_SCRIPT="
for /f "delims=" %%I in ('wsl.exe -d "%WSL_DISTRO%" -- wslpath -a "%~dp0scripts\setup-wsl.sh"') do set "WSL_SCRIPT=%%I"
if not defined WSL_SCRIPT (
  echo Could not locate the setup script inside Ubuntu.
  echo Make sure this ZIP was fully extracted, then try again.
  pause
  exit /b 1
)

echo [2/2] Preparing and starting AI Short Studio in Ubuntu...
wsl.exe -d "%WSL_DISTRO%" -- bash "%WSL_SCRIPT%"
if errorlevel 1 (
  echo.
  echo Setup did not finish. Take a screenshot and send it in ChatGPT.
  pause
  exit /b 1
)

echo.
echo Opening AI Short Studio...
start "" "http://localhost:5173"
echo.
echo AI Short Studio is running inside Ubuntu (WSL2).
echo To stop the app, double-click STOP_AI_SHORT_STUDIO.bat.
pause
exit /b 0

:install_wsl
echo Windows Subsystem for Linux is not installed yet.
echo Windows may ask for administrator approval and a restart.
powershell -NoProfile -Command "$p=Start-Process -FilePath 'wsl.exe' -ArgumentList '--install -d Ubuntu' -Verb RunAs -Wait -PassThru; exit $p.ExitCode"
echo.
echo If Windows asks you to restart, restart the PC.
echo Then open Ubuntu once from the Start menu, create a Linux username
echo and password, and double-click START_HERE.bat again.
pause
exit /b 0

:install_ubuntu
echo No Ubuntu distribution was detected in WSL.
echo Starting the official Ubuntu installation...
powershell -NoProfile -Command "$p=Start-Process -FilePath 'wsl.exe' -ArgumentList '--install -d Ubuntu' -Verb RunAs -Wait -PassThru; exit $p.ExitCode"
echo.
echo When installation finishes, open Ubuntu from the Start menu.
echo Create a Linux username and password (password typing is invisible).
echo Then double-click START_HERE.bat again.
pause
exit /b 0
