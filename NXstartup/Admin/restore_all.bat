@echo off

:: Execute as Administrator

if "%1" neq "" (
	set NXCUSTOM_APPLICATION_VERSION=%1
)

:: Determine which NX versions are installed
set NXCUSTOM_INSTALLED_NX_VERSIONS=
setlocal EnableDelayedExpansion
for /f "usebackq tokens=1,2" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Siemens\Installed Products" 2^> nul`) do (
	if "%%a" == "NX" (
		if not defined NXCUSTOM_INSTALLED_NX_VERSIONS (set NXCUSTOM_INSTALLED_NX_VERSIONS=%%b) else (set NXCUSTOM_INSTALLED_NX_VERSIONS=!NXCUSTOM_INSTALLED_NX_VERSIONS! %%b)
	)
)
endlocal & (
	set NXCUSTOM_INSTALLED_NX_VERSIONS=%NXCUSTOM_INSTALLED_NX_VERSIONS%
)
set __a=

:: Ask for version input
:ask_version
echo Installed NX versions found:
for %%a in (%NXCUSTOM_INSTALLED_NX_VERSIONS%) do (
	echo %%a
)
echo:
if not defined NXCUSTOM_APPLICATION_VERSION (
	set /p NXCUSTOM_APPLICATION_VERSION=Which version would you like to restore to?: 
)
:validate_version
set match=false
for %%a in (%NXCUSTOM_INSTALLED_NX_VERSIONS%) do (
	if "%NXCUSTOM_APPLICATION_VERSION%" == "%%a" (set match=true)
)
if "%match%" neq "true" (
	echo:
	echo The version provided was not recognized as being installed!
	echo:
	set NXCUSTOM_APPLICATION_VERSION=
	goto :ask_version
)
set match=

:: Set UGII_BASE_DIR
set UGII_BASE_DIR=
for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Siemens\NX %NXCUSTOM_APPLICATION_VERSION%" 2^> nul`) do (
	if "%%a" equ "UGII_BASE_DIR" set UGII_BASE_DIR=%%c
)
if not defined UGII_BASE_DIR (
	echo No UGII_BASE_DIR key found in registry!
	pause
	exit
)

:: Call scripts
for /f "usebackq" %%a in (`dir /b "%~dp0restore*.bat"`) do (
	if "%%a" neq "%~nx0" (echo | call "%~dp0%%a" /f)
)
pause