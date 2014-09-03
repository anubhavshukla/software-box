@echo off
set CONFIG_FILE=config.properties

set msgPrefix=---

echo %msgPrefix%Loading configurations from %CONFIG_FILE%
REM Reading configuration properties
IF EXIST %CONFIG_FILE% ( 
	for /F "tokens=*" %%I in (%CONFIG_FILE%) do set %%I
	echo %msgPrefix%Configurations loaded successfully.
	echo %msgPrefix%Continuing with installation.
	echo.
) ELSE (
	echo %msgPrefix%Unable to locate config.properties file.
	echo %msgPrefix%Exiting installation
	call ./install_failure.cmd
	exit /B 1
)

REM Create folder structure
echo %msgPrefix%Creating installation folder [%INSTALLATION_DIR%].
call mkdir %INSTALLATION_DIR%

REM installing 7-zip software
IF "%ZEVENZIP_REQUIRED%"=="Y" (
	call ./components/7zip.cmd
)
set zip_command=%INSTALLATION_DIR%\%SEVENZIP_FOLDER%\7z.exe

echo ------------------------------------------------------------------------

REM installing ANT software
IF "%ANT_REQUIRED%"=="Y" (
	call ./components/ant.cmd
)

echo ------------------------------------------------------------------------

REM installing JDK software
IF "%JDK_REQUIRED%"=="Y" (
	call ./components/jdk.cmd
)