@echo off

if "%PRAGMA_ROOT%"=="" set "PRAGMA_ROOT=.."
"%PRAGMA_ROOT%\bin\render_raytracing.exe" %*
