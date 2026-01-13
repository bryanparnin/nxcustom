@echo off

:: Execute as Administrator

:: Call scripts
for /f "usebackq" %%a in (`dir /b "%~dp0set*.bat"`) do (
	if "%%a" neq "%~nx0" (echo | call "%~dp0%%a")
)
pause