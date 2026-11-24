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
echo Checking Windows-to-WSL browser connection...
powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 http://127.0.0.1:5173/ ^| Out-Null; exit 0 } catch { exit 1 }"
if not errorlevel 1 (
  echo Windows localhost forwarding is working.
  start "" "http://localhost:5173"
  goto done
)

echo Windows localhost forwarding is not responding. Trying Ubuntu's WSL IP...
set "WSL_IP="
for /f "tokens=1" %%I in ('wsl.exe hostname -I 2^>nul') do set "WSL_IP=%%I"
if not defined WSL_IP (
  echo Could not read the Ubuntu WSL IP address.
  echo Please send a screenshot of this window.
  pause
  exit /b 1
)

powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 ('http://%WSL_IP%:5173/') ^| Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  echo.
  echo The app started in Ubuntu but Windows cannot reach port 5173.
  echo WSL IP: %WSL_IP%
  echo Send a screenshot of this window to ChatGPT.
  pause
  exit /b 1
)

echo Opening the app using Ubuntu's WSL IP: %WSL_IP%
start "" "http://%WSL_IP%:5173"

:done
echo.
echo SUCCESS: AI Short Studio is running.
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
echo Open Ubuntu from the Windows Start menu and wait for its Linux prompt.
echo Then close Ubuntu and run START_HERE.bat again.
pause
exit /b 0
