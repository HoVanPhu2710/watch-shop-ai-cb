@echo off
echo Starting Rasa Server...
echo.
echo Server will be available at:
echo - Rasa API: http://localhost:5005
echo - Rasa Action Server: http://localhost:5055
echo.
echo Press Ctrl+C to stop the server
echo.

REM Activate virtual environment
call rasaenv\Scripts\activate

REM Start Rasa server with API enabled
rasa run --enable-api --cors "*" --port 5005

pause
