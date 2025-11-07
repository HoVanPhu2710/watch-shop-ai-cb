@echo off
echo Starting Rasa Action Server...
echo.
echo Action Server will be available at: http://localhost:5055
echo.
echo Press Ctrl+C to stop the server
echo.

REM Activate virtual environment
call rasaenv\Scripts\activate

REM Start Rasa action server
rasa run actions --port 5055

pause
