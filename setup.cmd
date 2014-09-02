@echo off
set msgPrefix=---

REM Reading configuration properties
for /F "tokens=*" %%I in (config.properties) do set %%I

REM installing 7-zip software
call ./components/7zip.cmd

echo ------------------------------------------------------------------------

REM installing ANT software
call ./components/ant.cmd

echo ------------------------------------------------------------------------

REM installing JDK software
call ./components/jdk.cmd