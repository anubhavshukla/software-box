REM This file is used to check if 7-zip software is already installed.
REM Returns and error code 1 if 7-zip is not installed else 0.

echo.
echo %msgPrefix%Checking if 7-zip is installed [%zip_command%]
IF EXIST %zip_command% (
	echo %msgPrefix%Success! 7-zip installed. Continuing with installation.
	exit /B 0
) ELSE (
	echo %msgPrefix%Failure! 7-zip not installed
	echo %msgPrefix%Please enable installation of 7-zip. Set ZEVENZIP_REQUIRED=Y in config.properties file.
	echo %msgPrefix%Exiting installation.
	exit /B 1
)