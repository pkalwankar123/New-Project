@echo OFF
title War building and Executing

set "oldDir=%cd%"
cd..
set "currentDir=%cd%"

echo %currentDir%

For /F "tokens=1* delims==" %%A IN (%oldDir%\temp_test.properties) DO (
	IF "%%A"=="projectFol" set projectFol=%currentDir%\%%B
	IF "%%A"=="sourcePath" set sourcePath=%currentDir%\%%B
	IF "%%A"=="libserver" set libserver=%%B
	::IF "%%A"=="destinationPath" set destinationPath=%libserver%"\usr\servers\defaultServer\apps"
	::IF "%%A"=="logpath" set logpath=%libserver%"\usr\servers\defaultServer\"
	)

set destinationPath=%libserver%\usr\servers\defaultServer\apps
set logpath=%libserver%\usr\servers\defaultServer\

echo  "sourcePath : "%sourcePath%
echo  "libserver : "%libserver%
echo  "destinationPath : "%destinationPath%
	
cd %projectFol%
::cd..

call mvn clean
echo Project Cleanned 
call mvn package
echo Project Packed
copy  %sourcePath%"\*.ear" %destinationPath%

if exist %destinationPath%"\*.ear" (
	echo Packed Project Copied
	call %libserver%\bin\server.bat start defaultServer
	echo Project Starting...
	timeout /t 150 /nobreak>nul
	echo Project Started On Server. Check URLs
	type %logpath%\logs\console.log
	echo Press ENTER to stop the server (Note : Check your eclipse console)
	pause >null 
	call %libserver%\bin\server.bat stop defaultServer
)
pause