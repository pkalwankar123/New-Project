@echo OFF
title War building and Executing
For /F "tokens=1* delims==" %%A IN (test.properties) DO (
	IF "%%A"=="projectFol" set projectFol=%%B
	IF "%%A"=="sourcePath" set sourcePath=%%B
	IF "%%A"=="destinationPath" set destinationPath=%%B
	IF "%%A"=="libserver" set libserver=%%B
	IF "%%A"=="logpath" set logpath=%%B
	)
cd \
cd %projectFol%\geb-ui\geb-ui-war
call mvn clean
echo Project Cleanned 
call mvn package
echo Project Packed
robocopy  %sourcePath% %destinationPath% /e /COPY:DATSO
echo Packed Project Copied
call %libserver%\bin\server.bat start defaultServer
type %logpath%\logs\console.log
echo Project Started On Server. Check URL above
echo Press ENTER to stop the server
pause >null 
call %libserver%\bin\server.bat stop defaultServer
pause