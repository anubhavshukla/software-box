REM This script will install ANT application 
set APP_NAME=JDK
set APP_FOLDER=%JDK_FOLDER%
set APP_EXECUTABLE=%JDK_EXECUTABLE%

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
IF EXIST %INSTALLATION_DIR%\%APP_FOLDER% ( set isinstalled=Y) ELSE ( set isinstalled=N)
IF "%isinstalled%" == "Y" (
	echo %msgPrefix%Software already installed.
	IF "%OVERRIDE_OLD_INSTALLATION%"=="N" (
		echo %msgPrefix%Override old installation flag set to N.
		echo %msgPrefix%Skipping %APP_NAME% installation.
		call ./install_skip.cmd %APP_NAME%
		exit /B
	) ELSE (
		echo %msgPrefix%Override old installation flag set to Y.
		echo %msgPrefix%Deleting old %APP_NAME% installation.
		call rd %INSTALLATION_DIR%\%APP_FOLDER% /s /q
	)
) ELSE (
	echo %msgPrefix%Software not installed
	echo.
)

echo %msgPrefix%Downloading %APP_NAME% installer from repository.
call mkdir %INSTALLATION_DIR%\%APP_FOLDER%
call robocopy %SOFTWARE_DUMP_DIR%\%APP_FOLDER% %INSTALLATION_DIR%\%APP_FOLDER% %APP_EXECUTABLE% /s /NFL /NDL /nc /ns /np

echo.
echo %msgPrefix%Executing installer %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE%.
REM call %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE% /s /INSTALLDIRPUBJRE=%INSTALLATION_DIR%\%APP_FOLDER%

IF %errorlevel% neq 1 (
	call ./install_failure.cmd %APP_NAME%
) ELSE (
	echo %msgPrefix%Setting JAVA_HOME to %INSTALLATION_DIR%\%APP_FOLDER%
	REM call setx ANT_HOME %INSTALLATION_DIR%\%APP_FOLDER%
	echo %msgPrefix%Adding %INSTALLATION_DIR%\%APP_FOLDER%\bin folder to PATH variable
	REM call setx PATH %PATH%;%INSTALLATION_DIR%\%APP_FOLDER%\bin
	echo.
	echo %msgPrefix%Cleanup inprogress.
	call del %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE% /q
	call ./install_success.cmd %APP_NAME%
)