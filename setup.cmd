@echo off

set msgPrefix=---

call ./loadconfig.cmd
IF %errorlevel% neq 0 (
	exit /B 1
)

:: Create folder structure
echo %msgPrefix%Creating installation folder [%INSTALLATION_DIR%].
call mkdir %INSTALLATION_DIR%

:: Installing 7-zip software
IF "%SEVENZIP_REQUIRED%"=="Y" (
	call ./components/7zip.cmd
	echo ------------------------------------------------------------------------
)
set zip_command=%INSTALLATION_DIR%\%SEVENZIP_FOLDER%\7z.exe


:: Installing ANT software
IF "%ANT_REQUIRED%"=="Y" (
	call ./components/ant.cmd
	echo ------------------------------------------------------------------------
)

:: Installing JDK software
IF "%JDK_REQUIRED%"=="Y" (
	call ./components/jdk.cmd
	echo ------------------------------------------------------------------------
)

:: Installing ANT software
IF "%ECLIPSE_REQUIRED%"=="Y" (
	call ./components/eclipse.cmd
	echo ------------------------------------------------------------------------
)

:: Installing Microsoft .Net Framework
IF "%DOTNET45_REQUIRED%"=="Y" (
	call ./components/dotnet.cmd
	echo ------------------------------------------------------------------------
)