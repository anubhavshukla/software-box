set CONFIG_FILE=config.properties

set msgPrefix=---

echo %msgPrefix%Loading configurations from %CONFIG_FILE%
REM Reading configuration properties
IF EXIST %CONFIG_FILE% ( 
	for /F "tokens=*" %%I in (%CONFIG_FILE%) do set %%I
	echo %msgPrefix%Configurations loaded successfully.
	echo %msgPrefix%Continuing with installation.
	echo.
	exit /B 0
) ELSE (
	echo %msgPrefix%Unable to locate config.properties file.
	echo %msgPrefix%Exiting installation
	call ./install_failure.cmd
	exit /B 1
)