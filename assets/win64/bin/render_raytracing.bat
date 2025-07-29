@echo off

if "%PRAGMA_ROOT%"=="" set "PRAGMA_ROOT=."
"%PRAGMA_ROOT%\lib\render_raytracing.exe" %*
