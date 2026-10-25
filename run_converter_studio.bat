@echo off
setlocal
cd /d "%~dp0"
title Converter Studio

if not exist ".venv\Scripts\python.exe" (
    echo Setting up Converter Studio for the first time...
    where py >nul 2>nul && (py -3 -m venv .venv) || (python -m venv .venv)
    if errorlevel 1 (
        echo.
        echo Python was not found. Install it from https://www.python.org/downloads/
        echo and tick "Add python.exe to PATH" during setup, then run this file again.
        pause
        exit /b 1
    )
)

if not exist ".venv\.deps_ok" (
    echo Installing the conversion components ^(first run only, this takes a few minutes^)...
    ".venv\Scripts\python.exe" -m pip install --upgrade pip >nul 2>nul
    ".venv\Scripts\python.exe" -m pip install -r requirements.txt
    if errorlevel 1 (
        echo.
        echo Some components failed to install. Check your internet connection and run this file again.
        pause
        exit /b 1
    )
    echo Installing optional extras...
    for /f "usebackq tokens=* eol=#" %%p in ("optional-requirements.txt") do (
        ".venv\Scripts\python.exe" -m pip install %%p >nul 2>nul
    )
    echo ok> ".venv\.deps_ok"
)

rem Drag files onto this .bat to open them straight in the app.
start "" ".venv\Scripts\pythonw.exe" converter_studio.py %*
endlocal
