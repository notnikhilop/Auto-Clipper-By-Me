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

echo Checking the default WSL Ubuntu instance...
wsl.exe --exec /bin/true >nul 2>nul
if errorlevel 1 goto install_ubuntu

echo [1/2] Finding the setup script...
set "WSL_SCRIPT="
for /f "delims=" %%I in ('wsl.exe --exec wslpath -a "%~dp0scripts\setup-wsl.sh" 2^>nul') do set "WSL_SCRIPT=%%I"
if not defined WSL_SCRIPT (
  echo Could not locate scripts/setup-wsl.sh inside the default WSL distribution.
  echo Confirm Ubuntu has completed its first-run setup, then send a screenshot.
  pause
  exit /b 1
)

echo [2/2] Preparing and starting AI Short Studio in Ubuntu...
wsl.exe --exec bash "%WSL_SCRIPT%"
if errorlevel 1 (
  echo.
  echo SETUP FAILED. The browser will not be opened.
  echo Take a screenshot of this window and send it in ChatGPT.
  pause
  exit /b 1
)

echo.
echo Opening AI Short Studio...
start "" "http://localhost:5173"
echo.
echo AI Short Studio setup completed in Ubuntu (WSL2).
echo To stop the app, double-click STOP_AI_SHORT_STUDIO.bat.
pause
exit /b 0

:install_wsl
echo WSL is not available. Starting the official WSL and Ubuntu installation...
powershell -NoProfile -Command "$p=Start-Process -FilePath 'wsl.exe' -ArgumentList '--install -d Ubuntu' -Verb RunAs -Wait -PassThru; exit $p.ExitCode"
echo.
echo If Windows asks for a restart, restart the PC.
echo Then open Ubuntu from the Start menu, finish its username/password setup,
echo and run START_HERE.bat again.
pause
exit /b 0

:install_ubuntu
echo No working default WSL Linux distribution was found.
echo Opening the installed Ubuntu app may finish its first-run setup.
echo Open Ubuntu from the Windows Start menu, wait for the prompt:
echo nikhil@...:~$
echo Then close Ubuntu and run START_HERE.bat again.
pause
exit /b 0
