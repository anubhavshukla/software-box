@echo off

call ./loadconfig.cmd
IF %errorlevel% neq 0 (
	exit /B 1
)

echo.
echo Dumping old PATH variable value to oldpath.txt
echo %PATH% >> oldpath.txt
call set PATH_SEGMENT=

:: Setting 7-zip environment variables
echo.
echo Set 7-zip environment variables
echo --------------------------------------------------------
set SEVENZIP_INSTALLATION_FOLDER=%INSTALLATION_DIR%\%SEVENZIP_FOLDER%
IF "%SEVENZIP_REQUIRED%"=="Y" (
	echo %msgPrefix%7-zip installation enabled. Updating PATH variable.
	IF EXIST %SEVENZIP_INSTALLATION_FOLDER% (
		echo %msgPrefix%Updating PATH variable with %SEVENZIP_INSTALLATION_FOLDER%.
		call set PATH_SEGMENT=%PATH_SEGMENT%;%SEVENZIP_INSTALLATION_FOLDER%
	) ELSE (
		echo %msgPrefix%Unable to access 7-zip folder [%SEVENZIP_INSTALLATION_FOLDER%].
		echo %msgPrefix%FAILED to update PATH variable.
	)
) ELSE (
	echo %msgPrefix%7-zip installation disabled. Skipping PATH setup
)
echo --------------------------------------------------------

:: Setting ANT environment variables
echo.
echo Set ANT environment variables
echo --------------------------------------------------------
set ANT_INSTALLATION_FOLDER=%INSTALLATION_DIR%\%ANT_FOLDER%
IF "%ANT_REQUIRED%"=="Y" (
	echo %msgPrefix%ANT installation enabled. Updating PATH variable.
	IF EXIST %ANT_INSTALLATION_FOLDER%\bin (
		echo %msgPrefix%Setting ANT_HOME to %ANT_INSTALLATION_FOLDER%
		call setx ANT_HOME %ANT_INSTALLATION_FOLDER%
		echo %msgPrefix%Updating PATH variable with %ANT_INSTALLATION_FOLDER%\bin.
		call set PATH_SEGMENT=%PATH_SEGMENT%;%ANT_INSTALLATION_FOLDER%\bin
	) ELSE (
		echo %msgPrefix%Unable to access ANT folder [%ANT_INSTALLATION_FOLDER%].
		echo %msgPrefix%FAILED to update PATH variable.
	)
) ELSE (
	echo %msgPrefix%ANT installation disabled. Skipping PATH setup
)
echo --------------------------------------------------------
call setx PATH %PATH%%PATH_SEGMENT%