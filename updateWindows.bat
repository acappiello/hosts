@echo off

:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::

:checkPrivileges 
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 

:getPrivileges 
if '%1'=='ELEV' (shift & goto gotPrivileges)  
ECHO. 
ECHO *********************************************
ECHO Not running as admin. Triggering UAC prompt.
ECHO *********************************************

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B 

:gotPrivileges 
::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
setlocal & pushd .

@setlocal enableextensions
@cd /d "%~dp0"

ECHO Backing up old hosts file to hosts_old.
MOVE %SystemRoot%\system32\drivers\etc\hosts %SystemRoot%\system32\drivers\etc\hosts_old
ECHO Copying new hosts file.
COPY hosts %SystemRoot%\system32\drivers\etc\hosts
ipconfig /flushdns

PAUSE