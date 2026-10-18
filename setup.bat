@echo off
rem GAUD - Setup automatizado (Windows). Ejecuta setup.ps1 con los argumentos recibidos.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
echo.
pause
