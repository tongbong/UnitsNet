@echo off
SET ROOT=%~dp0..
%ROOT%\Tools\7-zip\7za.exe a -tzip %ROOT%\Artifacts\UnitsNet.zip %ROOT%\Artifacts\*
if %errorlevel% neq 0 exit /b %errorlevel%