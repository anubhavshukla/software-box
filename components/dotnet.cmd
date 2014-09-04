:: This script will install Microsoft .NET framework version 4.5.
:: Installation steps:
:: 1. Copy exe from repository.
:: 2. Execute installer in silent mode.
:: 3. Check Registry and wait till installation finishes.
 
set APP_NAME=Microsoft .Net Framework
set APP_FOLDER=%DOTNET45_FOLDER%
set APP_EXECUTABLE=%DOTNET45_EXECUTABLE%

call ./install_start.cmd %APP_NAME%

echo %msgPrefix%Verifying access to repository location.
echo %msgPrefix%Accessing location %SOFTWARE_DUMP_DIR%\%APP_FOLDER%\%APP_EXECUTABLE%.
IF EXIST %SOFTWARE_DUMP_DIR%\%APP_FOLDER%\%APP_EXECUTABLE% ( 
	echo %msgPrefix%Success! Continuing with installation.
	echo.
) ELSE ( 
	echo %msgPrefix%Failure! Unable to access repository.
	echo %msgPrefix%Exiting installation.
	call ./install_failure.cmd %APP_NAME%
	exit /B
)

echo %msgPrefix%Verifying if %APP_NAME% already installed
call REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s|FIND " Version"|FIND "%DOTNET_VERSION%"
IF %errorlevel% eq 0 (
	echo %msgPrefix%%APP_NAME% already installed.
	IF "%OVERRIDE_OLD_INSTALLATION%"=="N" (
		echo %msgPrefix%Override old installation flag set to N.
		echo %msgPrefix%Skipping %APP_NAME% installation.
		call ./install_skip.cmd %APP_NAME%
		exit /B
	) ELSE (
		echo %msgPrefix%Override old installation flag set to Y.
		echo %msgPrefix%Updating existing installation.
	)
) ELSE (
	echo %msgPrefix%%APP_NAME% not installed
	echo.
)

echo %msgPrefix%Downloading %APP_NAME% installer from repository [%SOFTWARE_DUMP_DIR%\%APP_FOLDER%].
call mkdir %INSTALLATION_DIR%\%APP_FOLDER%
call robocopy %SOFTWARE_DUMP_DIR%\%APP_FOLDER% %INSTALLATION_DIR%\%APP_FOLDER% %APP_EXECUTABLE% /s /NFL /NDL /nc /ns /np

echo.
echo %msgPrefix%Executing installer %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE%.
call %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE% /q /norestart

IF %errorlevel% neq 0 (
	call ./install_failure.cmd %APP_NAME%
	exit /B 1
)

echo.
echo %msgPrefix%Installing! Please wait ....

:dotnetinstallcheck
call REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s|FIND " Version"|FIND "%DOTNET_VERSION%"
IF %errorlevel% neq 0 (
	timeout /T 2 /NOBREAK > nul
	GOTO :dotnetinstallcheck
)

:: Waiting for 5 secs to allow installer to finish.
timeout /T 5 /NOBREAK > nul

call ./install_success.cmd %APP_NAME%
