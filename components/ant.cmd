REM This script will install ANT application 
set APP_NAME=ANT
set APP_FOLDER=%ANT_FOLDER%
set INSTALLER_FILE=%ANT_ZIP%

call ./install_start.cmd %APP_NAME%

call ./components/check7zip.cmd
IF %errorlevel% neq 0 (
	call ./install_failure.cmd %APP_NAME%
	exit /B
)

echo %msgPrefix%Verifying access to repository location.
echo %msgPrefix%Accessing location %SOFTWARE_DUMP_DIR%\%APP_FOLDER%\%INSTALLER_FILE%.
IF EXIST %SOFTWARE_DUMP_DIR%\%APP_FOLDER%\%INSTALLER_FILE% ( 
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

echo %msgPrefix%Downloading %APP_NAME% zip file[%SOFTWARE_DUMP_DIR%\%APP_FOLDER%\%INSTALLER_FILE%].
call mkdir %INSTALLATION_DIR%\%APP_FOLDER%
call robocopy %SOFTWARE_DUMP_DIR%\%APP_FOLDER% %INSTALLATION_DIR%\ %INSTALLER_FILE% /s /NFL /NDL /nc /ns /np

echo.
echo %msgPrefix%Decompressing zip file.
call %zip_command% -y x %INSTALLATION_DIR%\%INSTALLER_FILE% -o%INSTALLATION_DIR%
IF %errorlevel% neq 0 (
	call ./install_failure.cmd %APP_NAME%
	exit /B
)

echo.
echo %msgPrefix%Cleanup inprogress.
call del %INSTALLATION_DIR%\%INSTALLER_FILE% /q
	
echo %msgPrefix%Setting ANT_HOME to %INSTALLATION_DIR%\%APP_FOLDER%
call setx ANT_HOME %INSTALLATION_DIR%\%APP_FOLDER%
echo %msgPrefix%Adding %INSTALLATION_DIR%\%APP_FOLDER%\bin folder to PATH variable
REM call setx PATH %PATH%;%INSTALLATION_DIR%\%APP_FOLDER%\bin
call ./install_success.cmd %APP_NAME%