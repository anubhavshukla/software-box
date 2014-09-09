:: This script will install SourceTree.
:: Pre-requisites:
:: 1. Microsoft .Net Framework 4.5
:: Installation steps:
:: 1. Copy exe from repository.
:: 2. Execute installer in silent mode.
 
set APP_NAME=Sourecetree
set APP_FOLDER=%SOURCETREE_FOLDER%
set APP_EXECUTABLE=%SOURCETREE_EXECUTABLE%

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
	exit /B 1
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

echo %msgPrefix%Verifying if Microsoft .Net V%DOTNET_VERSION% is installed or not.
call REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s|FIND " Version"|FIND "%DOTNET_VERSION%"
IF %errorlevel% neq 0 (
	echo %msgPrefix%Microsoft .Net V%DOTNET_VERSION% not installed.
	echo %msgPrefix%Microsoft .Net V%DOTNET_VERSION% is required for %APP_NAME%.
	echo %msgPrefix%Enable Microsoft .Net V%DOTNET_VERSION% installation by setting DOTNET_REQUIRED=Y in config.properties file.
	echo %msgPrefix%Exiting installation.
	call ./install_failure.cmd %APP_NAME%
	exit /B 1
) ELSE (
	echo %msgPrefix%Microsoft .Net V%DOTNET_VERSION% is installed.
	echo %msgPrefix%Continuing with %APP_NAME% installation.
	echo.
)

echo %msgPrefix%Downloading %APP_NAME% installer from repository.
call mkdir %INSTALLATION_DIR%\%APP_FOLDER%
call robocopy %SOFTWARE_DUMP_DIR%\%APP_FOLDER% %INSTALLATION_DIR%\%APP_FOLDER% %APP_EXECUTABLE% /s /NFL /NDL /nc /ns /np

echo.
echo %msgPrefix%Executing installer %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE%.
call %INSTALLATION_DIR%\%APP_FOLDER%\%APP_EXECUTABLE% /nogui

IF %errorlevel% neq 0 (
	call ./install_failure.cmd %APP_NAME%
	exit /B 1
)

call ./install_success.cmd %APP_NAME%