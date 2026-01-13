@echo off

:: Execute as Administrator

:: Determine NXCUSTOM_START_DIR
set NXCUSTOM_ADMIN_DIR=%~dp0
set NXCUSTOM_ADMIN_DIR=%NXCUSTOM_ADMIN_DIR:~0,-1%
set NXCUSTOM_START_DIR=%NXCUSTOM_ADMIN_DIR:\Admin=%

:: Edit registry
reg add "HKCR\ugmportalfile\Shell\Open\Command" /d "\"%NXCUSTOM_START_DIR%\NXstart.bat\" /nxrac" /f
reg add "HKLM\SOFTWARE\Classes\ugmportalfile\Shell\Open\Command" /d "\"%NXCUSTOM_START_DIR%\NXstart.bat\" /nxrac" /f
if errorlevel 1 (
	color 4f
	echo Command did not succeed, try as administrator
)
pause