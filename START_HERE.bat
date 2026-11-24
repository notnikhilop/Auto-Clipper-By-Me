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

wsl.exe --list --quiet 2>nul | findstr /i "Ubuntu" >nul
if errorlevel 1 goto install_ubuntu

echo [1/2] Finding the setup script...
set "WSL_SCRIPT="
for /f "delims=" %%I in ('wsl.exe -d Ubuntu -- wslpath -a "%~dp0scripts\setup-wsl.sh"') do set "WSL_SCRIPT=%%I"
if not defined WSL_SCRIPT (
  echo Could not locate the setup script inside Ubuntu.
  echo Make sure this ZIP was fully extracted, then try again.
  pause
  exit /b 1
)

echo [2/2] Preparing and starting AI Short Studio in Ubuntu...
wsl.exe -d Ubuntu -- bash "%WSL_SCRIPT%"
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
echo To stop it, double-click STOP_AI_SHORT_STUDIO.bat.
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
echo Ubuntu is not installed in WSL yet.
echo Starting the official Ubuntu installation...
powershell -NoProfile -Command "$p=Start-Process -FilePath 'wsl.exe' -ArgumentList '--install -d Ubuntu' -Verb RunAs -Wait -PassThru; exit $p.ExitCode"
echo.
echo When installation finishes, open Ubuntu from the Start menu.
echo Create a Linux username and password (password typing is invisible).
echo Then double-click START_HERE.bat again.
pause
exit /b 0
