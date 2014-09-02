REM This script will install 7-zip application 

call ./install_start.cmd 7-zip

echo %msgPrefix%Verifying if 7-zip already installed

IF EXIST %INSTALLATION_DIR%\%SEVENZIP_FOLDER% ( set isinstalled=Y) ELSE ( set isinstalled=N)
IF "%isinstalled%" == "Y" (
	echo %msgPrefix%Software already installed.
	IF "%OVERRIDE_OLD_INSTALLATION%"=="N" (
		echo %msgPrefix%Override old installation flag set to N.
		echo %msgPrefix%Skipping 7zip installation.
		call ./install_skip.cmd 7-zip
		exit /B
	) ELSE (
		echo %msgPrefix%Override old installation flag set to Y.
		echo %msgPrefix%Deleting old 7zip installation.
		call rd %INSTALLATION_DIR%\%SEVENZIP_FOLDER% /s /q
	)
) ELSE (
	echo %msgPrefix%Software not installed
)

echo %msgPrefix%Copying 7zip directory from repository

call robocopy %SOFTWARE_DUMP_DIR%\%SEVENZIP_FOLDER% %INSTALLATION_DIR%\%SEVENZIP_FOLDER% /s /NFL /NDL /nc /ns /np

IF %errorlevel% neq 1 (
	call ./install_failure.cmd 7-zip
) ELSE (
	call ./install_success.cmd 7-zip
)