@echo off
set msgPrefix=---

REM Reading configuration properties
for /F "tokens=*" %%I in (config.properties) do set %%I

REM Create folder structure
call mkdir %INSTALLATION_DIR%

REM installing 7-zip software
IF "%ZEVENZIP_REQUIRED%"=="Y" (
	call ./components/7zip.cmd
)

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