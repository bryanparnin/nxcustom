@echo off

:: Execute as Administrator

:: Determine which TC version is installed and set TC_ROOT
set NXCUSTOM_INSTALLED_TC_VERSION=
set TC_ROOT=
setlocal EnableDelayedExpansion
for /f "usebackq tokens=* delims=" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Siemens" 2^> nul`) do (
	set __a=%%~na
	if "!__a!" == "Teamcenter" (
		for /f "usebackq tokens=*" %%b in (`reg query "%%a" 2^> nul`) do (
			set __b=%%~nb
			set NXCUSTOM_INSTALLED_TC_VERSION=!__b:~0,2!
		)
	)
)
if defined NXCUSTOM_INSTALLED_TC_VERSION (
	for /f "usebackq tokens=*" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Siemens\Teamcenter" 2^> nul`) do (
		set __a=%%~na
		if "!__a:~0,2!" == "%NXCUSTOM_INSTALLED_TC_VERSION%" (
			for /f "usebackq tokens=1,2,*" %%b in (`reg query "%%a" 2^> nul`) do (
				if "%%b" == "TC_ROOT" (set TC_ROOT=%%d)
			)
		)
	)
	if not defined TC_ROOT (
		color 4f
		echo No TC_ROOT key found in registry!
		pause
		exit
	)
) else (
	color 4f
	echo No installed Teamcenter found!
	pause
	exit
)
endlocal & (
	set TC_ROOT=%TC_ROOT%
)

:: Edit registry
reg add "HKCR\ugmportalfile\Shell\Open\Command" /d "\"%TC_ROOT%\portal\start_nxmanager.bat\"" /f
reg add "HKLM\SOFTWARE\Classes\ugmportalfile\Shell\Open\Command" /d "\"%TC_ROOT%\portal\start_nxmanager.bat\"" /f
if errorlevel 1 (
	color 4f
	echo Command did not succeed, try as administrator
)
pause